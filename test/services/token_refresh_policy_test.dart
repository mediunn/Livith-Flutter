import 'package:flutter_test/flutter_test.dart';

import 'package:livith/services/token_refresh_policy.dart';

void main() {
  group('shouldAttemptRefresh는', () {
    test('401이고 리프레시 토큰이 있으며 아직 재시도하지 않았으면 true를 반환한다', () {
      final result = shouldAttemptRefresh(
        statusCode: 401,
        hasRefreshToken: true,
        alreadyRetried: false,
      );

      expect(result, isTrue);
    });

    test('이미 재시도한 요청이면 false를 반환한다', () {
      final result = shouldAttemptRefresh(
        statusCode: 401,
        hasRefreshToken: true,
        alreadyRetried: true,
      );

      expect(result, isFalse);
    });

    test('리프레시 토큰이 없으면 false를 반환한다', () {
      final result = shouldAttemptRefresh(
        statusCode: 401,
        hasRefreshToken: false,
        alreadyRetried: false,
      );

      expect(result, isFalse);
    });

    test('401이 아니면 false를 반환한다', () {
      final result = shouldAttemptRefresh(
        statusCode: 500,
        hasRefreshToken: true,
        alreadyRetried: false,
      );

      expect(result, isFalse);
    });
  });
}
