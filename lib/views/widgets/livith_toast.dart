import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

enum LivithToastType { success, failure }

/// Livith 토스트.
///
/// iOS `LivithToast` 대응. 너비 343, 코너 8, 배경 `black80`.
/// 아이콘은 마일스톤 1에서 Material 아이콘으로 대체한다.
class LivithToast extends StatelessWidget {
  const LivithToast({super.key, required this.type, required this.message});

  final LivithToastType type;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      decoration: BoxDecoration(
        color: LivithColors.black80,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: LivithColors.black100.withValues(alpha: 0.4),
            blurRadius: 18,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(_icon, size: 30, color: _iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: LivithTextStyles.body4Semibold.copyWith(color: LivithColors.white100),
            ),
          ),
        ],
      ),
    );
  }

  IconData get _icon => switch (type) {
        LivithToastType.success => Icons.check_circle,
        LivithToastType.failure => Icons.warning_amber_rounded,
      };

  Color get _iconColor => switch (type) {
        LivithToastType.success => LivithColors.yellow30,
        LivithToastType.failure => LivithColors.caution100,
      };
}

/// [LivithToast]를 화면 하단에 띄우고 [duration] 후 자동으로 제거한다.
void showLivithToast(
  BuildContext context, {
  required LivithToastType type,
  required String message,
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (entryContext) => Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(entryContext).padding.bottom + 32,
      child: Center(child: LivithToast(type: type, message: message)),
    ),
  );

  overlay.insert(entry);
  Future<void>.delayed(duration, entry.remove);
}
