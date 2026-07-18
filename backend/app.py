from fastapi import FastAPI, WebSocket
import asyncio

from camera import Camera
from modules.stream import encode
from modules.face_detector import FaceDetector
from modules.frame_processor import FrameProcessor


app = FastAPI()

camera = Camera()

face_detector = FaceDetector()

frame_processor = FrameProcessor()


@app.get("/")
def index():

    return {
        "name": "RealtimeFaceSwap",
        "version": "0.5"
    }


@app.websocket("/camera")
async def camera_ws(
    websocket: WebSocket
):

    await websocket.accept()

    while True:

        frame = camera.get_frame()

        if frame is not None:

            faces = face_detector.detect(
                frame
            )

            print(
                "检测到:",
                len(faces),
                "张脸"
            )

            frame = frame_processor.process(
                frame
            )

            data = encode(frame)

            await websocket.send_text(
                data
            )

        await asyncio.sleep(
            0.03
        )
