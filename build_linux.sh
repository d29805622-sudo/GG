#!/usr/bin/env bash
# RealtimeFaceSwap Linux 打包脚本
# 使用方式: bash build_linux.sh

set -e

echo "=============================="
echo "RealtimeFaceSwap Linux 打包"
echo "=============================="
echo


# 0. 环境检查

echo "[0/3] 环境检查..."

if ! command -v python3 >/dev/null 2>&1; then
    echo "缺少 python3，请先安装"
    exit 1
fi

if ! command -v flutter >/dev/null 2>&1; then
    echo "缺少 flutter，请先安装并配置 Linux desktop 支持"
    echo "  flutter config --enable-linux-desktop"
    exit 1
fi

if ! python3 -c "import PyInstaller" 2>/dev/null; then
    echo "安装 PyInstaller..."
    pip3 install pyinstaller
fi

echo


# 1. 后端打包

echo "[1/3] 打包后端..."

cd backend

pyinstaller --onefile --name backend app.py

cd ..

echo


# 2. 前端打包

echo "[2/3] 打包前端..."

cd frontend

flutter build linux

cd ..

echo


# 3. 启动器打包

echo "[3/3] 打包启动器..."

pyinstaller --onefile --name RealtimeFaceSwap launcher.py

echo


# 整理发布目录

echo "整理发布目录..."

rm -rf release
mkdir -p release/backend
mkdir -p release/frontend

cp dist/RealtimeFaceSwap release/
cp version.json release/
cp README.md release/ 2>/dev/null || true

cp backend/dist/backend release/backend/
cp backend/settings.json release/backend/

if [ -d backend/models ]; then
    cp -r backend/models release/backend/models
fi

if [ -d frontend/build/linux/x64/release/bundle ]; then
    cp -r frontend/build/linux/x64/release/bundle/* release/frontend/
elif [ -d frontend/build/linux/arm64/release/bundle ]; then
    cp -r frontend/build/linux/arm64/release/bundle/* release/frontend/
else
    echo "未找到 Flutter Linux 产物，跳过前端复制"
fi

echo

echo "=============================="
echo "打包完成!"
echo "输出目录: release/"
echo "运行: cd release && ./RealtimeFaceSwap"
echo "=============================="
