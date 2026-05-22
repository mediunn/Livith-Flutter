import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 마이 화면.
///
/// iOS `UserView` 대응. 프로필/설정은 마이 마일스톤에서 채운다.
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: LivithNavigationBar.logo(),
      body: Center(
        child: Text('마이 페이지 준비 중', style: LivithTextStyles.body3Regular),
      ),
    );
  }
}
