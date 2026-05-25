import 'package:livith/models/user.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 사용자 정보 API 인터페이스.
///
/// iOS `UserRepository`/`UserEndpoint` 대응. 인증이 필요한 요청만 다룬다.
abstract interface class UserService {
  /// 현재 로그인한 사용자 정보를 조회한다.
  Future<User> fetchMe();

  /// 닉네임을 수정하고 갱신된 사용자 정보를 반환한다.
  Future<User> updateNickname(String nickname);
}

/// Dio 기반 [UserService] 구현.
final class DioUserService implements UserService {
  DioUserService(this._dio);

  final Dio _dio;

  @override
  Future<User> fetchMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      return User.fromJson(_data(response));
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  @override
  Future<User> updateNickname(String nickname) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/users/nickname',
        data: {'nickname': nickname},
      );
      return User.fromJson(_data(response));
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Map<String, dynamic> _data(Response<Map<String, dynamic>> response) {
    final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data ?? const {},
      (data) => data as Map<String, dynamic>,
    );
    final data = parsed.data;
    if (data == null) throw const ParsingFailure();
    return data;
  }
}
