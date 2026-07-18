import json


with open(
    "settings.json",
    "r",
    encoding="utf-8"
) as f:

    settings = json.load(f)


CAMERA_ID = settings["camera"]

GPU_ENABLE = settings["gpu"]

MODEL = settings["model"]

WIDTH = 1280
HEIGHT = 720

HOST = "0.0.0.0"
PORT = 8000
