import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/social_provider.dart';
import 'package:livith/providers/integration_providers.dart';
import 'package:livith/view_models/auth_view_model.dart';
import 'package:livith/views/widgets/livith_button.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 로그인 화면.
///
/// iOS `LoginView` 대응. 소셜 로그인 버튼을 노출하고 [AuthViewModel]로 로그인한다.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const Spacer(),
              Image.asset('assets/images/livith_logo.png', height: 36),
              const SizedBox(height: 8),
              Text(
                '내한 공연의 모든 것',
                style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.black50),
              ),
              const Spacer(),
              LivithButton(
                '카카오로 시작하기',
                isLoading: isLoading,
                onPressed: () => _login(ref, SocialProvider.kakao),
              ),
              const SizedBox(height: 12),
              LivithButton(
                'Apple로 시작하기',
                variant: LivithButtonVariant.secondary,
                isLoading: isLoading,
                onPressed: () => _login(ref, SocialProvider.apple),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  void _login(WidgetRef ref, SocialProvider provider) {
    ref.read(analyticsServiceProvider).track('click_login', {'provider': provider.value});
    ref.read(authViewModelProvider.notifier).loginWith(provider);
  }
}
