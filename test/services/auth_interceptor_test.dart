import 'package:flutter_test/flutter_test.dart';

import 'package:livith/services/auth_interceptor.dart';
import 'package:livith/services/token_store.dart';

import 'package:dio/dio.dart';

void main() {
  group('AuthInterceptor는', () {
    test('저장된 액세스 토큰이 있으면 Authorization 헤더에 Bearer 토큰을 추가한다', () async {
      // Arrange
      final tokenStore = InMemoryTokenStore();
      await tokenStore.save(accessToken: 'access-123', refreshToken: 'refresh-456');
      final interceptor = AuthInterceptor(tokenStore);
      final options = RequestOptions(path: '/concerts');

      // Act
      interceptor.onRequest(options, RequestInterceptorHandler());

      // Assert
      expect(options.headers['Authorization'], 'Bearer access-123');
    });

    test('저장된 액세스 토큰이 없으면 Authorization 헤더를 추가하지 않는다', () {
      // Arrange
      final interceptor = AuthInterceptor(InMemoryTokenStore());
      final options = RequestOptions(path: '/concerts');

      // Act
      interceptor.onRequest(options, RequestInterceptorHandler());

      // Assert
      expect(options.headers.containsKey('Authorization'), isFalse);
    });
  });
}
