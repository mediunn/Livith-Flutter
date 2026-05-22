import 'package:livith/models/social_provider.dart';

/// 소셜 로그인 토큰 획득 인터페이스.
///
/// iOS `SocialAuthService`(Kakao/Apple SDK) 대응. 실제 SDK 연동은 네이티브 키 설정이
/// 필요하므로, 키 확보 전까지 [StubSocialAuthService]를 사용한다.
abstract interface class SocialAuthService {
  /// 애플 `identityToken`을 획득한다.
  Future<String> obtainAppleIdentityToken();

  /// 카카오 `accessToken`을 획득한다.
  Future<String> obtainKakaoAccessToken();
}

/// 키 확보 전 사용하는 stub 구현. 고정 토큰을 반환한다.
final class StubSocialAuthService implements SocialAuthService {
  const StubSocialAuthService();

  @override
  Future<String> obtainAppleIdentityToken() async => 'stub-apple-identity-token';

  @override
  Future<String> obtainKakaoAccessToken() async => 'stub-kakao-access-token';
}

/// 소셜 로그인 제공자별 토큰 획득을 단일 메서드로 노출한다.
extension SocialAuthByProvider on SocialAuthService {
  Future<String> obtainToken(SocialProvider provider) {
    return switch (provider) {
      SocialProvider.apple => obtainAppleIdentityToken(),
      SocialProvider.kakao => obtainKakaoAccessToken(),
    };
  }
}
