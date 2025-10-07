import 'dart:convert';
//import 'dart:developer' as devtools show log;
import 'package:client/features/auth/model/user_model.dart';
import 'package:http/http.dart' as http;

/// A repository that handles authentication-related remote operations.
class AuthRemoteRepository {
  /// Signs up a new user.
  Future<UserModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final request = jsonEncode({
      'name': name,
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: request,
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        throw Exception('Failed to signup: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Failed to signup: $e');
    }
  }

  /// Logs in an existing user.
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final request = jsonEncode({
      'email': email,
      'password': password,
    });
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: request,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return UserModel.fromMap(data);
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Failed to login: $e');
    }
  }
}
