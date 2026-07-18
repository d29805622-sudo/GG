import cv2
import base64


def encode(frame):

    result, buffer = cv2.imencode(
        ".jpg",
        frame
    )

    if result:

        return base64.b64encode(
            buffer
        ).decode()

    return None
