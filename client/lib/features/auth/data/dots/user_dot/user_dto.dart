// ignore_for_file: public_member_api_docs

import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(createToJson: false) // Only fromJson if needed
class UserDto {
  UserDto({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    this.createdAt,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
  @JsonKey(name: 'id', fromJson: _idFromJson)
  final String id;

  final String email;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(defaultValue: '', includeIfNull: false)
  final String avatar;

  @JsonKey(fromJson: _dateTimeFromJson, includeIfNull: false)
  final DateTime? createdAt;

  static DateTime? _dateTimeFromJson(String? timestamp) =>
      timestamp != null ? DateTime.parse(timestamp) : null;

  static String _idFromJson(dynamic id) => id?.toString() ?? '';
}
