import 'package:livith/services/token_refresh_policy.dart';
import 'package:livith/services/token_store.dart';

import 'package:dio/dio.dart';

/// 401 응답 시 토큰을 갱신하고 원 요청을 1회 재시도하는 인터셉터.
///
/// 갱신 요청은 인터셉터가 없는 [refreshDio]로 보내 재귀를 방지하고,
/// 갱신에 실패하면 토큰을 비워 로그아웃 상태로 만든다.
final class RefreshInterceptor extends Interceptor {
  RefreshInterceptor({required this.refreshDio, required this.tokenStore});

  final Dio refreshDio;
  final TokenStore tokenStore;

  static const String _retriedKey = 'retried';

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final alreadyRetried = err.requestOptions.extra[_retriedKey] == true;
    final canRefresh = shouldAttemptRefresh(
      statusCode: err.response?.statusCode,
      hasRefreshToken: tokenStore.refreshToken != null,
      alreadyRetried: alreadyRetried,
    );
    if (!canRefresh) {
      handler.next(err);
      return;
    }

    try {
      await _refreshTokens();
      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (_) {
      await tokenStore.clear();
      handler.next(err);
    }
  }

  Future<void> _refreshTokens() async {
    final response = await refreshDio.post<Map<String, dynamic>>(
      '/auth/refresh',
      queryParameters: {'client': 'mobile'},
      data: {'refreshToken': tokenStore.refreshToken},
    );
    final data = response.data?['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw DioException(requestOptions: response.requestOptions);
    }
    await tokenStore.save(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions options) {
    options.extra[_retriedKey] = true;
    options.headers['Authorization'] = 'Bearer ${tokenStore.accessToken}';
    return refreshDio.fetch<dynamic>(options);
  }
}
