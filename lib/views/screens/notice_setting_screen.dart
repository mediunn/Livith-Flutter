import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/providers/integration_providers.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 알림 설정 화면.
///
/// iOS `NoticeSettingView` 대응. 마케팅 동의만 서버 연동(현재 stub),
/// 세부 알림 토글은 UI만 제공(저장 연동은 후속).
class NoticeSettingScreen extends ConsumerStatefulWidget {
  const NoticeSettingScreen({super.key});

  @override
  ConsumerState<NoticeSettingScreen> createState() => _NoticeSettingScreenState();
}

class _NoticeSettingScreenState extends ConsumerState<NoticeSettingScreen> {
  bool _marketing = false;
  bool _night = false;
  bool _ticketSchedule = true;
  bool _concertInfo = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LivithNavigationBar.back(title: '알림 설정', onBack: () => context.pop()),
      body: ListView(
        children: [
          _toggle('마케팅 정보 수신', _marketing, (value) {
            setState(() => _marketing = value);
            ref.read(notificationServiceProvider).updateMarketingConsent(agreed: value);
          }),
          _toggle('야간 알림', _night, (value) => setState(() => _night = value)),
          _toggle('예매 일정 알림', _ticketSchedule, (value) => setState(() => _ticketSchedule = value)),
          _toggle('공연 정보 업데이트', _concertInfo, (value) => setState(() => _concertInfo = value)),
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: LivithColors.yellow30,
      title: Text(
        label,
        style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
      ),
    );
  }
}
