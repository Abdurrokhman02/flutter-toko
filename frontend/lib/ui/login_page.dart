import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // PERBAIKAN: Pastikan input dikosongkan setiap kali halaman dimuat
    _emailController.clear(); 
    _passwordController.clear();
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
            Text("Mencoba Masuk..."),
          ],
        ),
      ),
    );
  }

  Future<void> _doLogin() async {
    // Menghapus print() karena Dart menyarankan penggunaan logging framework
    _showLoadingDialog(); // Tampilkan loading overlay

    try {
      final response = await _apiService.login(
        _emailController.text, 
        _passwordController.text
      );

      // Tutup dialog loading
      if (!mounted) return;
      Navigator.pop(context); 

      if (response.status) {
        // Simpan Token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.token);
        
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/produk'); // Pindah ke Dashboard
      } else {
        // Ambil pesan error (asumsi 'token' berisi pesan error jika status: false)
        String pesan = 'Login gagal. Coba cek email/password Anda.';
        if (response.token.isNotEmpty) {
           pesan = response.token;
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesan)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context); // Pastikan dialog tertutup
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error jaringan: $e')),
      );
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Toko')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _doLogin, 
              child: const Text('Masuk'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/registrasi'),
              child: const Text('Belum punya akun? Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}