# 瞬間 (Shunkan)

Real-time speech transcription and translation, powered by the [DashScope Realtime API](https://dashscope.aliyun.com).
Speak (or play system audio) and watch the original text plus its translation appear instantly, side-by-side.

[中文说明](README.zh.md)

---

## Features

- **Real-time transcription & translation** — results stream word-by-word as you speak, with a final commit on each sentence boundary
- **Multiple language pairs** — Japanese → Chinese, English → Chinese, Korean → Chinese, Chinese → English, Japanese → English
- **Dual audio sources** — capture from the microphone or from system / loopback audio (Stereo Mix, BlackHole, etc.)
- **Session history** — every recording session is saved locally; browse and replay transcripts at any time
- **Material 3 Expressive UI** — light/dark theme, animated record button with pulse ring, collapsible timer chip

## Supported Platforms

| Platform | Status |
|----------|--------|
| Windows  | Supported |
| macOS    | Supported |
| Android  | Supported |

> iOS and Linux are not tested. Web is not supported (microphone streaming requires a native WebSocket connection).

## Prerequisites

- Flutter SDK ≥ 3.11
- A [DashScope API key](https://dashscope.aliyun.com) with access to `qwen3-livetranslate-flash-realtime`
- **Windows / macOS — system audio**: a loopback device must be present (e.g. "Stereo Mix" on Windows or BlackHole on macOS)
- **Android — system audio**: API level 21+ (Android 5.0); `remote_submix` is used internally, no extra permission required on API 29+

## Getting Started

### 1. Clone and install dependencies

```bash
git clone https://github.com/Deardrops/shunkan.git
cd shunkan
flutter pub get
```

### 2. Run code generation (Drift + Riverpod)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 3. Launch

```bash
flutter run -d windows   # or macos / android
```

## Configuration

Open **Settings** (gear icon) in the app to configure:

| Setting | Description |
|---------|-------------|
| API Key | Your DashScope API key |
| Language pair | Source → target language for transcription and translation |

The audio source (microphone vs system audio) is toggled directly on the home screen.

## Project Structure

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # MaterialApp, theme, routes
├── models/                      # AppSettings, SubtitleEntry, RecordingSession
├── services/
│   ├── audio_recorder_service.dart   # record package wrapper
│   ├── audio_pipeline_service.dart   # PCM stream → WebSocket pipeline
│   ├── translation_service.dart      # DashScope Realtime API client
│   ├── settings_service.dart         # SharedPreferences persistence
│   └── storage_service.dart          # Drift (SQLite) facade
├── providers/                   # Riverpod state notifiers
├── screens/                     # HomeScreen, SettingsScreen, HistoryScreen
└── widgets/                     # RecordButton, SubtitleList, SubtitleTile, …
```

## Development Notes

- Audio is streamed as **raw 16-bit LE PCM at 16 kHz mono** directly through a WebSocket to the Realtime API.
- The `translation_service.dart` implements the OpenAI Realtime-compatible `session.update` / `input_audio_buffer.append` protocol used by DashScope.
- Partial (in-progress) subtitles are displayed at half opacity; they are replaced by the final committed result on each sentence boundary.

## License

MIT — see [LICENSE](LICENSE).
