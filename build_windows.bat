@echo off

chcp 65001 >nul

echo ==============================
echo RealtimeFaceSwap Windows 打包
echo ==============================
echo.


REM 后端打包

echo [1/3] 打包后端...

cd backend

pyinstaller --onefile --name backend app.py

cd ..

echo.


REM 前端打包

echo [2/3] 打包前端...

cd frontend

flutter build windows

cd ..

echo.


REM 启动器打包

echo [3/3] 打包启动器...

pyinstaller --onefile --name RealtimeFaceSwap launcher.py

echo.


REM 整理发布目录

echo 整理发布目录...

if exist release rmdir /s /q release

mkdir release

mkdir release\backend

mkdir release\frontend

copy dist\RealtimeFaceSwap.exe release\

copy version.json release\

copy README.txt release\

copy backend\dist\backend.exe release\backend\

copy backend\settings.json release\backend\

xcopy backend\models release\backend\models /E /I /Y

xcopy frontend\build\windows\runner\Release release\frontend /E /I /Y

echo.

echo ==============================

echo 打包完成!

echo 输出目录: release\

echo ==============================

pause
