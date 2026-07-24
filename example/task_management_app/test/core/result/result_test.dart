import 'package:ai_first_flutter_starter/core/errors/failure.dart';
import 'package:ai_first_flutter_starter/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Success exposes typed data', () {
      const result = Success<int>(42);

      expect(result.data, 42);
      expect(result, isA<Result<int>>());
    });

    test('FailureResult exposes a typed failure', () {
      const failure = NetworkFailure();
      const result = FailureResult<int>(failure);

      expect(result.failure, same(failure));
      expect(result, isA<Result<int>>());
    });
  });
}
