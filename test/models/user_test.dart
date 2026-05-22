import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/login_status.dart';
import 'package:livith/models/social_provider.dart';
import 'package:livith/models/temp_user.dart';
import 'package:livith/models/user.dart';

void main() {
  group('User.fromJson은', () {
    test('users/me 응답을 파싱하고 hasPreferredGenre를 hasPreferences로 매핑한다', () {
      final json = <String, dynamic>{
        'id': 7,
        'provider': 'kakao',
        'providerId': 'kakao-123',
        'email': 'a@b.com',
        'nickname': '라이빗',
        'marketingConsent': true,
        'hasPreferredGenre': true,
      };

      final user = User.fromJson(json);

      expect(user.id, 7);
      expect(user.provider, SocialProvider.kakao);
      expect(user.providerId, 'kakao-123');
      expect(user.nickname, '라이빗');
      expect(user.hasPreferences, isTrue);
      expect(user.marketingConsent, isTrue);
    });
  });

  group('TempUser.fromJson은', () {
    test('provider 문자열과 providerId, email을 파싱한다', () {
      final json = <String, dynamic>{
        'provider': 'apple',
        'providerId': 'apple-999',
        'email': null,
      };

      final tempUser = TempUser.fromJson(json);

      expect(tempUser.provider, SocialProvider.apple);
      expect(tempUser.providerId, 'apple-999');
      expect(tempUser.email, isNull);
    });
  });

  group('LoginStatus.fromJson은', () {
    test('isNewUser=false면 토큰을 가진 ExistingUser를 반환한다', () {
      final json = <String, dynamic>{
        'isNewUser': false,
        'accessToken': 'access-1',
        'refreshToken': 'refresh-1',
      };

      final status = LoginStatus.fromJson(json);

      expect(status, isA<ExistingUser>());
      expect((status as ExistingUser).accessToken, 'access-1');
      expect(status.refreshToken, 'refresh-1');
    });

    test('isNewUser=true면 tempUserData를 가진 NewUser를 반환한다', () {
      final json = <String, dynamic>{
        'isNewUser': true,
        'tempUserData': {
          'provider': 'apple',
          'providerId': 'apple-1',
          'email': 'x@y.com',
        },
      };

      final status = LoginStatus.fromJson(json);

      expect(status, isA<NewUser>());
      expect((status as NewUser).tempUser.providerId, 'apple-1');
    });
  });
}
