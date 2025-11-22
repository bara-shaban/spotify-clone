import 'package:client/features/auth/domain/entities/user.dart';

class AuthResult {
  AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  final User user;
  final String accessToken;
  final String refreshToken;
}
