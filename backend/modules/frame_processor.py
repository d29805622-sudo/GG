import cv2


class FrameProcessor:

    def __init__(self):

        self.enabled = False

    def enable(self):

        self.enabled = True

    def disable(self):

        self.enabled = False

    def process(
        self,
        frame
    ):

        if not self.enabled:

            return frame

        # AI处理入口

        return frame
