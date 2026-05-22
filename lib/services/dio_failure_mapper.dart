import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// `DioException`을 도메인 [Failure]로 매핑한다.
Failure mapDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final statusCode = exception.response?.statusCode;
      if (statusCode == 401) return const AuthFailure();
      return ServerFailure(
        _serverMessage(exception) ?? '서버 오류가 발생했어요',
        statusCode: statusCode,
      );
    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const UnknownFailure();
  }
}

String? _serverMessage(DioException exception) {
  final data = exception.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'] ?? data['error'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
