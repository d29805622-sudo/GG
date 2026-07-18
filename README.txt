RealtimeFaceSwap v1.0.0
实时 AI 视频处理软件

==============================
软件结构
==============================

RealtimeFaceSwap/
├── RealtimeFaceSwap.exe   启动器
├── version.json           版本信息
│
├── backend/
│   ├── backend.exe        后端程序
│   ├── settings.json      配置文件
│   └── models/            AI 模型目录
│
└── frontend/
    └── app.exe            Flutter 客户端


==============================
运行步骤
==============================

1. 双击 RealtimeFaceSwap.exe

2. 启动器会自动启动后端和客户端

3. 等待 3 秒后客户端窗口出现

4. 确保摄像头已连接


==============================
配置说明
==============================

backend/settings.json:

{
    "camera": 0,           摄像头编号
    "resolution": "1280x720",
    "gpu": true,           GPU 加速
    "model": "default"     AI 模型
}


==============================
常见问题
==============================

Q: 启动后白屏？
A: 检查摄像头是否被其他程序占用

Q: 后端无法启动？
A: 确认 models 目录下有模型文件

Q: GPU 不工作？
A: 修改 settings.json 中 gpu 为 false

==============================
技术支持
==============================

版本: 1.0.0
构建: 2026
平台: Windows
