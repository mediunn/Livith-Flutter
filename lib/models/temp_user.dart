import 'package:livith/models/social_provider.dart';

/// 신규 가입 진행 중인 임시 사용자.
///
/// iOS `TempUser` 대응. 소셜 로그인 응답의 `isNewUser=true`일 때 생성된다.
final class TempUser {
  const TempUser({
    required this.provider,
    required this.providerId,
    this.email,
  });

  final SocialProvider provider;
  final String providerId;
  final String? email;

  factory TempUser.fromJson(Map<String, dynamic> json) {
    return TempUser(
      provider: SocialProvider.fromValue(json['provider'] as String),
      providerId: json['providerId'] as String,
      email: json['email'] as String?,
    );
  }
}
