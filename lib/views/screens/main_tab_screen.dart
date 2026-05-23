import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/views/screens/explore_screen.dart';
import 'package:livith/views/screens/home_screen.dart';
import 'package:livith/views/screens/user_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 메인 탭(홈/탐색/마이) 컨테이너.
///
/// iOS `LivithMainTabView` 대응.
class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int _index = 0;

  static const _screens = [HomeScreen(), ExploreScreen(), UserScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        backgroundColor: LivithColors.black90,
        selectedItemColor: LivithColors.yellow30,
        unselectedItemColor: LivithColors.black50,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: _icon('assets/icons/home_disabled.svg'),
            activeIcon: _icon('assets/icons/home_enabled.svg'),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: _icon('assets/icons/search.svg', color: LivithColors.black50),
            activeIcon: _icon('assets/icons/search.svg', color: LivithColors.yellow30),
            label: '탐색',
          ),
          BottomNavigationBarItem(
            icon: _icon('assets/icons/my_disabled.svg'),
            activeIcon: _icon('assets/icons/my_enabled.svg'),
            label: '마이',
          ),
        ],
      ),
    );
  }

  Widget _icon(String asset, {Color? color}) {
    return SvgPicture.asset(
      asset,
      width: 24,
      height: 24,
      colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
    );
  }
}
