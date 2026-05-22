import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

enum LivithChipStyle { status, selected, tag, dark, outline }

/// Livith 칩.
///
/// iOS `LivithChip` 대응. 폰트 `caption1Bold`, 높이 30.
class LivithChip extends StatelessWidget {
  const LivithChip(this.text, {super.key, this.style = LivithChipStyle.status});

  final String text;
  final LivithChipStyle style;

  @override
  Widget build(BuildContext context) {
    final spec = _spec;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spec.horizontalPadding,
        vertical: spec.verticalPadding,
      ),
      decoration: BoxDecoration(
        color: spec.background,
        borderRadius: BorderRadius.circular(spec.radius),
        border: spec.borderColor == null
            ? null
            : Border.all(color: spec.borderColor!),
      ),
      child: Text(
        text,
        style: LivithTextStyles.caption1Bold.copyWith(color: spec.textColor),
      ),
    );
  }

  _ChipSpec get _spec {
    return switch (style) {
      LivithChipStyle.status => const _ChipSpec(
        background: LivithColors.black90,
        textColor: LivithColors.black30,
        radius: 24,
        horizontalPadding: 12,
        verticalPadding: 7,
      ),
      LivithChipStyle.selected => const _ChipSpec(
        background: LivithColors.yellow30,
        textColor: LivithColors.black100,
        radius: 24,
        horizontalPadding: 12,
        verticalPadding: 7,
      ),
      LivithChipStyle.tag => const _ChipSpec(
        background: LivithColors.black80,
        textColor: LivithColors.black30,
        radius: 16,
        horizontalPadding: 12,
        verticalPadding: 8,
      ),
      LivithChipStyle.dark => const _ChipSpec(
        background: LivithColors.black100,
        textColor: LivithColors.black50,
        radius: 24,
        horizontalPadding: 9,
        verticalPadding: 4,
      ),
      LivithChipStyle.outline => const _ChipSpec(
        background: Colors.transparent,
        textColor: LivithColors.black50,
        radius: 24,
        horizontalPadding: 12,
        verticalPadding: 4,
        borderColor: LivithColors.black50,
      ),
    };
  }
}

final class _ChipSpec {
  const _ChipSpec({
    required this.background,
    required this.textColor,
    required this.radius,
    required this.horizontalPadding,
    required this.verticalPadding,
    this.borderColor,
  });

  final Color background;
  final Color textColor;
  final double radius;
  final double horizontalPadding;
  final double verticalPadding;
  final Color? borderColor;
}
