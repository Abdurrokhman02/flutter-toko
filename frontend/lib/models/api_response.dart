class ApiResponse {
  final bool status;
  final String data;
  final int? code;

  ApiResponse({required this.status, required this.data, this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    // Ambil status code dan pastikan dianggap integer
    int statusCode = 0;
    if (json['status'] != null && json['status'] is int) {
      statusCode = json['status'];
    }

    return ApiResponse(
      // FIX UTAMA: 200 atau 201 berarti TRUE
      status: (statusCode == 200 || statusCode == 201),

      // Ambil pesan dari 'message' (standar CI4) atau 'data'
      data: (json['message'] ?? json['data'] ?? '').toString(),

      code: statusCode,
    );
  }
}
