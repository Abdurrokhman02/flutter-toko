<?php
namespace App\Controllers;
use App\Models\ProdukModel; 
use App\Models\MemberTokenModel; // Wajib diimpor untuk cek token

class ProdukController extends BaseController
{
    // Properti untuk menyimpan instance model
    protected $model;

    /**
     * Constructor
     * FIX FINAL: Memeriksa token DI SINI sebelum method apapun (list, create, dll.) dieksekusi.
     */
    public function __construct()
    {
        $this->model = new ProdukModel();
        
        $request = service('request');
        $authHeader = $request->getHeaderLine('Authorization');
        
        // Default respons error 401
        $send401 = function($message) {
            $response = service('response');
            $response->setStatusCode(401)
                     ->setJSON(['status' => 401, 'message' => $message])
                     ->send();
            exit; // HENTIKAN EKSEKUSI CI4 SECARA PAKSA
        };
        
        if (empty($authHeader) || !str_starts_with($authHeader, 'Bearer ')) {
            // Token hilang atau format salah
            $send401('Token tidak ditemukan di header Authorization.');
        }

        $token = substr($authHeader, 7); 
        $modelToken = new MemberTokenModel();
        
        // Cek token di database
        $found = $modelToken->where('auth_key', $token)->first();

        if (!$found) {
            // Token invalid/dihapus/kadaluarsa
            $send401('Token kadaluarsa atau tidak valid.');
        }
        
        // Jika sampai di sini, token valid, Controller akan melanjutkan ke method list/create/etc.
    }

    /**
     * GET /produk
     * Mengambil semua data produk
     */
    public function list()
    {
        // $this->model->findAll() baru dieksekusi jika __construct LULUS
        $data = $this->model->findAll();
        return $this->successResponse("Data produk ditemukan", $data);
    }
    
    // ... (Metode detail(), create(), update(), delete() di bawah ini tidak perlu diubah) ...
    // ... karena sudah dilindungi oleh __construct()
    
    /**
     * GET /produk/{id}
     * Mengambil detail satu produk berdasarkan ID
     * @param int $id - ID produk dari URL
     */
    public function detail($id = null)
    {
        // ... (kode list)
        $data = $this->model->find($id);
        if (!$data) {
            return $this->failResponse("Produk tidak ditemukan", 404);
        }
        return $this->successResponse("Detail produk", $data);
    }

    /**
     * POST /produk
     * Membuat data produk baru
     */
    public function create()
    {
        // ... (kode create)
        $data = $this->request->getJSON();
        if (!isset($data->kode_produk) || !isset($data->nama_produk) || !isset($data->harga)) {
            return $this->failResponse("Data tidak lengkap", 400);
        }

        try {
            $newId = $this->model->insert((array) $data);
            $newData = $this->model->find($newId); 
            return $this->successResponse("Produk berhasil dibuat", $newData, 201);
        } catch (\Exception $e) {
            if(strpos($e->getMessage(), 'Duplicate entry') !== false) {
                return $this->failResponse("Kode produk sudah digunakan", 400);
            }
            return $this->failResponse("Gagal membuat produk: " . $e->getMessage(), 500);
        }
    }
    
    /**
     * PUT /produk/{id}
     * Memperbarui data produk yang ada
     * @param int $id - ID produk dari URL
     */
    public function update($id = null)
    {
        // ... (kode update)
        $data = $this->request->getJSON();
        $existing = $this->model->find($id);
        if (!$existing) {
            return $this->failResponse("Produk tidak ditemukan", 404);
        }

        try {
            $this->model->update($id, (array) $data);
            $updatedData = $this->model->find($id); 
            return $this->successResponse("Produk berhasil diperbarui", $updatedData);
        } catch (\Exception $e) {
            return $this->failResponse("Gagal memperbarui: " . $e->getMessage(), 500);
        }
    }

    /**
     * DELETE /produk/{id}
     * Menghapus data produk
     * @param int $id - ID produk dari URL
     */
    public function delete($id = null)
    {
        // ... (kode delete)
        $existing = $this->model->find($id);
        if (!$existing) {
            return $this->failResponse("Produk tidak ditemukan", 404);
        }

        try {
            $this->model->delete($id);
            return $this->successResponse("Produk berhasil dihapus");
        } catch (\Exception $e) {
            return $this->failResponse("Gagal menghapus: " . $e->getMessage(), 500);
        }
    }
}