import 'package:client/features/auth/domain/failures/auth_value_failure.dart';

class Password {
  final String _value;

  Password(this._value) {
    if (_value.length < 8) {
      throw InvalidPasswordFailure();
    }
  }

  String getOrCrash() => _value;
}
