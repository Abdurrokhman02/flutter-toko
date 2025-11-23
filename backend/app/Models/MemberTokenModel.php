<?php
namespace App\Models;
use CodeIgniter\Model;

class MemberTokenModel extends Model
{
    // Menentukan tabel database
    protected $table = 'member_token';

    // Menentukan primary key
    protected $primaryKey = 'id';

    // Kolom yang diizinkan untuk diisi
    protected $allowedFields = ['member_id', 'auth_key'];
}
