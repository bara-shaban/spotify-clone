// ignore_for_file: public_member_api_docs
import 'package:client/features/auth/data/dots/user_dot/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'signup_response_dto.g.dart';

@JsonSerializable(createToJson: false)
class SignupResponseDto {
  SignupResponseDto({
    required this.accessToken,
    required this.user,
    required this.emailVerified,
    required this.requiresVerification,
  });
  @JsonKey(name: 'access_token')
  final String accessToken;
  final UserDto user;
  @JsonKey(name: 'email_verified', includeIfNull: false)
  final bool emailVerified;
  @JsonKey(name: 'requires_verification', includeIfNull: false)
  final bool requiresVerification;

  factory SignupResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseDtoFromJson(json);
}
