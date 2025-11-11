class ApiClientException implements Exception {
  ApiClientException({
    required this.message,
    this.statusCode,
    this.data,
    this.original,
  });

  final String message;
  final int? statusCode;
  final Map<String, dynamic>? data;
  final Object? original;

  @override
  String toString() =>
      'ApiClientException($statusCode): $message ${data == null ? "" : "data=$data"}';
}
