import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({super.key});

  @override
  State<RegistrasiPage> createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _konfirmasiController = TextEditingController(); // TAMBAHAN: Konfirmasi Password
  
  final _apiService = ApiService();

  // Fungsi untuk menampilkan Loading Overlay
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text("Memproses..."),
          ],
        ),
      ),
    );
  }

  void _doRegistrasi() async {
    // 1. Validasi Password
    if (_passwordController.text != _konfirmasiController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Konfirmasi Password tidak sama!')),
      );
      return;
    }

    _showLoadingDialog(); // Tampilkan loading overlay

    try {
      final response = await _apiService.registrasi(
        _namaController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Setelah selesai, tutup dialog loading
      if (!mounted) return;
      Navigator.pop(context); 

      // Tampilkan respons
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.data)),
      );

      if (response.status) {
        Navigator.pop(context); // Kembali ke Login jika sukses
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pastikan dialog tertutup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            // TAMBAHAN: Field Konfirmasi Password
            TextField(
              controller: _konfirmasiController, 
              decoration: const InputDecoration(labelText: 'Konfirmasi Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _doRegistrasi, 
              child: const Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}