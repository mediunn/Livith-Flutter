import 'package:livith/models/login_status.dart';
import 'package:livith/models/social_provider.dart';
import 'package:livith/models/temp_user.dart';
import 'package:livith/providers/network_providers.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/services/auth_service.dart';
import 'package:livith/services/social_auth_service.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱 전역 인증 상태.
sealed class AuthState {
  const AuthState();
}

/// 로그인 완료 상태.
final class Authenticated extends AuthState {
  const Authenticated();
}

/// 미로그인 상태.
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// 신규 사용자라 온보딩(가입)이 필요한 상태.
final class OnboardingRequired extends AuthState {
  const OnboardingRequired(this.tempUser);

  final TempUser tempUser;
}

/// 인증 상태를 관리하는 ViewModel.
///
/// 앱 시작 시 토큰을 로드해 로그인 여부를 판정하고, 소셜 로그인/가입/로그아웃을 처리한다.
final class AuthViewModel extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    final tokenStore = ref.read(tokenStoreProvider);
    await tokenStore.load();
    return tokenStore.accessToken != null
        ? const Authenticated()
        : const Unauthenticated();
  }

  /// 소셜 로그인을 수행하고 결과에 따라 상태를 갱신한다.
  Future<void> loginWith(SocialProvider provider) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await ref.read(socialAuthServiceProvider).obtainToken(provider);
      final auth = ref.read(authServiceProvider);
      final status = provider == SocialProvider.apple
          ? await auth.loginWithApple(token)
          : await auth.loginWithKakao(token);
      return _resolve(status);
    });
  }

  /// 가입 완료 후 토큰을 저장하고 인증 상태로 전환한다.
  Future<void> completeOnboarding(SignupResult result) async {
    await ref.read(tokenStoreProvider).save(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
    state = const AsyncData(Authenticated());
  }

  /// 로그아웃하고 미인증 상태로 전환한다.
  Future<void> logout() async {
    final tokenStore = ref.read(tokenStoreProvider);
    final refreshToken = tokenStore.refreshToken;
    if (refreshToken != null) {
      try {
        await ref.read(authServiceProvider).logout(refreshToken);
      } on Object {
        // 서버 로그아웃 실패와 무관하게 로컬 토큰은 비운다.
      }
    }
    await tokenStore.clear();
    state = const AsyncData(Unauthenticated());
  }

  Future<AuthState> _resolve(LoginStatus status) async {
    switch (status) {
      case ExistingUser(:final accessToken, :final refreshToken):
        await ref.read(tokenStoreProvider).save(
              accessToken: accessToken,
              refreshToken: refreshToken,
            );
        return const Authenticated();
      case NewUser(:final tempUser):
        return OnboardingRequired(tempUser);
    }
  }
}

final authViewModelProvider = AsyncNotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);
