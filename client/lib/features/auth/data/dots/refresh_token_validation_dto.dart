import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_validation_dto.g.dart';

@JsonSerializable(createToJson: false)
class RefreshTokenValidationDto {
  RefreshTokenValidationDto({required this.accessToken});

  @JsonKey(name: 'access_token', defaultValue: null)
  final String? accessToken;

  factory RefreshTokenValidationDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenValidationDtoFromJson(json);
}
