// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  id: (json['user_id'] as num).toInt(),
  email: json['email'] as String,
  name: json['full_name'] as String,
  avatar: json['avatar'] as String? ?? '',
  createdAt: UserDto._dateTimeFromJson(json['createdAt'] as String?),
);
