# Flutter AI Edge Computing App
| Name           | NRP        | Kelas     |
| :---:       | :---:     | :----------: |
| Ahmad Faiz Tajuddin | 5025231291 | PPB E |

## Penjelasan Kode

1. Import Package

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
```

Fungsi:
- material.dart
 menyediakan widget Material Design seperti MaterialApp, Scaffold, dll.
- services.dart
 digunakan untuk akses fitur sistem/device, di sini dipakai untuk mengatur orientasi layar.
- provider.dart
 library state management agar data/service bisa diakses di seluruh aplikasi.

2. Import File Lokal

```dart
import 'services/ai_service.dart';
import 'services/edge_compute_service.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';
import 'utils/app_theme.dart';
```

Fungsi:

Menghubungkan file-file custom project:

- AIService
→ menangani fitur AI.
- EdgeComputeService
→ menangani edge computing/proses lokal device.
- StorageService
→ mengelola penyimpanan data.
- SplashScreen
→ tampilan awal aplikasi.
- AppTheme
→ konfigurasi tema aplikasi.

3. Inisialisasi Storage

```dart
final storageService = StorageService();
await storageService.init();
```

Fungsi:
- membuat object StorageService,
- menjalankan proses setup sebelum aplikasi dimulai.

Contohnya:

- membuka database,
- shared preferences,
- local cache.

DLL.
## Cara penggunaan
1. Tampilan Awal Aplikasi

Di halaman utama ada beberapa bagian:
<img width="1292" height="877" alt="image" src="https://github.com/user-attachments/assets/6b289216-c473-4f64-ab9d-3163557de38d" />
3. Cara Mengaktifkan AI
Di atas ada pesan:

API Key belum dikonfigurasi. Pergi ke Settings.

Ini berarti AI belum bisa digunakan karena API key belum dimasukkan.
Langkah 1 — Masuk Menu Settings
Klik icon:

 Settings

di navbar bawah kanan.
nanti akan muncul seperti ini:
<img width="1282" height="870" alt="image" src="https://github.com/user-attachments/assets/0372fdbe-03a2-4a40-ac1f-ea2ebccad791" />

dan setelah selesai memasukkan API KEY AI siap digunakan
## Tampilan Lain
### Node

<img width="1282" height="876" alt="image" src="https://github.com/user-attachments/assets/e7cba701-4daa-4dfa-a153-21b468b15aec" />

### Dashboard

<img width="1282" height="871" alt="image" src="https://github.com/user-attachments/assets/c624f175-b6da-4160-a8f4-c0ed6f98c16a" />
