# -*- mode: python ; coding: utf-8 -*-


block_cipher = None


a = Analysis(

    ['app.py'],

    pathex=[],

    binaries=[],

    datas=[

        ('settings.json', '.'),

        ('models', 'models'),

    ],

    hiddenimports=[

        'insightface',
        'insightface.app',
        'insightface.model_zoo',

        'onnxruntime',

        'cv2',

        'fastapi',
        'fastapi.middleware',
        'fastapi.middleware.cors',

        'uvicorn',
        'uvicorn.logging',
        'uvicorn.loops',
        'uvicorn.loops.auto',
        'uvicorn.protocols',
        'uvicorn.protocols.http',
        'uvicorn.protocols.http.auto',
        'uvicorn.protocols.websockets',
        'uvicorn.protocols.websockets.auto',
        'uvicorn.lifespan',
        'uvicorn.lifespan.on',

        'pydantic',

        'modules.stream',
        'modules.face_detector',
        'modules.frame_processor',
        'modules.ai_engine',
        'modules.model_manager',
        'modules.performance',
        'modules.device_manager',
        'modules.face_encoder',
        'modules.frame_queue',
        'modules.camera_thread',

        'camera',
        'config',

    ],

    hookspath=[],

    hooksconfig={},

    runtime_hooks=[],

    excludes=[],

    win_no_prefer_redirects=False,

    win_private_assemblies=False,

    cipher=block_cipher,

    noarchive=False,

)


pyz = PYZ(

    a.pure,

    a.zipped_data,

    cipher=block_cipher,

)


exe = EXE(

    pyz,

    a.scripts,

    a.binaries,

    a.zipfiles,

    a.datas,

    [],

    name='backend',

    debug=False,

    bootloader_ignore_signals=False,

    strip=False,

    upx=True,

    upx_exclude=[],

    runtime_tmpdir=None,

    console=True,

    disable_windowed_traceback=False,

    target_arch=None,

    codesign_identity=None,

    entitlements_file=None,

)
