// ignore_for_file: public_member_api_docs
import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SignupLoginResponseDto {
  SignupLoginResponseDto({
    required this.user,
    required this.refreshToken,
    required this.accessToken,
    required this.emailVerified,
    required this.requiresVerification,
  });

  factory SignupLoginResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseDtoFromJson(json);

  final UserDto user;

  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'refresh_token')
  final String refreshToken;

  @JsonKey(
    name: 'email_verified',
    includeIfNull: false,
    defaultValue: false,
  )
  final bool? emailVerified;

  @JsonKey(
    name: 'requires_verification',
    includeIfNull: false,
    defaultValue: false,
  )
  final bool? requiresVerification;
}
