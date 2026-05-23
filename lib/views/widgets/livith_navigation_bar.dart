import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

enum _NavType { logo, back, backOnly }

/// Livith 공통 네비게이션 헤더.
///
/// iOS `LivithNavigationView` 대응. `Scaffold.appBar`에 사용한다.
/// 로고/알림/뒤로가기 아이콘은 마일스톤 1에서 텍스트·Material 아이콘으로 대체한다.
class LivithNavigationBar extends StatelessWidget implements PreferredSizeWidget {
  const LivithNavigationBar._(
    this._type, {
    this.hasNewNotice = false,
    this.onNoticeTap,
    this.title,
    this.onBack,
    this.rightButtonTitle,
    this.onRightButtonTap,
  });

  /// 홈/탐색 탭의 로고 헤더.
  factory LivithNavigationBar.logo({
    bool hasNewNotice = false,
    VoidCallback? onNoticeTap,
  }) {
    return LivithNavigationBar._(
      _NavType.logo,
      hasNewNotice: hasNewNotice,
      onNoticeTap: onNoticeTap,
    );
  }

  /// 제목 + 뒤로가기 + (선택) 우측 텍스트 버튼 헤더.
  factory LivithNavigationBar.back({
    required String title,
    required VoidCallback onBack,
    String? rightButtonTitle,
    VoidCallback? onRightButtonTap,
  }) {
    return LivithNavigationBar._(
      _NavType.back,
      title: title,
      onBack: onBack,
      rightButtonTitle: rightButtonTitle,
      onRightButtonTap: onRightButtonTap,
    );
  }

  /// 뒤로가기 버튼만 있는 헤더.
  factory LivithNavigationBar.backOnly({required VoidCallback onBack}) {
    return LivithNavigationBar._(_NavType.backOnly, onBack: onBack);
  }

  final _NavType _type;
  final bool hasNewNotice;
  final VoidCallback? onNoticeTap;
  final String? title;
  final VoidCallback? onBack;
  final String? rightButtonTitle;
  final VoidCallback? onRightButtonTap;

  @override
  Size get preferredSize => Size.fromHeight(_type == _NavType.logo ? 60 : 66);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: LivithColors.black100,
      child: SafeArea(bottom: false, child: _content()),
    );
  }

  Widget _content() {
    return switch (_type) {
      _NavType.logo => _logoContent(),
      _NavType.back => _backContent(),
      _NavType.backOnly => _backOnlyContent(),
    };
  }

  Widget _logoContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/livith_logo.png', height: 24),
          IconButton(
            onPressed: onNoticeTap,
            icon: Icon(
              Icons.notifications_outlined,
              color: hasNewNotice ? LivithColors.yellow30 : LivithColors.white100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _backContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _backButton(),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: LivithTextStyles.body1Semibold.copyWith(color: LivithColors.white100),
            ),
          ),
          const SizedBox(width: 4),
          if (rightButtonTitle != null)
            GestureDetector(
              onTap: onRightButtonTap,
              child: Text(
                rightButtonTitle!,
                style: LivithTextStyles.body4Regular.copyWith(color: LivithColors.black50),
              ),
            )
          else
            const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _backOnlyContent() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Align(alignment: Alignment.centerLeft, child: _backButton()),
    );
  }

  Widget _backButton() {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        padding: EdgeInsets.zero,
        onPressed: onBack,
        icon: const Icon(Icons.arrow_back_ios_new, color: LivithColors.white100, size: 20),
      ),
    );
  }
}
