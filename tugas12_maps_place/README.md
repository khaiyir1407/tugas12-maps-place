# Tugas 12 - Maps & Place

**Mata Kuliah:** Aplikasi Berbasis Platform  
**Topik:** Maps & Place — Geolocator & Geocoding  
**Universitas:** Telkom University — Fakultas Informatika

---

## Deskripsi

Project Flutter ini mengimplementasikan tiga fungsi utama lokasi menggunakan package **geolocator** dan **geocoding**:

| # | Fungsi | Keterangan |
|---|--------|------------|
| 1 | `Geolocator.getCurrentPosition()` | Ambil koordinat (Lat/Lng) perangkat saat ini |
| 2 | `locationFromAddress()` | Konversi alamat teks → koordinat |
| 3 | `placemarkFromCoordinates()` | Konversi koordinat → alamat lengkap |

Semua hasil dicetak ke **Debug Console** menggunakan `print()` dan juga ditampilkan di layar aplikasi.

---

## Struktur Project

```
tugas12_maps_place/
├── lib/
│   └── main.dart              # Kode utama aplikasi
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml  # Izin lokasi Android
├── ios/
│   └── Runner/
│       └── Info.plist           # Izin lokasi iOS
├── pubspec.yaml               # Dependencies
└── README.md
```

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  geolocator: ^13.0.4     # Akses GPS / lokasi perangkat
  geocoding: ^3.0.0        # Konversi alamat <-> koordinat
```

---

## Setup & Cara Menjalankan

### 1. Clone Repository

```bash
git clone https://github.com/<username>/tugas12_maps_place.git
cd tugas12_maps_place
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
flutter run
```

### 4. Lihat Output di Debug Console

Buka terminal atau panel **Debug Console** di IDE (VS Code / Android Studio). Output akan muncul seperti:

```
=== Tugas 12: Maps & Place ===
Memulai eksekusi fungsi lokasi...

--- [TUGAS 1] Geolocator.getCurrentPosition() ---
✔ Berhasil mendapatkan posisi perangkat:
  Latitude  : -6.974626
  Longitude : 107.633704
  Akurasi   : 5.00 meter
  Timestamp : 2025-01-01 10:00:00.000

--- [TUGAS 2] locationFromAddress() ---
  Alamat yang dicari: "Telkom University, Jl. Telekomunikasi No.1, Terusan Buah Batu, Bandung"
✔ Berhasil mendapatkan 1 lokasi:
  Hasil 1:
    Latitude  : -6.9734
    Longitude : 107.6301

--- [TUGAS 3] placemarkFromCoordinates() ---
  Koordinat: (52.2165157, 6.9437819)
✔ Berhasil menerjemahkan koordinat ke alamat:
  Nama Tempat   : Gronausestraat 710
  Jalan (Street): Gronausestraat 710
  Kota          : Enschede
  Provinsi      : Overijssel
  Kode Pos      : 7534
  Negara        : Netherlands

=== Selesai ===
```

---

## Izin Lokasi

### Android
Izin sudah ditambahkan di `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
```

### iOS
Izin sudah ditambahkan di `ios/Runner/Info.plist`:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Aplikasi ini membutuhkan akses lokasi...</string>
```

---

## Referensi

- [pub.dev/packages/geolocator](https://pub.dev/packages/geolocator)
- [pub.dev/packages/geocoding](https://pub.dev/packages/geocoding)
- Slide Kuliah: Aplikasi Berbasis Platform — Maps & Place (Telkom University)
