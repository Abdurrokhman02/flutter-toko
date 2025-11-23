<?php
namespace App\Models;
use CodeIgniter\Model;

class MemberModel extends Model
{
    // Menentukan tabel database yang digunakan oleh model ini
    protected $table = 'member';

    // Menentukan primary key dari tabel
    protected $primaryKey = 'id';

    // Daftar kolom yang diizinkan untuk 'mass assignment' (diisi via insert/update)
    // Ini adalah fitur keamanan untuk mencegah pengisian kolom sensitif
    protected $allowedFields = ['nama', 'email', 'password'];

    // Mendefinisikan 'callback' yang akan dijalankan SEBELUM data baru dimasukkan (insert)
    protected $beforeInsert = ['hashPassword'];

    /**
     * Fungsi callback untuk mengenkripsi (hash) password secara otomatis
     * sebelum data disimpan ke database.
     *
     * @param array $data Data yang akan dimasukkan
     * @return array Data dengan password yang sudah di-hash
     */
    protected function hashPassword(array $data)
    {
        // Cek apakah ada data password yang dikirim
        if (isset($data['data']['password'])) {
            // Ganti password mentah dengan password yang sudah di-hash
            $data['data']['password'] = password_hash($data['data']['password'], PASSWORD_DEFAULT);
        }
        return $data;
    }
}
