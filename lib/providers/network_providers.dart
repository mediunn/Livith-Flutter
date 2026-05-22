import 'package:livith/services/auth_interceptor.dart';
import 'package:livith/services/token_store.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

/// API 베이스 URL. 마일스톤 2에서 환경별 설정으로 분리한다.
const String _apiBaseUrl = String.fromEnvironment(
  'LIVITH_API_BASE_URL',
  defaultValue: 'https://api.livith.app/api/v6',
);

/// 토큰 저장소. 마일스톤 1은 인메모리, 인증 마일스톤에서 영속 구현으로 override한다.
final tokenStoreProvider = Provider<TokenStore>((ref) => InMemoryTokenStore());

/// 앱 전역에서 재사용하는 고정 설정 Dio 인스턴스.
final dioProvider = Provider<Dio>((ref) {
  final tokenStore = ref.read(tokenStoreProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    ),
  );
  dio.interceptors.add(AuthInterceptor(tokenStore));

  return dio;
});
