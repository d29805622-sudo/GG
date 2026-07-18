@echo off

chcp 65001 >nul

echo ==============================
echo RealtimeFaceSwap Windows 打包
echo ==============================
echo.


REM 0. 环境检查

echo [0/4] 环境检查...

where python >nul 2>&1
if errorlevel 1 (
    echo 缺少 python，请先安装 Python 3.10+ 并加入 PATH
    pause
    exit /b 1
)

where flutter >nul 2>&1
if errorlevel 1 (
    echo 缺少 flutter，请先安装 Flutter 并配置 Windows desktop
    echo   flutter config --enable-windows-desktop
    pause
    exit /b 1
)

python -c "import PyInstaller" 2>nul
if errorlevel 1 (
    echo 安装 PyInstaller...
    pip install pyinstaller
)

if not exist backend\venv (
    echo 提示: 建议为后端创建虚拟环境
)

if not exist backend\requirements_installed (
    echo 安装后端依赖...
    cd backend
    pip install -r requirements.txt
    echo done > requirements_installed
    cd ..
)

echo.


REM 1. 后端打包

echo [1/4] 打包后端...

cd backend

pyinstaller --clean --noconfirm backend.spec

cd ..

echo.


REM 2. 前端打包

echo [2/4] 打包前端...

cd frontend

flutter build windows --release

cd ..

echo.


REM 3. 启动器打包

echo [3/4] 打包启动器...

if exist launcher.spec (
    pyinstaller --clean --noconfirm launcher.spec
) else (
    pyinstaller --onefile --name RealtimeFaceSwap launcher.py
)

echo.


REM 4. 整理发布目录

echo [4/4] 整理发布目录...

if exist release rmdir /s /q release

mkdir release
mkdir release\backend
mkdir release\frontend

copy dist\RealtimeFaceSwap.exe release\
copy version.json release\
if exist README.md copy README.md release\

copy backend\dist\backend.exe release\backend\
copy backend\settings.json release\backend\

if exist backend\models (
    xcopy backend\models release\backend\models /E /I /Y
)

if exist frontend\build\windows\x64\runner\Release (
    xcopy frontend\build\windows\x64\runner\Release release\frontend /E /I /Y
) else (
    xcopy frontend\build\windows\runner\Release release\frontend /E /I /Y
)

echo.

echo ==============================
echo 打包完成!
echo 输出目录: release\
echo 运行: release\RealtimeFaceSwap.exe
echo ==============================

pause
