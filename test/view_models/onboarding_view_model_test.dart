import 'package:flutter_test/flutter_test.dart';

import 'package:livith/view_models/onboarding_view_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  OnboardingViewModel notifier(ProviderContainer container) =>
      container.read(onboardingViewModelProvider.notifier);
  OnboardingState state(ProviderContainer container) =>
      container.read(onboardingViewModelProvider);

  group('OnboardingViewModel.setNickname은', () {
    test('닉네임을 상태에 반영한다', () {
      final container = makeContainer();

      notifier(container).setNickname('라이빗');

      expect(state(container).nickname, '라이빗');
    });
  });

  group('OnboardingViewModel.toggleGenre는', () {
    test('선택을 추가하고 다시 호출하면 제거한다', () {
      final container = makeContainer();

      notifier(container).toggleGenre(3);
      expect(state(container).genreIdList, [3]);

      notifier(container).toggleGenre(3);
      expect(state(container).genreIdList, isEmpty);
    });
  });

  group('OnboardingViewModel.toggleArtist는', () {
    test('여러 아티스트 선택을 누적한다', () {
      final container = makeContainer();

      notifier(container)
        ..toggleArtist(1)
        ..toggleArtist(2);

      expect(state(container).artistIdList, [1, 2]);
    });
  });
}
