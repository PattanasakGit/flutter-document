import 'package:ai_first_flutter_starter/core/errors/error_mapper.dart';
import 'package:dio/dio.dart';

final class ApiClient {
  factory ApiClient({
    required Dio dio,
    required ErrorMapper errorMapper,
  }) {
    return ApiClient._(dio, errorMapper);
  }

  const ApiClient._(this._dio, this._errorMapper);

  final Dio _dio;
  final ErrorMapper _errorMapper;

  Future<T> get<T>(
    String path, {
    required T Function(Object? data) decoder,
    Map<String, Object?>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<Object?>(
        path,
        queryParameters: queryParameters,
      );
      return decoder(response.data);
    } on DioException catch (error) {
      throw _errorMapper.mapDioException(error);
    }
  }

  Future<T> post<T>(
    String path, {
    required T Function(Object? data) decoder,
    Object? data,
  }) async {
    try {
      final response = await _dio.post<Object?>(path, data: data);
      return decoder(response.data);
    } on DioException catch (error) {
      throw _errorMapper.mapDioException(error);
    }
  }
}
