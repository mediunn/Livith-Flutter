import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

enum LivithButtonVariant { primary, pink, secondary }

/// Livith 메인 버튼.
///
/// iOS `LivithButton` 대응. 높이 52, 코너 6, `body3Semibold`.
class LivithButton extends StatefulWidget {
  const LivithButton(
    this.title, {
    super.key,
    this.variant = LivithButtonVariant.primary,
    this.isFullWidth = true,
    this.isLoading = false,
    this.cornerRadius = 6,
    this.onPressed,
  });

  final String title;
  final LivithButtonVariant variant;
  final bool isFullWidth;
  final bool isLoading;
  final double cornerRadius;
  final VoidCallback? onPressed;

  @override
  State<LivithButton> createState() => _LivithButtonState();
}

class _LivithButtonState extends State<LivithButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      height: 52,
      width: widget.isFullWidth ? double.infinity : null,
      child: GestureDetector(
        onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: _enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
        onTap: _enabled ? widget.onPressed : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.circular(widget.cornerRadius),
          ),
          child: Center(child: _label),
        ),
      ),
    );
    return child;
  }

  Widget get _label {
    if (widget.isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: LivithColors.black100),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        widget.title,
        style: LivithTextStyles.body3Semibold.copyWith(color: _foregroundColor),
      ),
    );
  }

  Color get _backgroundColor {
    if (!_enabled) return LivithColors.black80;
    switch (widget.variant) {
      case LivithButtonVariant.primary:
        return _pressed ? LivithColors.yellow60 : LivithColors.yellow30;
      case LivithButtonVariant.pink:
        return _pressed
            ? LivithColors.translation.withValues(alpha: 0.8)
            : LivithColors.translation;
      case LivithButtonVariant.secondary:
        return _pressed ? LivithColors.black80 : LivithColors.black50;
    }
  }

  Color get _foregroundColor {
    if (!_enabled) return LivithColors.black50;
    return switch (widget.variant) {
      LivithButtonVariant.primary || LivithButtonVariant.pink => LivithColors.black100,
      LivithButtonVariant.secondary => LivithColors.white100,
    };
  }
}
