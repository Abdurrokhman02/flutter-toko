<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');
// app/Config/Routes.php

// ... (kode routing bawaan CI4) ...

/**
 * --------------------------------------------------------------------
 * API Routes
 * --------------------------------------------------------------------
 */

// Rute untuk registrasi
// Memetakan: POST http://.../public/registrasi
// Ke:         RegistrasiController, fungsi create()
$routes->post('registrasi', 'RegistrasiController::create');

// Rute untuk login
// Memetakan: POST http://.../public/login
// Ke:         LoginController, fungsi login()
$routes->post('login', 'LoginController::login');
$routes->post('logout', 'LogoutController::logout');

// Grup routing untuk '/produk'
// Semua rute di dalam grup ini akan memiliki awalan '/produk'
$routes->group('produk', function($routes) {

    // GET /produk -> ProdukController::list()
    $routes->get('/', 'ProdukController::list');

    // (:num) adalah placeholder CI4 untuk angka (ID)
    // $1 akan memasukkan angka tersebut sebagai parameter

    // GET /produk/123 -> ProdukController::detail(123)
    $routes->get('(:num)', 'ProdukController::detail/$1');

    // POST /produk -> ProdukController::create()
    $routes->post('/', 'ProdukController::create');

    // PUT /produk/123 -> ProdukController::update(123)
    $routes->put('(:num)', 'ProdukController::update/$1');

    // DELETE /produk/123 -> ProdukController::delete(123)
    $routes->delete('(:num)', 'ProdukController::delete/$1');
});

