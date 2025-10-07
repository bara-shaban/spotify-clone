import 'dart:convert';
import 'package:flutter/foundation.dart';

/// A placeholder user model class.
@immutable
class UserModel {
  /// Creates a [UserModel] instance.
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  /// Creates a [UserModel] instance from a JSON string.
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  /// Creates a [UserModel] instance from a map.
  factory UserModel.fromMap(Map<String, dynamic> map) {
    if (map.containsKey('user')) {
      final userMap = map['user'] as Map<String, dynamic>;
      return UserModel(
        id: userMap['id'] as String? ?? '',
        name: userMap['name'] as String? ?? '',
        email: userMap['email'] as String? ?? '',
      );
    }
    if (map.isEmpty) {
      throw Exception('Map is empty');
    }
    return UserModel(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
    );
  }

  /// Converts the [UserModel] instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// The unique identifier of the user.
  final String id;

  /// The name of the user.
  final String name;

  /// The email of the user.
  final String email;

  /// Converts the [UserModel] instance to a map.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  /// Creates a copy of the current [UserModel]
  /// instance with optional new values.
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.email == email;
  }

  @override
  int get hashCode => Object.hash(id, name, email);
}
