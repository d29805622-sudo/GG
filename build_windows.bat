@echo off

chcp 65001 >nul

echo ==============================
echo RealtimeFaceSwap Windows 打包
echo ==============================
echo.


REM 0. 环境检查

echo [0/6] 环境检查...

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

if not exist backend\requirements_installed (
    echo 安装后端依赖...
    cd backend
    pip install -r requirements.txt
    echo done > requirements_installed
    cd ..
)

echo.


REM 1. 后端打包

echo [1/6] 打包后端...

cd backend

pyinstaller --clean --noconfirm backend.spec

cd ..

echo.


REM 2. 前端打包

echo [2/6] 打包前端...

cd frontend

flutter build windows --release

cd ..

echo.


REM 3. 启动器打包

echo [3/6] 打包启动器...

if exist launcher.spec (
    pyinstaller --clean --noconfirm launcher.spec
) else (
    pyinstaller --onefile --name RealtimeFaceSwap launcher.py
)

echo.


REM 4. 整理发布目录

echo [4/6] 整理发布目录...

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


REM 5. 完整版（绿色免安装 zip）

echo [5/6] 打包完整版（绿色免安装）...

if exist dist_packages rmdir /s /q dist_packages
mkdir dist_packages

set ZIP_NAME=RealtimeFaceSwap-v1.1.1-Windows-Full.zip

powershell -Command "Compress-Archive -Path release\* -DestinationPath dist_packages\%ZIP_NAME% -Force"

echo   生成: dist_packages\%ZIP_NAME%
echo.


REM 6. 便携版（Inno Setup 安装包）

echo [6/6] 打包便携版（安装包）...

where iscc >nul 2>&1
if errorlevel 1 (
    echo 未检测到 Inno Setup（iscc），跳过安装包生成
    echo 如需生成安装包，请安装 Inno Setup: https://jrsoftware.org/isdl.php
    goto :skip_installer
)

cd installer

iscc setup.iss

cd ..

if exist installer\output (
    copy installer\output\*.exe dist_packages\
)

:skip_installer

echo.

echo ==============================
echo 打包完成!
echo ==============================
echo.
echo 输出目录: dist_packages\
echo.
if exist dist_packages (
    for %%f in (dist_packages\*) do echo   - %%~nf%%~xf
)
echo.
echo 完整版: 解压后双击 RealtimeFaceSwap.exe 即可使用
echo 便携版: 双击 Setup.exe 安装后从桌面/开始菜单启动
echo.

pause
