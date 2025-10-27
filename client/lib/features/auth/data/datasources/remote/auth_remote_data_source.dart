/// An abstract class representing the remote data source for authentication.
abstract class AuthRemoteDataSource {
  /// Signs up a new user.
  Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Logs in an existing user.
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  });
}
