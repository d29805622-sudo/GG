from queue import Queue


class FrameQueue:

    def __init__(self, max_size=2):

        self.queue = Queue(
            maxsize=max_size
        )

    def put(self, frame):

        if self.queue.full():

            self.queue.get()

        self.queue.put(frame)

    def get(self):

        if not self.queue.empty():

            return self.queue.get()

        return None
