import 'package:livith/models/social_provider.dart';

/// 회원가입 요청 정보.
///
/// iOS `SignupInfo` 대응. `POST /auth/signup` 요청 바디로 직렬화한다.
final class SignupInfo {
  const SignupInfo({
    required this.provider,
    required this.providerId,
    this.email,
    required this.nickname,
    required this.isMarketingAgreed,
    required this.preferredGenreIdList,
    required this.preferredArtistIdList,
  });

  final SocialProvider provider;
  final String providerId;
  final String? email;
  final String nickname;
  final bool isMarketingAgreed;
  final List<int> preferredGenreIdList;
  final List<int> preferredArtistIdList;

  Map<String, dynamic> toJson() {
    return {
      'nickname': nickname,
      'preferredArtistIds': preferredArtistIdList,
      'preferredGenreIds': preferredGenreIdList,
      'email': email,
      'provider': provider.value,
      'providerId': providerId,
      'marketingConsent': isMarketingAgreed,
    };
  }
}
