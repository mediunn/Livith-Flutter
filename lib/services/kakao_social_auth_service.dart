import 'package:livith/services/social_auth_service.dart';

import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

/// 카카오 SDK 기반 소셜 로그인 구현.
///
/// 카카오톡이 설치돼 있으면 톡으로, 아니면 카카오 계정으로 로그인한다.
/// 애플 로그인은 Android에서 지원하지 않는다.
final class KakaoSocialAuthService implements SocialAuthService {
  const KakaoSocialAuthService();

  @override
  Future<String> obtainKakaoAccessToken() async {
    final token = await isKakaoTalkInstalled()
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();
    return token.accessToken;
  }

  @override
  Future<String> obtainAppleIdentityToken() {
    throw UnsupportedError('Android에서는 애플 로그인을 지원하지 않습니다');
  }
}
