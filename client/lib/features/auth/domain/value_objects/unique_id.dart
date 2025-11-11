import 'package:client/core/errors/value_failure.dart';

/// A unique identifier value object.
class UniqueId {
  final String value;
  UniqueId(this.value) {
    if (value.isEmpty) {
      throw const InvalidUniqueIdFailure();
    }
  }

  factory UniqueId.fromString(String value) => UniqueId(value);

  bool equals(UniqueId other) => value == other.value;
}
