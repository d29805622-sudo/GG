# 架构文档

## 系统架构

```
┌─────────────┐     WebSocket     ┌──────────────┐
│  Flutter    │ ◄──────────────► │   Backend    │
│  Client     │   视频流传输       │  (FastAPI)   │
└─────────────┘                  └──────┬───────┘
                                        │
                          ┌─────────────┼─────────────┐
                          │             │             │
                   ┌──────▼─────┐ ┌─────▼──────┐ ┌────▼─────┐
                   │  Camera    │ │ FaceDetect │ │ AIEngine │
                   │  (OpenCV)  │ │ (Insight)  │ │ (ONNX)   │
                   └────────────┘ └────────────┘ └──────────┘
```

## 模块说明

### Backend (Python)

| 模块 | 说明 |
|------|------|
| `app.py` | FastAPI 入口，HTTP + WebSocket |
| `config.py` | 配置读取（settings.json） |
| `camera.py` | 摄像头采集 |
| `logger.py` | 日志系统 |
| `crash_handler.py` | 崩溃记录 |
| `user_config.py` | 用户配置持久化 |
| `update_checker.py` | 更新检查 |
| `modules/stream.py` | Base64 编码 |
| `modules/face_detector.py` | 人脸检测（InsightFace） |
| `modules/face_encoder.py` | 人脸特征向量 |
| `modules/ai_engine.py` | ONNX 推理引擎 |
| `modules/frame_processor.py` | 帧处理接口 |
| `modules/frame_queue.py` | 帧队列（防积压） |
| `modules/camera_thread.py` | 采集线程 |
| `modules/performance.py` | FPS 统计 |
| `modules/device_manager.py` | 摄像头枚举 |
| `modules/model_manager.py` | 模型路径管理 |

### Frontend (Flutter)

| 模块 | 说明 |
|------|------|
| `main.dart` | App 入口 |
| `pages/home_page.dart` | 主界面 |
| `pages/settings_page.dart` | 设置页 |
| `pages/monitor_page.dart` | 性能监控 |
| `pages/about_page.dart` | 软件信息 |
| `widgets/video_view.dart` | 视频显示 |
| `widgets/control_bar.dart` | 控制栏 |
| `widgets/status_card.dart` | 状态卡片 |
| `widgets/setting_item.dart` | 设置项 |
| `services/websocket_service.dart` | WebSocket 服务 |
| `services/config_service.dart` | 配置读写 |

### AI 模块

- 人脸检测：InsightFace (buffalo_l)
- 人脸编码：512 维特征向量
- 推理引擎：ONNX Runtime (GPU/CPU 自动)

## 数据流

1. CameraThread 采集视频帧 → FrameQueue
2. 主循环从队列取帧
3. FaceDetector 检测人脸位置和关键点
4. FaceEncoder 提取特征向量
5. FrameProcessor 处理帧（AI 入口）
6. stream.encode 编码为 Base64
7. WebSocket 发送到 Flutter 客户端
8. VideoView 解码显示

## 多线程架构

```
CameraThread (daemon)
    ↓ put()
FrameQueue (max_size=2, 满则丢旧帧)
    ↓ get()
主处理循环
    ↓
WebSocket send
```

## 版本历程

- v0.1 项目基础架构 ✅
- v0.2 Flutter 客户端 ✅
- v0.3 人脸检测模块 ✅
- v0.5 AI 推理框架 ✅
- v0.6 多线程优化 ✅
- v0.7 软件功能完善 ✅
- v0.8 Windows 打包 ✅
- v0.9 软件完善 ✅
- v1.0 发布版 ✅
