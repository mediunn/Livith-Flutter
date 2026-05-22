/// 푸시 알림 토큰 관리 인터페이스.
///
/// iOS FCM 연동 대응. 실제 SDK(Firebase Messaging) 연동은 네이티브 설정 후 교체한다.
abstract interface class NotificationService {
  /// FCM 토큰을 서버에 등록한다.
  Future<void> registerToken();

  /// FCM 토큰 등록을 해제한다.
  Future<void> unregisterToken();
}

/// 키/네이티브 설정 전 사용하는 stub 구현.
final class StubNotificationService implements NotificationService {
  const StubNotificationService();

  @override
  Future<void> registerToken() async {}

  @override
  Future<void> unregisterToken() async {}
}
