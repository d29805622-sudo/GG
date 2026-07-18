import os
import cv2
import numpy as np

from modules.ai_engine import AIEngine
from modules.model_manager import ModelManager


class FrameProcessor:

    def __init__(self):

        self.enabled = False

        self.model_manager = ModelManager()

        self.engine = AIEngine()

        self.swap_model_path = None

        self.target_embedding = None

        self._swap_loaded = False

    def set_swap_model(self, model_path):

        if not os.path.exists(model_path):

            raise FileNotFoundError(model_path)

        self.swap_model_path = model_path

        try:

            self.engine.load(model_path)

            self._swap_loaded = True

        except Exception as e:

            print("加载换脸模型失败:", e)

            self._swap_loaded = False

    def set_target_embedding(self, embedding):

        if embedding is None:

            self.target_embedding = None

            return

        self.target_embedding = np.asarray(
            embedding,
            dtype=np.float32
        )

    def enable(self):

        self.enabled = True

    def disable(self):

        self.enabled = False

    def _align_face(self, frame, landmark, size=128):

        src = np.asarray(landmark, dtype=np.float32)

        dst = np.array([
            [38.2946, 51.6963],
            [73.5318, 51.5014],
            [56.0252, 71.7366],
            [41.5493, 92.3655],
            [70.7299, 92.2041]
        ], dtype=np.float32) * (size / 112.0)

        matrix = cv2.estimateAffinePartial2D(
            src, dst
        )[0]

        if matrix is None:

            return None, None

        aligned = cv2.warpAffine(
            frame, matrix,
            (size, size),
            borderValue=0.0
        )

        return aligned, matrix

    def _postprocess(self, swapped):

        out = np.transpose(swapped, (1, 2, 0))

        out = (out + 1.0) * 127.5

        out = np.clip(out, 0, 255).astype(np.uint8)

        return out

    def _blend(self, background, face_img, matrix, size=128):

        mask = np.ones(
            (size, size, 1),
            dtype=np.float32
        )

        warped_mask = cv2.warpAffine(
            mask, matrix,
            (background.shape[1], background.shape[0]),
            borderValue=0.0
        )

        warped_face = cv2.warpAffine(
            face_img, matrix,
            (background.shape[1], background.shape[0]),
            borderValue=0.0
        )

        mask_blur = cv2.GaussianBlur(
            warped_mask,
            (21, 21),
            0
        )

        mask_blur = mask_blur[..., None]

        blended = (
            warped_face * mask_blur +
            background * (1.0 - mask_blur)
        )

        return blended.astype(np.uint8)

    def _swap_one(self, frame, landmark):

        if not self._swap_loaded:

            return frame

        aligned, matrix = self._align_face(
            frame, landmark
        )

        if aligned is None:

            return frame

        blob = cv2.cvtColor(
            aligned,
            cv2.COLOR_BGR2RGB
        )

        blob = (blob - 127.5) / 127.5

        blob = np.transpose(blob, (2, 0, 1))

        blob = np.expand_dims(blob, axis=0).astype(np.float32)

        result = self.engine.run(blob)

        if result is None:

            return frame

        swapped = self._postprocess(result[0][0])

        swapped = cv2.cvtColor(
            swapped,
            cv2.COLOR_RGB2BGR
        )

        inv_matrix = cv2.invertAffineTransform(matrix)

        return self._blend(frame, swapped, inv_matrix)

    def process(self, frame, faces=None):

        if not self.enabled:

            return frame

        if self.swap_model_path is None:

            return frame

        if not self._swap_loaded:

            return frame

        if frame is None:

            return None

        if faces is None:

            return frame

        output = frame

        for face in faces:

            landmark = face.get("landmark") if isinstance(face, dict) else None

            if landmark is None:

                continue

            output = self._swap_one(output, landmark)

        return output
