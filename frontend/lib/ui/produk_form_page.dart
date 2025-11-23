import 'package:flutter/material.dart';

import '../models/produk.dart';
import '../services/api_service.dart';

class ProdukFormPage extends StatefulWidget {
  final Produk?
  produk; // Opsional: Jika null = Mode Tambah, Jika ada = Mode Edit
  const ProdukFormPage({super.key, this.produk});

  @override
  State<ProdukFormPage> createState() => _ProdukFormPageState();
}

class _ProdukFormPageState extends State<ProdukFormPage> {
  final _apiService = ApiService();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    if (widget.produk != null) {
      _isEdit = true;
      _kodeController.text = widget.produk!.kodeProduk;
      _namaController.text = widget.produk!.namaProduk;
      _hargaController.text = widget.produk!.harga.toString();
    }
  }

  Future<void> _submit() async {
    final produk = Produk(
      id: _isEdit ? widget.produk!.id : null,
      kodeProduk: _kodeController.text,
      namaProduk: _namaController.text,
      harga: int.parse(_hargaController.text),
    );

    // Logika Simpan akan diupdate di Langkah 9 untuk menangani Update
    // Untuk sekarang kita fokus ke Create dulu (atau langsung dual mode)
    dynamic response;
    if (_isEdit) {
      response = await _apiService.updateProduk(
        widget.produk!.id.toString(),
        produk,
      );
    } else {
      response = await _apiService.createProduk(produk);
    }

    if (response.status) {
      if (!mounted) return;
      Navigator.pop(context, true); // Kirim sinyal sukses ke halaman list
    } else {
      // Tampilkan pesan error
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            response.message ?? "Terjadi kesalahan saat menyimpan data.",
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Produk' : 'Tambah Produk')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _kodeController,
              decoration: const InputDecoration(labelText: 'Kode'),
            ),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _hargaController,
              decoration: const InputDecoration(labelText: 'Harga'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
