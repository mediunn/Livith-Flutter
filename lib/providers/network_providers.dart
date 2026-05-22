import 'package:livith/services/auth_interceptor.dart';
import 'package:livith/services/refresh_interceptor.dart';
import 'package:livith/services/secure_token_store.dart';
import 'package:livith/services/token_store.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// API 베이스 URL. 환경별 값은 `--dart-define=LIVITH_API_BASE_URL=...`로 주입한다.
const String _apiBaseUrl = String.fromEnvironment(
  'LIVITH_API_BASE_URL',
  defaultValue: 'https://api.livith.app/api/v6',
);

BaseOptions _baseOptions() => BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
    );

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

/// 토큰 저장소. 앱 시작 시 [SecureTokenStore.load]로 캐시를 채운다.
final tokenStoreProvider = Provider<TokenStore>(
  (ref) => SecureTokenStore(ref.read(secureStorageProvider)),
);

/// 토큰 갱신 전용 Dio. 인터셉터가 없어 갱신 요청의 재귀를 방지한다.
final refreshDioProvider = Provider<Dio>((ref) => Dio(_baseOptions()));

/// 앱 전역에서 재사용하는 고정 설정 Dio 인스턴스.
final dioProvider = Provider<Dio>((ref) {
  final tokenStore = ref.read(tokenStoreProvider);

  final dio = Dio(_baseOptions());
  dio.interceptors.addAll([
    AuthInterceptor(tokenStore),
    RefreshInterceptor(
      refreshDio: ref.read(refreshDioProvider),
      tokenStore: tokenStore,
    ),
  ]);

  return dio;
});
