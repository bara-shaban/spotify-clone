// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupResponseDto _$SignupResponseDtoFromJson(Map<String, dynamic> json) =>
    SignupResponseDto(
      accessToken: json['access_token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      emailVerified: json['email_verified'] as bool,
      requiresVerification: json['requires_verification'] as bool,
    );
