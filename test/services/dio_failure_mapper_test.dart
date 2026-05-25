import 'package:flutter_test/flutter_test.dart';

import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

void main() {
  final options = RequestOptions(path: '/x');

  group('mapDioException은', () {
    test('401 응답을 AuthFailure로 매핑한다', () {
      final exception = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 401),
      );

      final failure = mapDioException(exception);

      expect(failure, isA<AuthFailure>());
    });

    test('500 응답을 상태코드를 보존한 ServerFailure로 매핑한다', () {
      final exception = DioException(
        requestOptions: options,
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: options, statusCode: 500),
      );

      final failure = mapDioException(exception);

      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 500);
    });

    test('연결 타임아웃을 NetworkFailure로 매핑한다', () {
      final exception = DioException(
        requestOptions: options,
        type: DioExceptionType.connectionTimeout,
      );

      final failure = mapDioException(exception);

      expect(failure, isA<NetworkFailure>());
    });
  });
}
