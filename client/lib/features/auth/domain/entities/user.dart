import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User entity
@freezed
abstract class User with _$User {
  /// Creates a [User].
  const factory User({
    required String id,
    required String email,
    required String name,
  }) = _User;

  /// Creates a [User] from JSON.
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
