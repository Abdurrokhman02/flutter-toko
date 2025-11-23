class Produk {
  final int? id;
  final String kodeProduk;
  final String namaProduk;
  final int harga;

  Produk({
    this.id,
    required this.kodeProduk,
    required this.namaProduk,
    required this.harga,
  });

  // Konversi dari JSON ke Objek Produk (Read)
  factory Produk.fromJson(Map<String, dynamic> json) {
    // Helper function untuk konversi String/Int ke int dengan aman
    int parseToInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    return Produk(
      // FIX ID: Pastikan ID juga dikonversi dengan aman (karena bisa saja null atau string)
      id: parseToInt(json['id']),

      kodeProduk: (json['kode_produk'] ?? '').toString(),
      namaProduk: (json['nama_produk'] ?? '').toString(),

      // FIX HARGA: Memanggil helper function untuk konversi String ke Int
      harga: parseToInt(json['harga']),
    );
  }

  // Konversi dari Objek Produk ke JSON (Create/Update)
  Map<String, dynamic> toJson() {
    return {
      'kode_produk': kodeProduk,
      'nama_produk': namaProduk,
      'harga': harga,
    };
  }
}
