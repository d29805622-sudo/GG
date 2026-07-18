import os
import sys
import time
import asyncio

from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

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


# 全局共享对象（只读或线程安全）
face_detector = FaceDetector()

frame_processor = FrameProcessor()

fps_counter = FPSCounter()


state = {
    "running": False,
    "last_faces": 0,
    "latency_ms": 0.0,
    "started_at": None
}


def _app_dir():
    """返回后端运行目录，兼容源码与 PyInstaller 打包模式"""

    if getattr(sys, "frozen", False):
        return os.path.dirname(os.path.abspath(sys.executable))

    return os.path.dirname(os.path.abspath(__file__))


def _try_load_swap_model():
    """启动时尝试加载默认换脸模型，无则跳过"""

    default_path = os.path.join(_app_dir(), "models", "swap.onnx")

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
            if state["started_at"] and state["running"] else 0
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


def _process_frame_sync(camera, faces_detected):
    """同步执行：取帧 → 检测 → 换脸 → 编码。在线程池中调用"""

    frame = camera.get_frame()

    if frame is None:
        return None, 0

    faces = face_detector.detect(frame)

    faces_detected[0] = len(faces)

    frame = frame_processor.process(frame, faces)

    return encode(frame), len(faces)


@app.websocket("/camera")
async def camera_ws(websocket: WebSocket):

    await websocket.accept()

    # 每个 WebSocket 会话使用独立 Camera 实例，避免多客户端冲突
    try:
        camera = Camera()
    except Exception as e:
        await websocket.send_text(f"ERROR: {e}")
        await websocket.close()
        return

    state["running"] = True
    state["started_at"] = time.time()

    loop = asyncio.get_event_loop()

    try:

        while True:

            t0 = time.time()

            # 用 run_in_executor 把同步阻塞调用丢到线程池，
            # 避免阻塞事件循环导致 HTTP 接口无响应
            faces_detected = [0]
            data, n_faces = await loop.run_in_executor(
                None,
                _process_frame_sync,
                camera,
                faces_detected
            )

            state["last_faces"] = n_faces
            fps_counter.update()
            state["latency_ms"] = (time.time() - t0) * 1000

            if data:
                await websocket.send_text(data)

            await asyncio.sleep(0.01)

    except WebSocketDisconnect:
        pass

    except Exception as e:
        print("WebSocket 异常:", e)

    finally:
        # 关键：释放摄像头资源
        try:
            camera.close()
        except Exception:
            pass

        state["running"] = False
        state["started_at"] = None


if __name__ == "__main__":

    import uvicorn

    uvicorn.run(app, host=HOST, port=PORT)
