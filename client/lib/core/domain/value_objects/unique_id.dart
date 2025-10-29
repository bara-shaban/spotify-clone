import 'package:client/core/errors/value_failure.dart';

class UniqueId {
  final String value;
  UniqueId(this.value) {
    if (value.isEmpty) {
      throw InvalidUniqueIdFalure();
    }
  }

  factory UniqueId.fromString(String value) => UniqueId(value);

  bool equals(UniqueId other) => value == other.value;
}
