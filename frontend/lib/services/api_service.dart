// ... (kode di bagian atas, pastikan import sudah lengkap)
import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb; // FIX untuk Web/Emulator
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';
import '../models/login_response.dart';
import '../models/produk.dart';

// Definisikan class Exception khusus untuk 401
class TokenExpiredException implements Exception {
  final String message = 'Sesi Anda telah berakhir. Silakan login ulang.';
  @override
  String toString() => message;
}

class ApiService {
  // Gunakan logika kondisional untuk Web/Emulator/HP
  static const String _baseUrl = (kIsWeb)
      ? "http://localhost:8080"
      : "http://10.0.2.2:8080";

  // Helper: Menyiapkan Header dengan Token Bearer
  // ... (kode _getAuthHeaders() TIDAK BERUBAH) ...

  Future<Map<String, String>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return {'Content-Type': 'application/json'};
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // 1. REGISTRASI
  // ... (kode registrasi() TIDAK BERUBAH) ...
  Future<ApiResponse> registrasi(
    String nama,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/registrasi');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'nama': nama, 'email': email, 'password': password}),
      );

      if (response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        var errorBody = json.decode(response.body);
        return ApiResponse(
          status: false,
          data: errorBody['message'] ?? 'Gagal: ${response.statusCode}',
          code: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(
        status: false,
        data: 'Terjadi kesalahan: $e',
        code: 500,
      );
    }
  }

  // 2. LOGIN
  // ... (kode login() TIDAK BERUBAH) ...
  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(json.decode(response.body));
      } else {
        var errorData = json.decode(response.body);
        return LoginResponse(
          status: false,
          token: errorData['message'] ?? '', // Ambil pesan error jika ada
          userEmail: '',
          userId: 0,
        );
      }
    } catch (e) {
      return LoginResponse(
        status: false,
        token: 'Error: $e',
        userEmail: '',
        userId: 0,
      );
    }
  }

  // 3. GET PRODUK (MODIFIKASI UNTUK PENANGANAN 401)
  Future<List<Produk>> getProduk() async {
    final url = Uri.parse('$_baseUrl/produk');
    final headers = await _getAuthHeaders();

    // HAPUS blok try-catch di sini untuk memastikan exception langsung dilempar

    final response = await http.get(url, headers: headers);

    // Cek status 401
    if (response.statusCode == 401) {
      throw TokenExpiredException(); // Lempar Exception Khusus
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      // Pastikan akses key 'data' aman
      final List<dynamic> jsonData = jsonResponse['data'] ?? [];

      // Konversi List dynamic ke List<Produk>
      return jsonData
          .map((item) => Produk.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      // Jika error selain 401 (misal 500)
      throw Exception('Gagal memuat produk: ${response.statusCode}');
    }
  }

  // ... (kode createProduk, updateProduk, deleteProduk TIDAK BERUBAH) ...
  Future<ApiResponse> createProduk(Produk produk) async {
    final url = Uri.parse('$_baseUrl/produk');
    final headers = await _getAuthHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(produk.toJson()),
      );

      if (response.statusCode == 201) {
        return ApiResponse.fromJson(json.decode(response.body));
      } else {
        var errorBody = json.decode(response.body);
        return ApiResponse(
          status: false,
          data: errorBody['message'] ?? 'Gagal menambah produk',
          code: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse(status: false, data: 'Error: $e');
    }
  }

  Future<ApiResponse> updateProduk(String id, Produk produk) async {
    final url = Uri.parse('$_baseUrl/produk/$id');
    final headers = await _getAuthHeaders();

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(produk.toJson()),
      );

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      }

      return ApiResponse(
        status: false,
        data: 'Gagal update: ${response.statusCode}',
      );
    } catch (e) {
      return ApiResponse(status: false, data: 'Error: $e');
    }
  }

  Future<ApiResponse> deleteProduk(String id) async {
    final url = Uri.parse('$_baseUrl/produk/$id');
    final headers = await _getAuthHeaders();

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        return ApiResponse.fromJson(json.decode(response.body));
      }

      return ApiResponse(
        status: false,
        data: 'Gagal menghapus data: ${response.statusCode}',
      );
    } catch (e) {
      return ApiResponse(status: false, data: 'Error: $e');
    }
  }
}
