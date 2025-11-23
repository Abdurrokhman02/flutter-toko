<?php namespace App\Filters;

use CodeIgniter\Filters\FilterInterface;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use App\Models\MemberTokenModel; 

class AuthFilter implements FilterInterface 
{
    public function before(RequestInterface $request, $arguments = null)
    {
        $authHeader = $request->getHeaderLine('Authorization');
        $isInvalid = false;

        // 1. Cek format header
        if (empty($authHeader) || !str_starts_with($authHeader, 'Bearer ')) {
            $isInvalid = true;
        }

        if (!$isInvalid) {
            $token = substr($authHeader, 7); 
            $model = new \App\Models\MemberTokenModel(); // Pastikan panggil model dengan namespace penuh
            
            $found = $model->where('auth_key', $token)->first();

            if (!$found) {
                $isInvalid = true;
            }
        }
        
        if ($isInvalid) {
            // FIX KRUSIAL: Menggunakan service('response') dan chaining untuk penghentian paksa
            return service('response')
                // Set Status Code 401
                ->setStatusCode(401)
                // Set Header Content-Type: application/json (Wajib buat Flutter)
                ->setHeader('Content-Type', 'application/json')
                // Set Body JSON (Penting)
                ->setJSON([
                    'status' => 401,
                    'message' => 'Token kadaluarsa atau tidak valid. Sesi akan berakhir.',
                ]);
        }

        // Jika sampai di sini, token valid, biarkan request berlanjut
        return;
    }

    public function after(RequestInterface $request, ResponseInterface $response, $arguments = null)
    {
    }
}