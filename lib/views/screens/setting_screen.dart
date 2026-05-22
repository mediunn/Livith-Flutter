import 'package:flutter/material.dart';

import 'package:livith/providers/service_providers.dart';
import 'package:livith/view_models/auth_view_model.dart';
import 'package:livith/views/widgets/livith_button.dart';
import 'package:livith/views/widgets/livith_modal.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 설정 화면.
///
/// iOS `SettingView` 대응. 로그아웃/회원탈퇴를 제공한다.
class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: LivithNavigationBar.back(title: '설정', onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            LivithButton(
              '로그아웃',
              variant: LivithButtonVariant.secondary,
              onPressed: () => ref.read(authViewModelProvider.notifier).logout(),
            ),
            const SizedBox(height: 12),
            LivithButton(
              '회원 탈퇴',
              variant: LivithButtonVariant.pink,
              onPressed: () => _confirmWithdraw(context, ref),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _confirmWithdraw(BuildContext context, WidgetRef ref) {
    showLivithModal(
      context,
      title: '정말 탈퇴하시겠어요?',
      message: '탈퇴 시 모든 정보가 삭제됩니다',
      type: LivithModalType.error,
      confirmTitle: '탈퇴하기',
      onConfirm: () async {
        try {
          await ref.read(authServiceProvider).withdraw('회원 탈퇴');
        } on Object {
          // 서버 실패와 무관하게 로컬 로그아웃 처리한다.
        }
        await ref.read(authViewModelProvider.notifier).logout();
      },
    );
  }
}
