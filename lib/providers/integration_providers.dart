import 'package:livith/services/analytics_service.dart';
import 'package:livith/services/notification_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 이벤트 분석 Service. 키 확보 전까지 no-op을 사용한다.
final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => const NoOpAnalyticsService(),
);

/// 푸시 알림 Service. 네이티브 설정 전까지 stub을 사용한다.
final notificationServiceProvider = Provider<NotificationService>(
  (ref) => const StubNotificationService(),
);
