# RealtimeFaceSwap

实时 AI 视频处理软件。

## Features

- Real-time camera processing
- AI face analysis pipeline
- GPU acceleration support
- Flutter desktop/mobile client
- WebSocket low latency streaming

## Architecture

```
Camera
   ↓
Python Backend
   ↓
AI Processing
   ↓
WebSocket
   ↓
Flutter Client
```

## Requirements

### Backend

- Python 3.12
- OpenCV
- FastAPI
- ONNX Runtime

### Client

- Flutter 3.x

## Run Backend

```
cd backend
pip install -r requirements.txt
python app.py
```

## Run Frontend

```
cd frontend
flutter pub get
flutter run
```

## Build Windows Release

```
build_windows.bat
```

输出目录：`release/`

## Project Structure

```
RealtimeFaceSwap/
├── backend/          Python 后端
├── frontend/         Flutter 客户端
├── models/           AI 模型
├── installer/        安装脚本
├── docs/             文档
├── launcher.py       启动器
└── build_windows.bat 一键打包
```

## Version

v1.0.0
