// features/auth/domain/value_objects/name.dart
import 'package:client/features/auth/domain/failures/auth_value_failure.dart';

class Name {
  final String value;

  Name(this.value) {
    if (value.isEmpty) {
      throw InvalidNameFailure('Name cannot be empty');
    }
    if (value.length < 2) {
      throw InvalidNameFailure('Name must be at least 2 characters');
    }
    if (value.length > 50) {
      throw InvalidNameFailure('Name too long');
    }
  }

  String getOrCrash() => value;
}
