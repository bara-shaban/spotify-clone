import 'package:client/core/errors/failure.dart';

class AuthFailure extends Failure {
  AuthFailure(super.message, [super.stackTrace]);
}

class InvalidCredentialsFailure extends AuthFailure {
  InvalidCredentialsFailure() : super('Invalid email or password');
}

class EmailAlreadyExistsFailure extends AuthFailure {
  EmailAlreadyExistsFailure() : super('Email already exists');
}

class NetworkFailure extends AuthFailure {
  NetworkFailure() : super('Please check your internet connection');
}
