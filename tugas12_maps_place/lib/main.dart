import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas 12 - Maps & Place',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = false;
  List<String> _logMessages = [];

  @override
  void initState() {
    super.initState();
    // Jalankan semua fungsi saat aplikasi pertama kali dimuat
    _runAllLocationFunctions();
  }

  void _addLog(String message) {
    print(message); // Cetak ke debug console
    setState(() {
      _logMessages.add(message);
    });
  }

  /// Fungsi utama yang menjalankan ketiga tugas secara berurutan
  Future<void> _runAllLocationFunctions() async {
    setState(() {
      _isLoading = true;
      _logMessages.clear();
    });

    _addLog('=== Tugas 12: Maps & Place ===');
    _addLog('Memulai eksekusi fungsi lokasi...\n');

    // ─────────────────────────────────────────
    // TUGAS 1: Ambil koordinat perangkat saat ini
    // ─────────────────────────────────────────
    await _getCurrentPosition();

    // ─────────────────────────────────────────
    // TUGAS 2: Cari koordinat dari nama alamat
    // ─────────────────────────────────────────
    await _getLocationFromAddress();

    // ─────────────────────────────────────────
    // TUGAS 3: Terjemahkan koordinat ke alamat
    // ─────────────────────────────────────────
    await _getPlacemarkFromCoordinates();

    _addLog('\n=== Selesai ===');
    setState(() {
      _isLoading = false;
    });
  }

  // ──────────────────────────────────────────────────────
  // TUGAS 1: Geolocator.getCurrentPosition()
  // Mengambil koordinat latitude & longitude perangkat saat ini
  // ──────────────────────────────────────────────────────
  Future<void> _getCurrentPosition() async {
    _addLog('--- [TUGAS 1] Geolocator.getCurrentPosition() ---');
    try {
      // Cek apakah location service aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _addLog('⚠ Location service tidak aktif.');
        _addLog('  Pastikan GPS perangkat dinyalakan.\n');
        return;
      }

      // Cek dan minta permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _addLog('⚠ Izin lokasi ditolak oleh pengguna.\n');
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _addLog('⚠ Izin lokasi ditolak secara permanen.');
        _addLog('  Ubah izin di pengaturan aplikasi.\n');
        return;
      }

      // Ambil posisi saat ini
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      _addLog('✔ Berhasil mendapatkan posisi perangkat:');
      _addLog('  Latitude  : ${position.latitude}');
      _addLog('  Longitude : ${position.longitude}');
      _addLog('  Akurasi   : ${position.accuracy.toStringAsFixed(2)} meter');
      _addLog('  Altitude  : ${position.altitude.toStringAsFixed(2)} meter');
      _addLog('  Timestamp : ${position.timestamp}\n');
    } catch (e) {
      _addLog('✘ Error pada getCurrentPosition: $e\n');
    }
  }

  // ──────────────────────────────────────────────────────
  // TUGAS 2: locationFromAddress()
  // Mencari koordinat dari alamat kampus Telkom University
  // ──────────────────────────────────────────────────────
  Future<void> _getLocationFromAddress() async {
    _addLog('--- [TUGAS 2] locationFromAddress() ---');
    const String alamatKampus =
        'Telkom University, Jl. Telekomunikasi No.1, Terusan Buah Batu, Bandung';
    _addLog('  Alamat yang dicari: "$alamatKampus"');

    try {
      List<Location> locations = await locationFromAddress(alamatKampus);

      if (locations.isEmpty) {
        _addLog('⚠ Tidak ditemukan koordinat untuk alamat tersebut.\n');
        return;
      }

      _addLog('✔ Berhasil mendapatkan ${locations.length} lokasi:');
      for (int i = 0; i < locations.length; i++) {
        Location loc = locations[i];
        _addLog('  Hasil ${i + 1}:');
        _addLog('    Latitude  : ${loc.latitude}');
        _addLog('    Longitude : ${loc.longitude}');
      }
      _addLog('');
    } catch (e) {
      _addLog('✘ Error pada locationFromAddress: $e\n');
    }
  }

  // ──────────────────────────────────────────────────────
  // TUGAS 3: placemarkFromCoordinates()
  // Menerjemahkan koordinat 52.2165157, 6.9437819 ke alamat
  // ──────────────────────────────────────────────────────
  Future<void> _getPlacemarkFromCoordinates() async {
    _addLog('--- [TUGAS 3] placemarkFromCoordinates() ---');
    const double lat = 52.2165157;
    const double lng = 6.9437819;
    _addLog('  Koordinat: ($lat, $lng)');

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);

      if (placemarks.isEmpty) {
        _addLog('⚠ Tidak ditemukan alamat untuk koordinat tersebut.\n');
        return;
      }

      Placemark place = placemarks.first;

      _addLog('✔ Berhasil menerjemahkan koordinat ke alamat:');
      _addLog('  Nama Tempat   : ${place.name ?? "-"}');
      _addLog('  Jalan (Street): ${place.street ?? "-"}');
      _addLog('  Sublocality   : ${place.subLocality ?? "-"}');
      _addLog('  Kota          : ${place.locality ?? "-"}');
      _addLog('  Sub-Admin Area: ${place.subAdministrativeArea ?? "-"}');
      _addLog('  Provinsi      : ${place.administrativeArea ?? "-"}');
      _addLog('  Kode Pos      : ${place.postalCode ?? "-"}');
      _addLog('  Negara        : ${place.country ?? "-"}');
      _addLog('  Kode Negara   : ${place.isoCountryCode ?? "-"}');
      _addLog('');
    } catch (e) {
      _addLog('✘ Error pada placemarkFromCoordinates: $e\n');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCC0000), // Merah Telkom
        title: const Text(
          'Tugas 12 - Maps & Place',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Jalankan ulang',
            onPressed: _isLoading ? null : _runAllLocationFunctions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header info
          Container(
            width: double.infinity,
            color: const Color(0xFFFFF3E0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: const Text(
              'Output dari: geolocator & geocoding\n'
              'Lihat juga di Debug Console (flutter run)',
              style: TextStyle(fontSize: 13, color: Colors.brown),
            ),
          ),
          // Loading indicator
          if (_isLoading)
            const LinearProgressIndicator(
              backgroundColor: Color(0xFFFFCDD2),
              color: Color(0xFFCC0000),
            ),
          // Log output area
          Expanded(
            child: _logMessages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _logMessages.length,
                    itemBuilder: (context, index) {
                      final msg = _logMessages[index];
                      Color textColor = Colors.black87;
                      FontWeight weight = FontWeight.normal;

                      if (msg.startsWith('===')) {
                        textColor = const Color(0xFFCC0000);
                        weight = FontWeight.bold;
                      } else if (msg.startsWith('---')) {
                        textColor = Colors.blue[800]!;
                        weight = FontWeight.w600;
                      } else if (msg.startsWith('✔')) {
                        textColor = Colors.green[700]!;
                        weight = FontWeight.w600;
                      } else if (msg.startsWith('⚠') || msg.startsWith('✘')) {
                        textColor = Colors.orange[800]!;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1),
                        child: Text(
                          msg,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: textColor,
                            fontWeight: weight,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
