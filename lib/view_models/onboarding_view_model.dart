import 'package:livith/models/signup_info.dart';
import 'package:livith/models/temp_user.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/view_models/auth_view_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 온보딩(가입) 진행 중 누적되는 상태.
final class OnboardingState {
  const OnboardingState({
    this.tempUser,
    this.agreedTerms = false,
    this.nickname = '',
    this.marketingAgreed = false,
    this.genreIdList = const [],
    this.artistIdList = const [],
  });

  final TempUser? tempUser;
  final bool agreedTerms;
  final String nickname;
  final bool marketingAgreed;
  final List<int> genreIdList;
  final List<int> artistIdList;

  OnboardingState copyWith({
    TempUser? tempUser,
    bool? agreedTerms,
    String? nickname,
    bool? marketingAgreed,
    List<int>? genreIdList,
    List<int>? artistIdList,
  }) {
    return OnboardingState(
      tempUser: tempUser ?? this.tempUser,
      agreedTerms: agreedTerms ?? this.agreedTerms,
      nickname: nickname ?? this.nickname,
      marketingAgreed: marketingAgreed ?? this.marketingAgreed,
      genreIdList: genreIdList ?? this.genreIdList,
      artistIdList: artistIdList ?? this.artistIdList,
    );
  }
}

/// 온보딩 흐름의 입력을 누적하고 최종 가입을 수행하는 ViewModel.
final class OnboardingViewModel extends Notifier<OnboardingState> {
  @override
  OnboardingState build() => const OnboardingState();

  /// 로그인에서 받은 임시 사용자로 온보딩을 초기화한다.
  void initialize(TempUser tempUser) {
    state = OnboardingState(tempUser: tempUser);
  }

  void setAgreedTerms({required bool agreed, required bool marketing}) {
    state = state.copyWith(agreedTerms: agreed, marketingAgreed: marketing);
  }

  void setNickname(String nickname) {
    state = state.copyWith(nickname: nickname);
  }

  /// 장르 선택을 토글한다.
  void toggleGenre(int id) {
    state = state.copyWith(genreIdList: _toggled(state.genreIdList, id));
  }

  /// 아티스트 선택을 토글한다.
  void toggleArtist(int id) {
    state = state.copyWith(artistIdList: _toggled(state.artistIdList, id));
  }

  /// 누적된 정보로 회원가입을 수행하고 인증 상태로 전환한다.
  Future<void> submit() async {
    final tempUser = state.tempUser;
    if (tempUser == null) return;

    final info = SignupInfo(
      provider: tempUser.provider,
      providerId: tempUser.providerId,
      email: tempUser.email,
      nickname: state.nickname,
      isMarketingAgreed: state.marketingAgreed,
      preferredGenreIdList: state.genreIdList,
      preferredArtistIdList: state.artistIdList,
    );
    final result = await ref.read(authServiceProvider).signup(info);
    await ref.read(authViewModelProvider.notifier).completeOnboarding(result);
  }

  List<int> _toggled(List<int> list, int id) {
    return list.contains(id)
        ? list.where((value) => value != id).toList()
        : [...list, id];
  }
}

final onboardingViewModelProvider =
    NotifierProvider<OnboardingViewModel, OnboardingState>(OnboardingViewModel.new);
