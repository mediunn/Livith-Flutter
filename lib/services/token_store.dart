/// 액세스/리프레시 토큰을 보관하는 저장소.
///
/// 마일스톤 1에서는 인메모리 구현만 제공하고, 영속 저장(Keychain/SecureStorage)은
/// 인증 마일스톤에서 별도 구현으로 교체한다.
abstract interface class TokenStore {
  String? get accessToken;
  String? get refreshToken;

  /// 영속 저장소의 토큰을 메모리 캐시로 적재한다(인메모리 구현은 no-op).
  Future<void> load();
  Future<void> save({required String accessToken, required String refreshToken});
  Future<void> clear();
}

final class InMemoryTokenStore implements TokenStore {
  String? _accessToken;
  String? _refreshToken;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  @override
  Future<void> load() async {}

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
  }
}
