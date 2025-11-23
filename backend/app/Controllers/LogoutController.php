<?php
namespace App\Controllers;

use App\Models\MemberTokenModel;

class LogoutController extends BaseController
{
    public function logout()
    {
        // Ambil token dari Header Authorization
        $authHeader = $this->request->getHeaderLine('Authorization');

        // Pastikan formatnya: "Bearer token123..."
        if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
            return $this->failResponse("Token tidak ditemukan di header Authorization", 401);
        }

        // Ambil nilai token-nya saja
        $token = str_replace('Bearer ', '', $authHeader);

        // Inisialisasi model token
        $modelToken = new MemberTokenModel();

        // Cari token di tabel member_token
        $found = $modelToken->where('auth_key', $token)->first();

        if (!$found) {
            // Token tidak valid / sudah dihapus
            return $this->failResponse("Token tidak valid atau sudah logout", 401);
        }

        // Jika ditemukan, hapus token tersebut
        try {
            $modelToken->delete($found['id']);
            return $this->successResponse("Logout berhasil");
        } catch (\Exception $e) {
            return $this->failResponse("Gagal logout: " . $e->getMessage(), 500);
        }
    }
}
