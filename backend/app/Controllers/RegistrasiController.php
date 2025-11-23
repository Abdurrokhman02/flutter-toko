<?php
namespace App\Controllers;
use App\Models\MemberModel; // Import MemberModel

// Kelas ini 'mewarisi' BaseController agar bisa memakai failResponse() & successResponse()
class RegistrasiController extends BaseController 
{
    /**
     * Fungsi untuk memproses pembuatan member baru (registrasi).
     * Dipetakan ke POST /registrasi
     */
    public function create()
    {
        // Inisialisasi model
        $model = new MemberModel();

        // Mengambil data JSON mentah dari body request
        $data = $this->request->getJSON();

        // Validasi input sederhana
        if (!isset($data->nama) || !isset($data->email) || !isset($data->password)) {
            // Kirim respons error jika data tidak lengkap
            return $this->failResponse("Nama, email, dan password diperlukan", 400);
        }

        if (strlen($data->password) < 8) {
            return $this->failResponse("Password minimal 8 karakter", 400);
        }

        // Pengecekan duplikasi email
        // $model->where('email', $data->email)->first()
        // Artinya: "CARI di tabel member DIMANA email = $data->email, AMBIL data (first) baris pertama"
        if ($model->where('email', $data->email)->first()) {
            return $this->failResponse("Email sudah terdaftar", 400);
        }

        // Blok 'try...catch' untuk menangani error jika terjadi kegagalan saat insert DB
        try {
            // Memasukkan data ke database
            $model->insert([
                'nama' => $data->nama,
                'email' => $data->email,
                'password' => $data->password // Password mentah
                // Hashing akan otomatis ditangani oleh Model (callback beforeInsert)
            ]);

            // Kirim respons sukses dengan kode 201 Created
            return $this->successResponse("Registrasi berhasil", [], 201);

        } catch (\Exception $e) {
            // Jika terjadi error (misal: koneksi DB putus)
            return $this->failResponse("Gagal mendaftar: " . $e->getMessage(), 500);
        }
    }
}
