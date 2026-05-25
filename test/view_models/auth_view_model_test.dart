import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/login_status.dart';
import 'package:livith/models/signup_info.dart';
import 'package:livith/models/social_provider.dart';
import 'package:livith/models/temp_user.dart';
import 'package:livith/providers/network_providers.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/services/auth_service.dart';
import 'package:livith/services/social_auth_service.dart';
import 'package:livith/services/token_store.dart';
import 'package:livith/view_models/auth_view_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class _FakeAuthService implements AuthService {
  _FakeAuthService(this.loginResult);

  final LoginStatus loginResult;

  @override
  Future<LoginStatus> loginWithApple(String identityToken) async => loginResult;

  @override
  Future<LoginStatus> loginWithKakao(String accessToken) async => loginResult;

  @override
  Future<SignupResult> signup(SignupInfo info) => throw UnimplementedError();

  @override
  Future<bool> isNicknameAvailable(String nickname) => throw UnimplementedError();

  @override
  Future<void> logout(String refreshToken) async {}

  @override
  Future<void> withdraw(String reason) => throw UnimplementedError();
}

ProviderContainer _container({
  required LoginStatus loginResult,
  required TokenStore tokenStore,
}) {
  final container = ProviderContainer(
    overrides: [
      authServiceProvider.overrideWithValue(_FakeAuthService(loginResult)),
      socialAuthServiceProvider.overrideWithValue(const StubSocialAuthService()),
      tokenStoreProvider.overrideWithValue(tokenStore),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('AuthViewModel.build는', () {
    test('저장된 토큰이 없으면 Unauthenticated를 반환한다', () async {
      final container = _container(
        loginResult: const ExistingUser(accessToken: 'a', refreshToken: 'b'),
        tokenStore: InMemoryTokenStore(),
      );

      final state = await container.read(authViewModelProvider.future);

      expect(state, isA<Unauthenticated>());
    });

    test('저장된 토큰이 있으면 Authenticated를 반환한다', () async {
      final tokenStore = InMemoryTokenStore();
      await tokenStore.save(accessToken: 'a', refreshToken: 'b');
      final container = _container(
        loginResult: const ExistingUser(accessToken: 'a', refreshToken: 'b'),
        tokenStore: tokenStore,
      );

      final state = await container.read(authViewModelProvider.future);

      expect(state, isA<Authenticated>());
    });
  });

  group('AuthViewModel.loginWith는', () {
    test('기존 사용자면 토큰을 저장하고 Authenticated가 된다', () async {
      final tokenStore = InMemoryTokenStore();
      final container = _container(
        loginResult: const ExistingUser(accessToken: 'acc', refreshToken: 'ref'),
        tokenStore: tokenStore,
      );
      await container.read(authViewModelProvider.future);

      await container.read(authViewModelProvider.notifier).loginWith(SocialProvider.kakao);

      expect(container.read(authViewModelProvider).value, isA<Authenticated>());
      expect(tokenStore.accessToken, 'acc');
    });

    test('신규 사용자면 OnboardingRequired가 된다', () async {
      const tempUser = TempUser(provider: SocialProvider.apple, providerId: 'p-1');
      final container = _container(
        loginResult: const NewUser(tempUser),
        tokenStore: InMemoryTokenStore(),
      );
      await container.read(authViewModelProvider.future);

      await container.read(authViewModelProvider.notifier).loginWith(SocialProvider.apple);

      final state = container.read(authViewModelProvider).value;
      expect(state, isA<OnboardingRequired>());
      expect((state as OnboardingRequired).tempUser.providerId, 'p-1');
    });
  });
}
