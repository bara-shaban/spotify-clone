// ignore_for_file: public_member_api_docs

class ApiResponse {
  ApiResponse({
    required this.statusCode,
    required this.data,
  });

  final int? statusCode;
  final dynamic data;
}
