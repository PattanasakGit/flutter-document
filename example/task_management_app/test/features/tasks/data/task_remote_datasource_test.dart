import 'package:ai_first_flutter_starter/core/errors/app_exception.dart';
import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:ai_first_flutter_starter/core/network/api_client.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_write_request_dto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final class _MockDio extends Mock implements Dio {}

void main() {
  late Dio dio;
  late DioTaskRemoteDatasource datasource;

  setUp(() {
    dio = _MockDio();
    datasource = DioTaskRemoteDatasource(
      ApiClient(dio: dio, errorMapper: const ErrorMapper()),
    );
  });

  test('decodes a checked task-list response', () async {
    when(
      () => dio.get<Object?>(
        '/v1/tasks',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks',
        <String, Object?>{
          'data': [
            <String, Object?>{
              'id': 'task-1',
              'title': 'Learn Dart',
              'description': 'Practice records',
              'completed': false,
              'created_at': '2026-07-24T10:00:00Z',
            },
          ],
        },
      ),
    );

    final tasks = await datasource.readAll();

    expect(tasks.single.id, 'task-1');
    expect(tasks.single.createdAt, DateTime.utc(2026, 7, 24, 10));
  });

  test('maps a malformed response to SchemaAppException', () async {
    when(
      () => dio.get<Object?>(
        '/v1/tasks',
        queryParameters: any(named: 'queryParameters'),
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks',
        <String, Object?>{
          'data': [
            <String, Object?>{'id': 42},
          ],
        },
      ),
    );

    await expectLater(
      datasource.readAll,
      throwsA(isA<SchemaAppException>()),
    );
  });

  test('serializes create and update requests at the HTTP boundary', () async {
    const createRequest = CreateTaskRequestDto(
      title: 'Ship guide',
      description: 'Verify first',
    );
    when(
      () => dio.post<Object?>(
        '/v1/tasks',
        data: createRequest.toJson(),
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks',
        _taskEnvelope(title: 'Ship guide'),
      ),
    );

    final created = await datasource.create(createRequest);

    expect(created.title, 'Ship guide');

    const updateRequest = TaskUpdateRequestDto(
      title: 'Ship verified guide',
      description: 'All checks pass',
      completed: true,
    );
    when(
      () => dio.put<Object?>(
        '/v1/tasks/task-1',
        data: updateRequest.toJson(),
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks/task-1',
        _taskEnvelope(title: 'Ship verified guide', completed: true),
      ),
    );

    final updated = await datasource.update('task-1', updateRequest);

    expect(updated.title, 'Ship verified guide');
    expect(updated.completed, isTrue);
  });

  test('uses explicit toggle and delete endpoints', () async {
    when(
      () => dio.patch<Object?>(
        '/v1/tasks/task-1/toggle',
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks/task-1/toggle',
        _taskEnvelope(title: 'Learn Dart', completed: true),
      ),
    );
    when(
      () => dio.delete<Object?>(
        '/v1/tasks/task-1',
      ),
    ).thenAnswer(
      (_) async => _response('/v1/tasks/task-1', null),
    );

    final toggled = await datasource.toggle('task-1');
    await datasource.delete('task-1');

    expect(toggled.completed, isTrue);
    verify(
      () => dio.delete<Object?>('/v1/tasks/task-1'),
    ).called(1);
  });

  test('encodes a task identity as one URL path segment', () async {
    when(
      () => dio.patch<Object?>(
        '/v1/tasks/task%2F1%20%3F%23/toggle',
      ),
    ).thenAnswer(
      (_) async => _response(
        '/v1/tasks/task%2F1%20%3F%23/toggle',
        _taskEnvelope(title: 'Encoded identity', completed: true),
      ),
    );

    final toggled = await datasource.toggle('task/1 ?#');

    expect(toggled.completed, isTrue);
    verify(
      () => dio.patch<Object?>(
        '/v1/tasks/task%2F1%20%3F%23/toggle',
      ),
    ).called(1);
  });
}

Response<Object?> _response(String path, Object? data) {
  return Response<Object?>(
    requestOptions: RequestOptions(path: path),
    data: data,
  );
}

Map<String, Object?> _taskEnvelope({
  required String title,
  bool completed = false,
}) {
  return <String, Object?>{
    'data': <String, Object?>{
      'id': 'task-1',
      'title': title,
      'description': '',
      'completed': completed,
      'created_at': '2026-07-24T10:00:00Z',
    },
  };
}
