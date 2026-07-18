import os
import sys
import json


def _config_dir():
    """返回配置文件所在目录，兼容源码与 PyInstaller 打包模式"""

    if getattr(sys, "frozen", False):
        return os.path.dirname(os.path.abspath(sys.executable))

    return os.path.dirname(os.path.abspath(__file__))


def _load_settings():
    """读取 settings.json，失败时返回默认配置"""

    config_path = os.path.join(_config_dir(), "settings.json")

    defaults = {
        "camera": 0,
        "resolution": "1280x720",
        "gpu": False,
        "model": "default"
    }

    try:

        with open(config_path, "r", encoding="utf-8") as f:

            data = json.load(f)

            if isinstance(data, dict):

                defaults.update(data)

    except Exception as e:

        print("读取 settings.json 失败，使用默认值:", e)

    return defaults


def _parse_resolution(value, default=(1280, 720)):
    """解析 "1280x720" 格式"""

    try:

        if isinstance(value, str) and "x" in value:

            w, h = value.lower().split("x", 1)

            return int(w), int(h)

    except Exception:
        pass

    return default


settings = _load_settings()

CAMERA_ID = settings.get("camera", 0)

GPU_ENABLE = bool(settings.get("gpu", False))

MODEL = settings.get("model", "default")

WIDTH, HEIGHT = _parse_resolution(settings.get("resolution", "1280x720"))

HOST = "0.0.0.0"
PORT = 8000
