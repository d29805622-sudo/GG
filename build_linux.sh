#!/usr/bin/env bash
# RealtimeFaceSwap Linux 打包脚本
# 产出:
#   - 完整版: RealtimeFaceSwap-vX.X.X-Linux-Full.tar.gz (绿色免安装)
#   - 便携版: realtimefaceswap_X.X.X_amd64.deb (需要安装的 deb 包)
# 使用方式: bash build_linux.sh

set -e

VERSION="1.1.1"
ARCH="amd64"

echo "=============================="
echo "RealtimeFaceSwap Linux 打包"
echo "=============================="
echo


# 0. 环境检查

echo "[0/6] 环境检查..."

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

echo "[1/6] 打包后端..."

cd backend

pyinstaller --clean --noconfirm backend.spec

cd ..

echo


# 2. 前端打包

echo "[2/6] 打包前端..."

cd frontend

flutter build linux --release

cd ..

echo


# 3. 启动器打包

echo "[3/6] 打包启动器..."

pyinstaller --clean --noconfirm launcher.spec

echo


# 4. 整理发布目录

echo "[4/6] 整理发布目录..."

rm -rf release
mkdir -p release/backend
mkdir -p release/frontend

cp dist/RealtimeFaceSwap release/
chmod +x release/RealtimeFaceSwap
cp version.json release/
cp README.md release/ 2>/dev/null || true

cp backend/dist/backend release/backend/
chmod +x release/backend/backend
cp backend/settings.json release/backend/

if [ -d backend/models ]; then
    cp -r backend/models release/backend/models
fi

if [ -d frontend/build/linux/x64/release/bundle ]; then
    cp -r frontend/build/linux/x64/release/bundle/* release/frontend/
elif [ -d frontend/build/linux/arm64/release/bundle ]; then
    cp -r frontend/build/linux/arm64/release/bundle/* release/frontend/
    ARCH="arm64"
else
    echo "未找到 Flutter Linux 产物，跳过前端复制"
fi

find release/frontend -type f -exec chmod +x {} \; 2>/dev/null || true

echo


# 5. 完整版（绿色免安装 tar.gz）

echo "[5/6] 打包完整版（绿色免安装）..."

rm -rf dist_packages
mkdir -p dist_packages

FULL_TAR="RealtimeFaceSwap-v${VERSION}-Linux-Full.tar.gz"

tar -czf "dist_packages/${FULL_TAR}" -C release .

echo "  生成: dist_packages/${FULL_TAR}"
echo


# 6. 便携版（deb 安装包）

echo "[6/6] 打包便携版（deb 安装包）..."

DEB_NAME="realtimefaceswap_${VERSION}_${ARCH}"
DEB_DIR="/tmp/${DEB_NAME}"

rm -rf "${DEB_DIR}"
mkdir -p "${DEB_DIR}/DEBIAN"
mkdir -p "${DEB_DIR}/opt/RealtimeFaceSwap"
mkdir -p "${DEB_DIR}/usr/share/applications"
mkdir -p "${DEB_DIR}/usr/share/icons/hicolor/256x256/apps"

cat > "${DEB_DIR}/DEBIAN/control" <<EOF
Package: realtimefaceswap
Version: ${VERSION}
Section: graphics
Priority: optional
Architecture: ${ARCH}
Depends: libgtk-3-0, libx11-6, libgl1, libstdc++6
Maintainer: RealtimeFaceSwap Team
Description: RealtimeFaceSwap - 实时 AI 换脸软件
 基于深度学习的实时视频换脸应用。
 .
 支持摄像头实时采集、人脸检测、AI 换脸推理、Flutter 桌面客户端。
EOF

cat > "${DEB_DIR}/usr/share/applications/RealtimeFaceSwap.desktop" <<EOF
[Desktop Entry]
Name=RealtimeFaceSwap
Comment=实时 AI 换脸软件
Exec=/opt/RealtimeFaceSwap/RealtimeFaceSwap
Icon=realtimefaceswap
Terminal=false
Type=Application
Categories=Graphics;
EOF

cp -r release/* "${DEB_DIR}/opt/RealtimeFaceSwap/"

if command -v dpkg-deb >/dev/null 2>&1; then
    dpkg-deb --build "${DEB_DIR}" "dist_packages/${DEB_NAME}.deb"
    echo "  生成: dist_packages/${DEB_NAME}.deb"
else
    echo "  跳过: 未检测到 dpkg-deb，不生成 deb 包"
fi

rm -rf "${DEB_DIR}"

echo

echo "=============================="
echo "打包完成!"
echo "=============================="
echo
echo "输出目录: dist_packages/"
echo
ls -1 dist_packages/ 2>/dev/null
echo
echo "完整版: 解压后 ./RealtimeFaceSwap 即可运行"
echo "便携版: sudo dpkg -i realtimefaceswap_${VERSION}_${ARCH}.deb 安装"
echo
