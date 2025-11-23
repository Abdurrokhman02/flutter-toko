import 'package:flutter/material.dart';

import 'ui/login_page.dart';
import 'ui/produk_list_page.dart';
import 'ui/registrasi_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/registrasi': (context) => const RegistrasiPage(),
        '/produk': (context) => const ProdukListPage(),
      },
    );
  }
}
