import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late ApiClient client;

  setUp(() {
    dio = _MockDio();
    client = ApiClient(dio: dio, errorMapper: const ErrorMapper());
  });

  test('decodes response data without exposing a Dio Response', () async {
    final request = RequestOptions(path: '/profile');
    when(
      () => dio.get<Object?>(
        '/profile',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => Response<Object?>(
        requestOptions: request,
        data: <String, Object?>{'display_name': 'Demo User'},
      ),
    );

    final displayName = await client.get<String>(
      '/profile',
      decoder: (data) =>
          (data! as Map<String, Object?>)['display_name']! as String,
    );

    expect(displayName, 'Demo User');
  });

  test('converts DioException before it crosses the client boundary', () async {
    when(
      () => dio.get<Object?>(
        '/profile',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: '/profile'),
        type: DioExceptionType.receiveTimeout,
      ),
    );

    final call = client.get<String>(
      '/profile',
      decoder: (data) => data! as String,
    );

    await expectLater(call, throwsA(isA<TimeoutAppException>()));
  });

  test('posts a request body and decodes response data', () async {
    final request = RequestOptions(path: '/sessions');
    const body = <String, Object?>{'email': 'demo@example.com'};
    when(
      () => dio.post<Object?>('/sessions', data: body),
    ).thenAnswer(
      (_) async => Response<Object?>(
        requestOptions: request,
        data: <String, Object?>{'id': 'session-1'},
      ),
    );

    final sessionId = await client.post<String>(
      '/sessions',
      data: body,
      decoder: (data) => (data! as Map<String, Object?>)['id']! as String,
    );

    expect(sessionId, 'session-1');
  });
}
