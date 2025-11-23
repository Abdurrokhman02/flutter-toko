<?php
namespace App\Models;
use CodeIgniter\Model;

class ProdukModel extends Model
{
    // Menentukan tabel database
    protected $table = 'produk';

    // Menentukan primary key
    protected $primaryKey = 'id';

    // Kolom yang diizinkan untuk diisi
    protected $allowedFields = [
        'kode_produk', 
        'nama_produk', 
        'harga', 
        'stok',
        'deskripsi', 
        'image_url'
    ];
}
