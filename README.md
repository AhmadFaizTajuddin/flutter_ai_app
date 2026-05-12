# ⚡ Flutter AI Edge Computing App

Aplikasi Flutter dengan integrasi Claude AI untuk edge computing. Fitur real-time AI chat, monitoring edge nodes, dan dashboard performa.

## 📱 Fitur Utama

- **💬 AI Chat** - Percakapan cerdas dengan Claude AI (claude-sonnet-4)
- **📊 Dashboard** - Monitoring real-time metrics & performa
- **🌐 Edge Nodes** - Visualisasi & status jaringan edge computing
- **⚙️ Settings** - Konfigurasi API Key & System Prompt
- **🔄 Streaming** - Respons AI ditampilkan secara real-time
- **📈 Metrics** - Latency, token usage, compute node per pesan

## 🚀 Setup di VS Code

### 1. Prasyarat
```bash
# Install Flutter SDK
https://flutter.dev/docs/get-started/install

# Verifikasi instalasi
flutter doctor
```

### 2. Install Ekstensi VS Code
- **Flutter** (Dart-Code.flutter) ← WAJIB
- **Dart** (Dart-Code.dart-code) ← WAJIB
- Awesome Flutter Snippets (opsional)
- Error Lens (opsional)

### 3. Clone & Setup Project
```bash
# Buka folder project di VS Code
code flutter_ai_app/

# Install dependencies
flutter pub get
```

### 4. Konfigurasi API Key
1. Buka aplikasi
2. Pergi ke tab **Settings** (ikon gear)
3. Masukkan **Anthropic API Key** Anda
4. Dapatkan API Key di: https://console.anthropic.com/
5. Klik **Simpan Pengaturan**

### 5. Jalankan Aplikasi

**Via VS Code:**
- Tekan `F5` atau pilih Run > Start Debugging
- Pilih device/emulator

**Via Terminal:**
```bash
# Android/iOS
flutter run

# Web (Chrome)
flutter run -d chrome

# Specific device
flutter devices  # lihat daftar device
flutter run -d <device_id>
```

## 📁 Struktur Project

```
flutter_ai_app/
├── lib/
│   ├── main.dart                 # Entry point
│   ├── models/
│   │   └── ai_models.dart        # Data models
│   ├── services/
│   │   ├── ai_service.dart       # Claude AI integration
│   │   ├── edge_compute_service.dart  # Edge nodes simulation
│   │   └── storage_service.dart  # Local storage
│   ├── screens/
│   │   ├── splash_screen.dart    # Loading screen
│   │   ├── home_screen.dart      # Main navigation
│   │   ├── chat_screen.dart      # AI chat interface
│   │   ├── dashboard_screen.dart # Metrics dashboard
│   │   ├── nodes_screen.dart     # Edge nodes monitor
│   │   └── settings_screen.dart  # Configuration
│   └── utils/
│       └── app_theme.dart        # Theme & colors
├── .vscode/
│   ├── launch.json               # Debug configurations
│   ├── settings.json             # VS Code settings
│   └── extensions.json           # Recommended extensions
└── pubspec.yaml                  # Dependencies
```

## 🤖 Arsitektur AI

```
User Input → Flutter App → Claude API (claude-sonnet-4) → Edge Node → Response
                ↓                                              ↓
           Local State                                   Metrics Collected
                ↓                                              ↓
           UI Update ←──────────────── Streaming Response ────┘
```

## 🎨 Design System

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | `#00F5FF` | Cyan neon, accents |
| `secondary` | `#7B2FFF` | Electric purple |
| `accent` | `#00FF88` | Matrix green, success |
| `warning` | `#FF6B35` | Alerts, busy states |
| `bgDark` | `#030712` | Background |

## 🔧 Kustomisasi

### Ganti Model AI
Di `lib/services/ai_service.dart`:
```dart
static const String _model = 'claude-opus-4-20250514'; // Ganti model
```

### Tambah Edge Node
Di `lib/services/edge_compute_service.dart`:
```dart
_nodes.add(EdgeNode(
  id: 'node-custom-01',
  name: 'Custom Node',
  region: 'Asia Pacific',
  status: 'online',
  latency: 15.0,
  load: 0.4,
  location: '🇮🇩 Indonesia',
));
```

### Kustomisasi System Prompt
Di Settings tab atau di `lib/services/ai_service.dart`:
```dart
String _systemPrompt = 'Kamu adalah asisten AI yang...'
```

## 📦 Dependencies

| Package | Kegunaan |
|---------|----------|
| `provider` | State management |
| `http` | API requests ke Claude |
| `shared_preferences` | Simpan API key lokal |
| `shimmer` | Loading effects |

## 🐛 Troubleshooting

**Error: API Key tidak valid**
- Pastikan API key diawali dengan `sk-ant-`
- Cek saldo/kredit di console.anthropic.com

**Error: flutter pub get gagal**
```bash
flutter clean
flutter pub get
```

**Emulator tidak terdeteksi**
```bash
flutter devices
flutter emulators --launch <emulator_id>
```

## 📄 Lisensi
MIT License - Bebas digunakan dan dimodifikasi.

---
*Dibuat dengan Flutter & Claude AI ⚡ | Edge Computing Platform*
