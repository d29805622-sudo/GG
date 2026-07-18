# 开发文档

## 开发环境

### 后端

- Python 3.12+
- CUDA（可选，GPU 加速）

### 前端

- Flutter 3.x
- Dart 3.x

## 开发准备

### 后端

```
cd backend
pip install -r requirements.txt
```

### 前端

```
cd frontend
flutter pub get
```

### 模型

将 ONNX 模型放入 `models/` 目录，详见 [models/README.md](../models/README.md)。

## 开发运行

### 后端

```
cd backend
uvicorn app:app --host 0.0.0.0 --port 8000 --reload
```

### 前端

修改 `lib/config/server_config.dart` 中 `websocketURL` 为后端 IP。

```
cd frontend
flutter run
```

## 配置说明

### backend/settings.json

| 字段 | 说明 | 默认值 |
|------|------|--------|
| camera | 摄像头编号 | 0 |
| resolution | 分辨率 | 1280x720 |
| gpu | GPU 加速 | true |
| model | 模型名称 | default |

### 用户配置

运行时用户配置保存在 `backend/user.json`。

## 打包

### Windows 打包

```
build_windows.bat
```

输出：`release/` 目录

### 手动打包

后端：

```
cd backend
pyinstaller --onefile --name backend app.py
```

启动器：

```
pyinstaller --onefile --name RealtimeFaceSwap launcher.py
```

前端：

```
cd frontend
flutter build windows
```

## 模块扩展

### 新增 AI 处理

修改 `backend/modules/frame_processor.py` 的 `process()` 方法。

### 新增前端页面

1. 在 `frontend/lib/pages/` 新建页面
2. 在 `main.dart` 或导航中接入路由

## 日志

- 运行日志：`backend/realtime.log`
- 崩溃日志：`backend/crash_YYYYMMDD_HHMMSS.log`

## 版本规划

- v1.0 发布版 ✅
- v1.1 插件系统 / 多平台支持（计划中）
