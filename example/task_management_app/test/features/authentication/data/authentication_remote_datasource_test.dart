import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/datasources/authentication_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/authentication/data/dtos/login_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/test_data.dart';

void main() {
  late FakeAuthenticationRemoteDatasource datasource;

  setUp(() {
    datasource = const FakeAuthenticationRemoteDatasource(
      responseDelay: Duration.zero,
    );
  });

  test('returns a response DTO for the documented demo credentials', () async {
    const request = LoginRequestDto(
      email: TestData.email,
      password: TestData.password,
    );

    final response = await datasource.login(request);

    expect(response.email, TestData.email);
    expect(response.accessToken, TestData.token);
  });

  test('throws an unauthorized exception for invalid credentials', () async {
    const request = LoginRequestDto(
      email: TestData.email,
      password: 'wrong-password',
    );

    final call = datasource.login(request);

    await expectLater(call, throwsA(isA<UnauthorizedAppException>()));
  });
}
