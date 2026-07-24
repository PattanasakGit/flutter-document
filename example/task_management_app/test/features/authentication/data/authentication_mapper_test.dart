import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_response_dto.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/mappers/authentication_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data.dart';

void main() {
  test('deserializes API JSON and maps it to an entity', () {
    final dto = LoginResponseDto.fromJson(TestData.loginResponseJson);

    final user = dto.toEntity();

    expect(user.id, TestData.userId);
    expect(user.email, TestData.email);
    expect(user.displayName, TestData.displayName);
    expect(dto.accessToken, TestData.token);
    expect(dto.toJson(), TestData.loginResponseJson);
  });
}
