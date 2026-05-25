import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/nickname.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/providers/user_providers.dart';
import 'package:livith/views/widgets/livith_button.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';
import 'package:livith/views/widgets/livith_toast.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 닉네임 수정 화면.
///
/// iOS `NicknameUpdateView` 대응.
class NicknameEditScreen extends ConsumerStatefulWidget {
  const NicknameEditScreen({super.key});

  @override
  ConsumerState<NicknameEditScreen> createState() => _NicknameEditScreenState();
}

class _NicknameEditScreenState extends ConsumerState<NicknameEditScreen> {
  String _nickname = '';
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final isValid = Nickname.isValid(_nickname);

    return Scaffold(
      appBar: LivithNavigationBar.back(title: '닉네임 수정', onBack: () => context.pop()),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => setState(() => _nickname = value),
              maxLength: 10,
              style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
              decoration: const InputDecoration(
                hintText: '영문/숫자/한글 1~10자',
                counterText: '',
              ),
            ),
            const Spacer(),
            LivithButton(
              '저장',
              isLoading: _isSaving,
              onPressed: isValid ? _save : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      await ref.read(userServiceProvider).updateNickname(_nickname);
      ref.invalidate(userProfileProvider);
      if (!mounted) return;
      context.pop();
    } on Object {
      if (!mounted) return;
      showLivithToast(context, type: LivithToastType.failure, message: '닉네임 변경에 실패했어요');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
