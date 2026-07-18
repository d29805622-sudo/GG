import subprocess
import time
import os
import sys


IS_WINDOWS = sys.platform.startswith("win")
IS_LINUX = sys.platform.startswith("linux")
IS_MACOS = sys.platform == "darwin"


def _exe_name(name):
    """根据操作系统返回可执行文件名"""

    if IS_WINDOWS:
        return name + ".exe"

    return name


def _resolve_bin(directory, name):
    """优先查找打包后的可执行文件，找不到则回退到源码入口"""

    bin_path = os.path.join(directory, _exe_name(name))

    if os.path.exists(bin_path):
        return {"type": "binary", "path": bin_path}

    if directory == "backend":

        app_py = os.path.join("backend", "app.py")

        if os.path.exists(app_py):
            return {"type": "python", "path": app_py}

    if directory == "frontend":

        pubspec = os.path.join("frontend", "pubspec.yaml")

        if os.path.exists(pubspec):
            return {"type": "flutter", "path": os.path.join("frontend")}

    return None


def _spawn(cmd, cwd=None):

    try:

        return subprocess.Popen(
            cmd,
            cwd=cwd
        )

    except FileNotFoundError as e:

        print("启动失败:", e)

        return None


def start_backend():

    target = _resolve_bin("backend", "backend")

    if target is None:

        print("后端程序不存在: backend/")

        return None

    if target["type"] == "binary":

        print("启动后端(打包):", target["path"])

        return _spawn([target["path"]])

    if target["type"] == "python":

        print("启动后端(源码):", target["path"])

        return _spawn(
            [sys.executable, target["path"]],
            cwd="backend"
        )

    return None


def start_frontend():

    target = _resolve_bin("frontend", "app")

    if target is None:

        print("客户端程序不存在: frontend/")

        return None

    if target["type"] == "binary":

        print("启动客户端(打包):", target["path"])

        return _spawn([target["path"]])

    if target["type"] == "flutter":

        print("启动客户端(Flutter run)...")

        return _spawn(
            ["flutter", "run", "-d", "linux" if IS_LINUX else "windows" if IS_WINDOWS else "macos"],
            cwd=target["path"]
        )

    return None


if __name__ == "__main__":

    print("启动 RealtimeFaceSwap...")

    print("系统:", sys.platform)

    backend = start_backend()

    if backend is not None:

        time.sleep(3)

    frontend = start_frontend()

    if backend is None or frontend is None:

        print("启动失败，请检查文件完整性")

        try:
            input("按回车键退出...")
        except EOFError:
            pass

        if backend:
            backend.terminate()

        sys.exit(1)

    print("启动完成")

    try:

        frontend.wait()

    except KeyboardInterrupt:

        pass

    finally:

        if backend:

            backend.terminate()

            try:
                backend.wait(timeout=5)
            except subprocess.TimeoutExpired:
                backend.kill()

        print("已退出")
