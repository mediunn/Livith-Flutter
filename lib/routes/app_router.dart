import 'package:flutter/material.dart';

import 'package:livith/routes/routes.dart';
import 'package:livith/view_models/auth_view_model.dart';
import 'package:livith/views/screens/design_system_preview_screen.dart';
import 'package:livith/views/screens/home_screen.dart';
import 'package:livith/views/screens/login_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 인증 상태에 따라 진입점을 분기하는 앱 라우터.
final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.onDispose(refresh.dispose);
  ref.listen(authViewModelProvider, (_, _) => refresh.value++);

  return GoRouter(
    initialLocation: Routes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authViewModelProvider).value;
      if (authState == null) return null;

      final location = state.matchedLocation;
      final inOnboarding = location.startsWith(Routes.onboarding);

      return switch (authState) {
        Unauthenticated() => location == Routes.login ? null : Routes.login,
        OnboardingRequired() => inOnboarding ? null : Routes.onboarding,
        Authenticated() =>
          (location == Routes.login || inOnboarding) ? Routes.home : null,
      };
    },
    routes: [
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const _OnboardingPlaceholder(),
      ),
      GoRoute(
        path: Routes.designSystemPreview,
        builder: (_, _) => const DesignSystemPreviewScreen(),
      ),
    ],
  );
});

/// 온보딩 흐름 placeholder. 온보딩 화면 마일스톤에서 실제 흐름으로 교체한다.
class _OnboardingPlaceholder extends StatelessWidget {
  const _OnboardingPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('온보딩 준비 중')));
  }
}
