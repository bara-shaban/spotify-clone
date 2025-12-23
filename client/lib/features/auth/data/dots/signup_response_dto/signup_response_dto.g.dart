// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignupLoginResponseDto _$SignupResponseDtoFromJson(Map<String, dynamic> json) =>
    SignupLoginResponseDto(
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
      refreshToken: json['refresh_token'] as String,
      accessToken: json['access_token'] as String,
      emailVerified: json['email_verified'] as bool? ?? false,
      requiresVerification: json['requires_verification'] as bool? ?? false,
    );
