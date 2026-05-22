import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/views/screens/explore_screen.dart';
import 'package:livith/views/screens/home_screen.dart';
import 'package:livith/views/screens/user_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '탐색'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이'),
        ],
      ),
    );
  }
}
