<?php
namespace App\Controllers;
use App\Models\MemberModel;       // Import model member
use App\Models\MemberTokenModel;  // Import model token
// use \Firebase\JWT\JWT; // Dapat digunakan nanti jika ingin implementasi JWT

class LoginController extends BaseController
{
    /**
     * Fungsi untuk memproses login member.
     * Dipetakan ke POST /login
     */
    public function login()
    {
        // Inisialisasi kedua model
        $modelMember = new MemberModel();
        $modelToken = new MemberTokenModel();

        // Ambil data JSON dari body request
        $data = $this->request->getJSON();

        // Validasi input
        if (!isset($data->email) || !isset($data->password)) {
            return $this->failResponse("Email dan password diperlukan", 400);
        }

        // 1. Cari user berdasarkan email
        $user = $modelMember->where('email', $data->email)->first();

        // 2. Verifikasi user dan password
        // !$user -> Cek apakah user tidak ditemukan
        // !password_verify(...) -> Cek apakah password mentah TIDAK COCOK dengan hash di DB
        if (!$user || !password_verify($data->password, $user['password'])) {
            // Kirim respons 401 Unauthorized (kredensial salah)
            return $this->failResponse("Email atau password salah", 401);
        }

        // 3. Buat token (Contoh: token acak sederhana, BUKAN JWT)
        // bin2hex(random_bytes(32)) menghasilkan string heksadesimal 64 karakter
        $token = bin2hex(random_bytes(32)); 

        // 4. Simpan token ke database
        try {
            $modelToken->insert([
                'member_id' => $user['id'], // Hubungkan token dengan ID user
                'auth_key' => $token
            ]);
        } catch (\Exception $e) {
            return $this->failResponse("Gagal membuat token: " . $e->getMessage(), 500);
        }

        // 5. Kirim respons sukses
        return $this->successResponse("Login berhasil", [
            'token' => $token, // Kirim token ke klien
            'user' => [        // Kirim data user (untuk ditampilkan di profil)
                'id' => $user['id'],
                'nama' => $user['nama'],
                'email' => $user['email']
            ]
        ], 200);
    }
}
