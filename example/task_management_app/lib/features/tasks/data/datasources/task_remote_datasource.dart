import 'package:ai_first_flutter_starter/core/network/api_client.dart';
import 'package:ai_first_flutter_starter/core/network/api_endpoint.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_dto.dart';
import 'package:ai_first_flutter_starter/features/tasks/data/dtos/task_write_request_dto.dart';

abstract interface class TaskRemoteDatasource {
  Future<List<TaskDto>> readAll();

  Future<TaskDto> create(CreateTaskRequestDto request);

  Future<TaskDto> update(String id, TaskUpdateRequestDto request);

  Future<TaskDto> toggle(String id);

  Future<void> delete(String id);
}

final class DioTaskRemoteDatasource implements TaskRemoteDatasource {
  const DioTaskRemoteDatasource(this._client);

  final ApiClient _client;

  @override
  Future<List<TaskDto>> readAll() {
    return _client.get<List<TaskDto>>(
      ApiEndpoint.tasks,
      decoder: TaskDto.decodeList,
    );
  }

  @override
  Future<TaskDto> create(CreateTaskRequestDto request) {
    return _client.post<TaskDto>(
      ApiEndpoint.tasks,
      data: request.toJson(),
      decoder: TaskDto.fromEnvelope,
    );
  }

  @override
  Future<TaskDto> update(String id, TaskUpdateRequestDto request) {
    return _client.put<TaskDto>(
      _taskPath(id),
      data: request.toJson(),
      decoder: TaskDto.fromEnvelope,
    );
  }

  @override
  Future<TaskDto> toggle(String id) {
    return _client.patch<TaskDto>(
      '${_taskPath(id)}/toggle',
      decoder: TaskDto.fromEnvelope,
    );
  }

  @override
  Future<void> delete(String id) {
    return _client.delete<void>(
      _taskPath(id),
      decoder: (_) {},
    );
  }

  String _taskPath(String id) {
    return '${ApiEndpoint.tasks}/${Uri.encodeComponent(id)}';
  }
}
