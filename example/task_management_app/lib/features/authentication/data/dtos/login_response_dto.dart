import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_dto.freezed.dart';
part 'login_response_dto.g.dart';

@freezed
abstract class LoginResponseDto with _$LoginResponseDto {
  const factory LoginResponseDto({
    required String id,
    required String email,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'access_token') required String accessToken,
  }) = _LoginResponseDto;

  factory LoginResponseDto.fromJson(Map<String, Object?> json) =>
      _$LoginResponseDtoFromJson(json);
}
