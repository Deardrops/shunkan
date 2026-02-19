# 瞬間 (Shunkan)

实时语音转录与翻译应用，由[阿里云 DashScope 实时 API](https://dashscope.aliyun.com) 驱动。
开口说话（或播放系统内的声音），原文与译文即刻逐字浮现。

[English README](README.md)

---

## 功能特性

- **实时转录与翻译** — 随说随出，逐字流式显示，每个句子结束后提交最终结果
- **多语言对支持** — 日语→中文、英语→中文、韩语→中文、中文→英语、日语→英语
- **双音频来源** — 可录制麦克风输入，也可直接捕获系统音频（立体声混音、BlackHole 等回环设备）
- **历史记录** — 每次录音会话本地保存，随时浏览、回放字幕
- **Material 3 Expressive 界面** — 支持亮色/暗色主题，带脉冲环动画的录音按钮，折叠计时芯片

## 支持平台

| 平台 | 状态 |
|------|------|
| Windows | 支持 |
| macOS   | 支持 |
| Android | 支持 |

> iOS 和 Linux 尚未测试。Web 不支持（麦克风流式录音需要原生 WebSocket 连接）。

## 前置条件

- Flutter SDK ≥ 3.11
- 拥有 `qwen3-livetranslate-flash-realtime` 访问权限的 [DashScope API Key](https://dashscope.aliyun.com)
- **Windows / macOS — 系统音频**：需要存在回环音频设备（Windows 的"立体声混音"，macOS 的 BlackHole 等）
- **Android — 系统音频**：API 21+（Android 5.0）；内部使用 `remote_submix`，API 29+ 无需额外权限

## 快速开始

### 1. 克隆仓库并安装依赖

```bash
git clone https://github.com/Deardrops/shunkan.git
cd shunkan
flutter pub get
```

### 2. 运行代码生成（Drift + Riverpod）

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. 运行

```bash
flutter run -d windows   # 或 macos / android
```

## 配置说明

点击应用内右上角的**设置**图标进行配置：

| 设置项 | 说明 |
|--------|------|
| API Key | 阿里云 DashScope API 密钥 |
| 语言对 | 转录与翻译的源语言 → 目标语言 |

音频来源（麦克风 / 系统音频）在主界面底部直接切换。

## 项目结构

```
lib/
├── main.dart                    # 入口
├── app.dart                     # MaterialApp、主题、路由
├── models/                      # AppSettings、SubtitleEntry、RecordingSession
├── services/
│   ├── audio_recorder_service.dart   # record 包封装
│   ├── audio_pipeline_service.dart   # PCM 流 → WebSocket 管道
│   ├── translation_service.dart      # DashScope 实时 API 客户端
│   ├── settings_service.dart         # SharedPreferences 持久化
│   └── storage_service.dart          # Drift（SQLite）门面
├── providers/                   # Riverpod 状态管理
├── screens/                     # 主界面、设置页、历史记录页
└── widgets/                     # RecordButton、SubtitleList、SubtitleTile 等
```

## 技术说明

- 音频以 **16-bit LE PCM、16 kHz、单声道** 格式直接通过 WebSocket 发送至实时 API。
- `translation_service.dart` 实现了 DashScope 所使用的 OpenAI Realtime 兼容协议（`session.update` / `input_audio_buffer.append`）。
- 进行中的识别结果以半透明方式显示在列表底部，每个句子结束后替换为最终字幕。

## 开源协议

MIT — 详见 [LICENSE](LICENSE)。
