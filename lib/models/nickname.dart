/// 검증된 닉네임 값 객체.
///
/// iOS `Nickname` 대응. 규칙: 영문/숫자/한글 1~10자(`^[a-zA-Z0-9가-힣]{1,10}$`).
final class Nickname {
  const Nickname._(this.value);

  final String value;

  static final RegExp _pattern = RegExp(r'^[a-zA-Z0-9가-힣]{1,10}$');

  /// 닉네임 규칙을 만족하는지 검사한다.
  static bool isValid(String value) => _pattern.hasMatch(value);

  /// 규칙을 만족하면 [Nickname]을, 아니면 null을 반환한다.
  static Nickname? tryParse(String value) {
    return isValid(value) ? Nickname._(value) : null;
  }
}
