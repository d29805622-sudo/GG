import threading
import time


class CameraThread:

    def __init__(
        self,
        camera,
        queue
    ):

        self.camera = camera
        self.queue = queue

        self.running = False

    def start(self):

        self.running = True

        threading.Thread(
            target=self.loop,
            daemon=True
        ).start()

    def loop(self):

        while self.running:

            frame = self.camera.get_frame()

            if frame is not None:

                self.queue.put(
                    frame
                )

            time.sleep(
                0.01
            )

    def stop(self):

        self.running = False
