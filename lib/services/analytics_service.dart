/// 이벤트 분석 인터페이스.
///
/// iOS `AmplitudeService` 대응. 실제 SDK 연동은 키 확보 후 구현으로 교체한다.
abstract interface class AnalyticsService {
  /// 이벤트를 기록한다.
  void track(String event, [Map<String, Object?> properties]);
}

/// 분석 비활성(개발/키 미확보) 시 사용하는 no-op 구현.
final class NoOpAnalyticsService implements AnalyticsService {
  const NoOpAnalyticsService();

  @override
  void track(String event, [Map<String, Object?> properties = const {}]) {}
}
