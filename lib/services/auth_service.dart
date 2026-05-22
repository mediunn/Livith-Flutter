import 'package:livith/models/login_status.dart';
import 'package:livith/models/signup_info.dart';
import 'package:livith/models/user.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 인증/온보딩 API 클라이언트.
///
/// iOS `AuthRepository`/`OnboardingEndpoint` 대응. 실패는 [mapDioException]으로
/// 도메인 `Failure`에 매핑해 던진다.
final class AuthService {
  AuthService(this._dio);

  final Dio _dio;

  /// 애플 로그인. `identityToken`을 전달하고 로그인 상태를 반환한다.
  Future<LoginStatus> loginWithApple(String identityToken) {
    return _login('/auth/apple/mobile', {'identityToken': identityToken});
  }

  /// 카카오 로그인. 카카오 `accessToken`을 전달하고 로그인 상태를 반환한다.
  Future<LoginStatus> loginWithKakao(String accessToken) {
    return _login('/auth/kakao/mobile', {'accessToken': accessToken});
  }

  /// 회원가입. 성공 시 토큰과 사용자 정보를 반환한다.
  Future<SignupResult> signup(SignupInfo info) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/signup',
        queryParameters: {'client': 'mobile'},
        data: info.toJson(),
      );
      final data = _data(response);
      return SignupResult(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
        user: User.fromJson(data['user'] as Map<String, dynamic>),
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  /// 닉네임 사용 가능 여부. `available`이 true면 사용 가능하다.
  Future<bool> isNicknameAvailable(String nickname) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/users/check-nickname',
        queryParameters: {'nickname': nickname},
      );
      return _data(response)['available'] as bool;
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  /// 로그아웃.
  Future<void> logout(String refreshToken) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/auth/logout',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  /// 회원 탈퇴.
  Future<void> withdraw(String reason) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/auth/withdraw',
        data: {'reason': reason},
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Future<LoginStatus> _login(String path, Map<String, dynamic> body) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(path, data: body);
      return LoginStatus.fromJson(_data(response));
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

/// 회원가입 성공 결과.
final class SignupResult {
  const SignupResult({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final User user;
}
