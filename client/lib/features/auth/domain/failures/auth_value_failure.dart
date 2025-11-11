import 'package:client/core/errors/value_failure.dart';

class AuthValueFailure extends ValueFailure {
  const AuthValueFailure(super.message, [super.StackTrace]);
}

class InvalidNameFailure extends AuthValueFailure {
  InvalidNameFailure([
    String message = 'Name must be between 2 and 50 characters',
  ]) : super(message);
}

class InvalidEmailFailure extends AuthValueFailure {
  InvalidEmailFailure([
    String message = 'Invalid email format',
  ]) : super(message);
}

class InvalidPasswordFailure extends AuthValueFailure {
  InvalidPasswordFailure([
    String message =
        'Password must be at least 8 characters long and include a number and a special character',
  ]) : super(message);
}
