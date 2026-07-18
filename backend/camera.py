import cv2

from config import CAMERA_ID, WIDTH, HEIGHT


class Camera:

    def __init__(self):

        self.cap = cv2.VideoCapture(
            CAMERA_ID
        )

        self.cap.set(
            cv2.CAP_PROP_FRAME_WIDTH,
            WIDTH
        )

        self.cap.set(
            cv2.CAP_PROP_FRAME_HEIGHT,
            HEIGHT
        )

        if not self.cap.isOpened():

            raise RuntimeError(
                f"无法打开摄像头 {CAMERA_ID}，请检查设备或 camera 配置"
            )

    def get_frame(self):

        ok, frame = self.cap.read()

        if ok:
            return frame

        return None

    def close(self):

        if self.cap is not None and self.cap.isOpened():

            self.cap.release()

        self.cap = None
