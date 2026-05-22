import 'package:livith/models/social_provider.dart';

/// 로그인한 사용자.
///
/// iOS `User` 대응. `GET /users/me`, signup, 닉네임 수정 응답에서 생성한다.
/// 알림 권한(`UserAuthority`) 세부는 알림 설정 마일스톤에서 확장한다.
final class User {
  const User({
    required this.id,
    required this.provider,
    this.providerId,
    this.email,
    required this.nickname,
    required this.hasPreferences,
    required this.marketingConsent,
  });

  final int id;
  final SocialProvider provider;
  final String? providerId;
  final String? email;
  final String nickname;
  final bool hasPreferences;
  final bool marketingConsent;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      provider: SocialProvider.fromValue(json['provider'] as String),
      providerId: json['providerId'] as String?,
      email: json['email'] as String?,
      nickname: json['nickname'] as String,
      hasPreferences: (json['hasPreferredGenre'] as bool?) ?? false,
      marketingConsent: (json['marketingConsent'] as bool?) ?? false,
    );
  }

  User copyWith({String? nickname, bool? hasPreferences, bool? marketingConsent}) {
    return User(
      id: id,
      provider: provider,
      providerId: providerId,
      email: email,
      nickname: nickname ?? this.nickname,
      hasPreferences: hasPreferences ?? this.hasPreferences,
      marketingConsent: marketingConsent ?? this.marketingConsent,
    );
  }
}
