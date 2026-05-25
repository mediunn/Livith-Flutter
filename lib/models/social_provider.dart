/// 소셜 로그인 제공자.
///
/// iOS `SocialLoginProvider` 대응. 서버 전송 값은 [value]를 사용한다.
enum SocialProvider {
  apple('apple'),
  kakao('kakao');

  const SocialProvider(this.value);

  final String value;

  static SocialProvider fromValue(String value) {
    return SocialProvider.values.firstWhere(
      (provider) => provider.value == value,
      orElse: () => SocialProvider.apple,
    );
  }
}
