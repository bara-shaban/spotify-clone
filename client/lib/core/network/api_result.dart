// ignore_for_file: public_member_api_docs

class ApiResult<T> {
  ApiResult.success(this.data) : success = true, error = null;
  ApiResult.failure(this.data) : success = false, error = null;

  final T? data;
  final String? error;
  final bool success;
}
