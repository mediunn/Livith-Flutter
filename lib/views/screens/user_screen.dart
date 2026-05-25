import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/providers/user_providers.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 마이 화면.
///
/// iOS `UserView` 대응. 프로필과 설정 진입을 제공한다.
class UserScreen extends ConsumerWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: LivithNavigationBar.logo(),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          profileAsync.when(
            loading: () => const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => Text(
              '프로필을 불러오지 못했어요',
              style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.black50),
            ),
            data: (user) => Text(
              user.nickname,
              style: LivithTextStyles.title.copyWith(color: LivithColors.white100),
            ),
          ),
          const SizedBox(height: 32),
          _MenuItem(label: '닉네임 수정', onTap: () => context.push('/nickname-edit')),
          _MenuItem(label: '설정', onTap: () => context.push('/setting')),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
      ),
      trailing: const Icon(Icons.chevron_right, color: LivithColors.black50),
      onTap: onTap,
    );
  }
}
