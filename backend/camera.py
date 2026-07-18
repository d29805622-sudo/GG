import cv2

from config import *


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

    def get_frame(self):

        ok, frame = self.cap.read()

        if ok:
            return frame

        return None

    def close(self):

        self.cap.release()
