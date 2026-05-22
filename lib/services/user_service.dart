import 'package:livith/models/user.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 사용자 정보 API 클라이언트.
///
/// iOS `UserRepository`/`UserEndpoint` 대응. 인증이 필요한 요청만 다룬다.
final class UserService {
  UserService(this._dio);

  final Dio _dio;

  /// 현재 로그인한 사용자 정보를 조회한다.
  Future<User> fetchMe() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/users/me');
      return User.fromJson(_data(response));
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  /// 닉네임을 수정하고 갱신된 사용자 정보를 반환한다.
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
