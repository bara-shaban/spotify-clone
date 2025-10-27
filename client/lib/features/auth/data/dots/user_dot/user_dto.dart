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
  @JsonKey(name: 'user_id')
  final int id;

  final String email;

  @JsonKey(name: 'full_name')
  final String name;

  @JsonKey(defaultValue: '')
  final String avatar;

  @JsonKey(fromJson: _dateTimeFromJson)
  final DateTime? createdAt;

  static DateTime? _dateTimeFromJson(String? timestamp) =>
      timestamp != null ? DateTime.parse(timestamp) : null;
}
