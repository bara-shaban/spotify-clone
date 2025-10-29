import 'package:client/core/errors/value_failure.dart';

class AuthValueFailure extends ValueFailure {
  const AuthValueFailure(super.message, [super.StackTrace]);
}

class InvalidNameFailure extends AuthValueFailure {
  InvalidNameFailure([
    String message = 'Name must be between 2 and 50 characters',
  ]) : super(message);
}
