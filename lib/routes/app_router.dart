import 'package:flutter/material.dart';

import 'package:livith/routes/routes.dart';
import 'package:livith/view_models/auth_view_model.dart';
import 'package:livith/views/screens/design_system_preview_screen.dart';
import 'package:livith/views/screens/concert_detail_screen.dart';
import 'package:livith/views/screens/login_screen.dart';
import 'package:livith/views/screens/main_tab_screen.dart';
import 'package:livith/views/screens/onboarding_screen.dart';
import 'package:livith/views/screens/song_lyrics_screen.dart';

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
      GoRoute(path: Routes.home, builder: (_, _) => const MainTabScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/concert/:id',
        builder: (_, state) => ConcertDetailScreen(
          concertId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/song/:id',
        builder: (_, state) => SongLyricsScreen(
          songId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.designSystemPreview,
        builder: (_, _) => const DesignSystemPreviewScreen(),
      ),
    ],
  );
});
