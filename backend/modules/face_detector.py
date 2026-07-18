import insightface
from insightface.app import FaceAnalysis


class FaceDetector:

    def __init__(self):

        self.app = FaceAnalysis(
            name="buffalo_l"
        )

        self.app.prepare(
            ctx_id=0,
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
