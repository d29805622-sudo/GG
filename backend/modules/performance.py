import time


class FPSCounter:

    def __init__(self):

        self.last = time.time()

        self.frames = 0

        self.fps = 0

    def update(self):

        self.frames += 1

        now = time.time()

        if now - self.last >= 1:

            self.fps = self.frames

            self.frames = 0

            self.last = now

        return self.fps
