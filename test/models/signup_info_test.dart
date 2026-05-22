import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/signup_info.dart';
import 'package:livith/models/social_provider.dart';

void main() {
  group('SignupInfo.toJson은', () {
    test('서버 요청 키로 직렬화한다', () {
      const info = SignupInfo(
        provider: SocialProvider.kakao,
        providerId: 'kakao-1',
        email: 'a@b.com',
        nickname: '라이빗',
        isMarketingAgreed: true,
        preferredGenreIdList: [1, 2],
        preferredArtistIdList: [10],
      );

      final json = info.toJson();

      expect(json['nickname'], '라이빗');
      expect(json['provider'], 'kakao');
      expect(json['providerId'], 'kakao-1');
      expect(json['email'], 'a@b.com');
      expect(json['marketingConsent'], isTrue);
      expect(json['preferredGenreIds'], [1, 2]);
      expect(json['preferredArtistIds'], [10]);
    });
  });
}
