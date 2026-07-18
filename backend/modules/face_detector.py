import insightface
from insightface.app import FaceAnalysis

from config import GPU_ENABLE, MODEL


class FaceDetector:

    def __init__(self):

        model_name = MODEL if MODEL and MODEL != "default" else "buffalo_l"

        self.app = FaceAnalysis(
            name=model_name
        )

        # ctx_id=0 使用 GPU，-1 使用 CPU
        ctx_id = 0 if GPU_ENABLE else -1

        self.app.prepare(
            ctx_id=ctx_id,
            det_size=(640, 640)
        )

    def detect(self, frame):

        faces = self.app.get(
            frame
        )

        result = []

        for face in faces:

            result.append({

                "bbox": face.bbox.tolist(),

                "landmark": face.kps.tolist(),

                "score": float(face.det_score)

            })

        return result
