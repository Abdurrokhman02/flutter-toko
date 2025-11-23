<?php

namespace App\Controllers;

use CodeIgniter\Controller;
use CodeIgniter\HTTP\CLIRequest;
use CodeIgniter\HTTP\IncomingRequest;
use CodeIgniter\HTTP\RequestInterface;
use CodeIgniter\HTTP\ResponseInterface;
use Psr\Log\LoggerInterface;

/**
 * Class BaseController
 *
 * BaseController provides a convenient place for loading components
 * and performing functions that are needed by all your controllers.
 * Extend this class in any new controllers:
 *     class Home extends BaseController
 *
 * For security be sure to declare any new methods as protected or private.
 */
abstract class BaseController extends Controller
{
    /**
     * Instance of the main Request object.
     *
     * @var CLIRequest|IncomingRequest
     */
    protected $request;

    /**
     * An array of helpers to be loaded automatically upon
     * class instantiation. These helpers will be available
     * to all other controllers that extend BaseController.
     *
     * @var list<string>
     */
    protected $helpers = [];

    /**
     * Be sure to declare properties for any property fetch you initialized.
     * The creation of dynamic property is deprecated in PHP 8.2.
     */
    // protected $session;

    /**
     * @return void
     */
    public function initController(RequestInterface $request, ResponseInterface $response, LoggerInterface $logger)
    {
        // Do Not Edit This Line
        parent::initController($request, $response, $logger);

        // Preload any models, libraries, etc, here.

        // E.g.: $this->session = service('session');
    }
    // app/Controllers/BaseController.php

    /**
     * Fungsi helper untuk format respons gagal (error).
     * @param string $message - Pesan error.
     * @param int $code - Kode status HTTP (default 400).
     */
    public function failResponse($message, $code = 400)
    {
        // Mengatur kode status HTTP untuk respons
        return $this->response
                    ->setStatusCode($code)
                    ->setJSON(['status' => $code, 'message' => $message]); // Mengirim respons JSON
    }

    /**
     * Fungsi helper untuk format respons sukses.
     * @param string $message - Pesan sukses.
     * @param array $data - Data yang akan dikirim (opsional).
     * @param int $code - Kode status HTTP (default 200).
     */
    public function successResponse($message, $data = [], $code = 200)
    {
        $response = [
            'status' => $code,
            'message' => $message
        ];

        // Jika $data tidak kosong, tambahkan ke array respons
        if (!empty($data)) {
            $response['data'] = $data;
        }

        return $this->response
                    ->setStatusCode($code)
                    ->setJSON($response); // Mengirim respons JSON
    }

    // } // <- Tanda kurung penutup kelas

}
