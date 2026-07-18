import numpy as np


class FaceEncoder:

    def __init__(self):

        self.embedding_size = 512

    def encode(
        self,
        face_image
    ):

        if face_image is None:

            return None

        face_array = np.asarray(
            face_image,
            dtype=np.float32
        )

        face_array = (face_array - 127.5) / 127.5

        embedding = face_array.flatten()[:self.embedding_size]

        norm = np.linalg.norm(embedding)

        if norm > 0:

            embedding = embedding / norm

        return embedding.tolist()

    def similarity(
        self,
        embedding_a,
        embedding_b
    ):

        if embedding_a is None or embedding_b is None:

            return 0.0

        a = np.asarray(embedding_a)

        b = np.asarray(embedding_b)

        dot = np.dot(a, b)

        return float(dot)
