import subprocess
import time
import os
import sys


def start_backend():

    backend_exe = os.path.join(
        "backend",
        "backend.exe"
    )

    if not os.path.exists(backend_exe):

        print(
            "后端程序不存在:",
            backend_exe
        )

        return None

    process = subprocess.Popen(
        [
            backend_exe
        ]
    )

    time.sleep(3)

    return process


def start_frontend():

    frontend_exe = os.path.join(
        "frontend",
        "app.exe"
    )

    if not os.path.exists(frontend_exe):

        print(
            "客户端程序不存在:",
            frontend_exe
        )

        return None

    process = subprocess.Popen(
        [
            frontend_exe
        ]
    )

    return process


if __name__ == "__main__":

    print("启动 RealtimeFaceSwap...")

    backend = start_backend()

    frontend = start_frontend()

    if backend is None or frontend is None:

        print(
            "启动失败，请检查文件完整性"
        )

        input("按回车键退出...")

        sys.exit(1)

    print("启动完成")

    try:

        frontend.wait()

    except KeyboardInterrupt:

        pass

    finally:

        if backend:

            backend.terminate()

        print("已退出")
