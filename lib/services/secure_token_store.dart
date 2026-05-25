import 'package:livith/services/token_store.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// `flutter_secure_storage`(iOS Keychain/Android Keystore) 기반 토큰 저장소.
///
/// `AuthInterceptor`가 동기로 토큰을 읽을 수 있도록 메모리 캐시를 유지하고,
/// 앱 시작 시 [load]로 저장소 값을 적재한다.
final class SecureTokenStore implements TokenStore {
  SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessKey = 'livith.accessToken';
  static const String _refreshKey = 'livith.refreshToken';

  String? _accessToken;
  String? _refreshToken;

  @override
  String? get accessToken => _accessToken;

  @override
  String? get refreshToken => _refreshToken;

  /// 저장소의 토큰을 메모리 캐시로 적재한다. 앱 시작 시 1회 호출한다.
  @override
  Future<void> load() async {
    _accessToken = await _storage.read(key: _accessKey);
    _refreshToken = await _storage.read(key: _refreshKey);
  }

  @override
  Future<void> save({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
  }

  @override
  Future<void> clear() async {
    _accessToken = null;
    _refreshToken = null;
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
