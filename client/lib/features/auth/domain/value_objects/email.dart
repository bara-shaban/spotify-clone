import 'package:client/features/auth/domain/failures/auth_value_failure.dart';

class Email {
  final String _value;

  Email(this._value) {
    if (!RegExp(r'^.+@.+\.+.+$').hasMatch(_value)) {
      throw InvalidEmailFailure();
    }
  }

  String getOrCrash() => _value;
}
