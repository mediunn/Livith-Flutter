import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/views/widgets/livith_button.dart';

enum LivithModalType { normal, welcome, error }

/// Livith 알림 모달.
///
/// iOS `LivithModal` 대응. 너비 328, 코너 12, 배경 `black90`, 내부 패딩 16.
/// 헤더 아이콘은 마일스톤 1에서 Material 아이콘으로 대체한다.
class LivithModal extends StatelessWidget {
  const LivithModal({
    super.key,
    required this.title,
    this.message,
    this.confirmTitle = '확인',
    this.type = LivithModalType.normal,
    this.onConfirm,
  });

  final String title;
  final String? message;
  final String confirmTitle;
  final LivithModalType type;
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LivithColors.black90,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_headerIcon != null) ...[
            Icon(_headerIcon, size: 40, color: LivithColors.yellow30),
            const SizedBox(height: 8),
          ] else
            const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: LivithTextStyles.body1Semibold.copyWith(color: LivithColors.white100),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: LivithTextStyles.body4Regular.copyWith(color: LivithColors.black30),
            ),
          ],
          const SizedBox(height: 20),
          LivithButton(
            confirmTitle,
            variant: type == LivithModalType.error
                ? LivithButtonVariant.pink
                : LivithButtonVariant.primary,
            cornerRadius: 4,
            onPressed: onConfirm ?? () {},
          ),
        ],
      ),
    );
  }

  IconData? get _headerIcon {
    return switch (type) {
      LivithModalType.welcome => Icons.celebration_outlined,
      LivithModalType.error => Icons.error_outline,
      LivithModalType.normal => null,
    };
  }
}

/// [LivithModal]을 다이얼로그로 표시한다.
Future<void> showLivithModal(
  BuildContext context, {
  required String title,
  String? message,
  String confirmTitle = '확인',
  LivithModalType type = LivithModalType.normal,
  VoidCallback? onConfirm,
}) {
  return showDialog<void>(
    context: context,
    builder: (dialogContext) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: LivithModal(
        title: title,
        message: message,
        confirmTitle: confirmTitle,
        type: type,
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          onConfirm?.call();
        },
      ),
    ),
  );
}
