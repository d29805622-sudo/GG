import os
import time
import json

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
import asyncio

from camera import Camera
from config import HOST, PORT, GPU_ENABLE, MODEL, CAMERA_ID, WIDTH, HEIGHT
from modules.stream import encode
from modules.face_detector import FaceDetector
from modules.frame_processor import FrameProcessor
from modules.performance import FPSCounter


VERSION = "1.1.1"


app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"]
)


camera = Camera()

face_detector = FaceDetector()

frame_processor = FrameProcessor()

fps_counter = FPSCounter()


state = {
    "running": False,
    "last_faces": 0,
    "latency_ms": 0.0,
    "started_at": None
}


def _try_load_swap_model():
    """启动时尝试加载默认换脸模型，无则跳过"""

    default_path = os.path.join(
        "models", "swap.onnx"
    )

    if os.path.exists(default_path):

        try:
            frame_processor.set_swap_model(default_path)
            print("已加载换脸模型:", default_path)
        except Exception as e:
            print("换脸模型加载失败:", e)


_try_load_swap_model()


class SwapModelPayload(BaseModel):
    model_path: str


class ControlPayload(BaseModel):
    action: str


@app.get("/")
def index():

    return {
        "name": "RealtimeFaceSwap",
        "version": VERSION,
        "platform": os.name
    }


@app.get("/api/status")
def status():

    return {
        "running": state["running"],
        "fps": fps_counter.fps,
        "faces": state["last_faces"],
        "latency_ms": round(state["latency_ms"], 1),
        "gpu_enabled": GPU_ENABLE,
        "model": MODEL,
        "camera": CAMERA_ID,
        "resolution": f"{WIDTH}x{HEIGHT}",
        "started_at": state["started_at"],
        "uptime": (
            int(time.time() - state["started_at"])
            if state["started_at"] else 0
        )
    }


@app.get("/api/devices")
def list_devices():
    """枚举可用摄像头索引"""

    from modules.device_manager import DeviceManager

    dm = DeviceManager()

    return {"devices": dm.list_camera()}


@app.post("/api/swap/model")
def set_swap_model(payload: SwapModelPayload):

    frame_processor.set_swap_model(payload.model_path)

    return {"ok": True, "path": payload.model_path}


@app.post("/api/swap/control")
def swap_control(payload: ControlPayload):

    if payload.action == "enable":
        frame_processor.enable()
    elif payload.action == "disable":
        frame_processor.disable()
    else:
        return {"ok": False, "reason": "unknown action"}

    return {"ok": True, "enabled": frame_processor.enabled}


@app.websocket("/camera")
async def camera_ws(websocket: WebSocket):

    await websocket.accept()

    state["running"] = True
    state["started_at"] = time.time()

    try:

        while True:

            t0 = time.time()

            frame = camera.get_frame()

            if frame is not None:

                faces = face_detector.detect(frame)

                state["last_faces"] = len(faces)

                frame = frame_processor.process(frame, faces)

                data = encode(frame)

                fps_counter.update()

                state["latency_ms"] = (time.time() - t0) * 1000

                if data:
                    await websocket.send_text(data)

            await asyncio.sleep(0.03)

    except WebSocketDisconnect:
        pass

    except Exception as e:
        print("WebSocket 异常:", e)

    finally:
        state["running"] = False


if __name__ == "__main__":

    import uvicorn

    uvicorn.run(app, host=HOST, port=PORT)
