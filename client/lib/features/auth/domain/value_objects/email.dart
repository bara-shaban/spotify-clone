/* class Email {
  final String _value;

  Email(this._value) {
    if (!RegExp(r'^.+@.+\.+.+$').hasMatch(_value)) {
      throw InvalidEmailFailure();
    }
  }

  String getOrCrash() => _value;
}

class Password {
  final String _value;

  Password(this._value) {
    if (_value.length < 6) {
      throw InvalidPasswordFailure();
    }
  }

  String getOrCrash() => _value;
}

// Usage in repository
Future<User> login(Email email, Password password) async {
  // getOrCrash() gives us the validated raw strings for API call
  final loginDto = await _remoteDataSource.login(
    email.getOrCrash(),    // "test@test.com" (validated)
    password.getOrCrash(), // "secret123" (validated)
  );
  
  return User(...);
} */
