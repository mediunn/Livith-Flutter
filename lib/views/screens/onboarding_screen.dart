import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/nickname.dart';
import 'package:livith/providers/preference_providers.dart';
import 'package:livith/view_models/auth_view_model.dart';
import 'package:livith/view_models/onboarding_view_model.dart';
import 'package:livith/views/widgets/livith_button.dart';
import 'package:livith/views/widgets/livith_chip.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 온보딩(가입) 흐름: 약관 → 닉네임 → 선호 장르 → 선호 아티스트 → 가입.
///
/// iOS 온보딩 흐름 대응. 4단계를 [PageView]로 진행한다.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _step = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authViewModelProvider).value;
      if (authState is OnboardingRequired) {
        ref.read(onboardingViewModelProvider.notifier).initialize(authState.tempUser);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step >= 3) return;
    setState(() => _step++);
    _pageController.animateToPage(
      _step,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _submit() async {
    await ref.read(onboardingViewModelProvider.notifier).submit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _TermsStep(onNext: _next),
            _NicknameStep(onNext: _next),
            _GenreStep(onNext: _next),
            _ArtistStep(onSubmit: _submit),
          ],
        ),
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.content, required this.footer});

  final String title;
  final Widget content;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(title, style: LivithTextStyles.headSemibold.copyWith(color: LivithColors.white100)),
          const SizedBox(height: 24),
          Expanded(child: content),
          footer,
        ],
      ),
    );
  }
}

class _TermsStep extends ConsumerWidget {
  const _TermsStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingViewModelProvider);
    final notifier = ref.read(onboardingViewModelProvider.notifier);

    return _StepScaffold(
      title: '약관에 동의해주세요',
      content: Column(
        children: [
          CheckboxListTile(
            value: state.agreedTerms,
            onChanged: (value) => notifier.setAgreedTerms(
              agreed: value ?? false,
              marketing: state.marketingAgreed,
            ),
            title: const Text('(필수) 서비스 이용약관 동의'),
          ),
          CheckboxListTile(
            value: state.marketingAgreed,
            onChanged: (value) => notifier.setAgreedTerms(
              agreed: state.agreedTerms,
              marketing: value ?? false,
            ),
            title: const Text('(선택) 마케팅 정보 수신 동의'),
          ),
        ],
      ),
      footer: LivithButton('다음', onPressed: state.agreedTerms ? onNext : null),
    );
  }
}

class _NicknameStep extends ConsumerWidget {
  const _NicknameStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nickname = ref.watch(onboardingViewModelProvider).nickname;
    final isValid = Nickname.isValid(nickname);

    return _StepScaffold(
      title: '닉네임을 입력해주세요',
      content: TextField(
        onChanged: ref.read(onboardingViewModelProvider.notifier).setNickname,
        maxLength: 10,
        style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
        decoration: const InputDecoration(
          hintText: '영문/숫자/한글 1~10자',
          counterText: '',
        ),
      ),
      footer: LivithButton('다음', onPressed: isValid ? onNext : null),
    );
  }
}

class _GenreStep extends ConsumerWidget {
  const _GenreStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final genresAsync = ref.watch(genresProvider);
    final selected = ref.watch(onboardingViewModelProvider).genreIdList;
    final notifier = ref.read(onboardingViewModelProvider.notifier);

    return _StepScaffold(
      title: '선호하는 장르를 골라주세요',
      content: genresAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('장르를 불러오지 못했어요', style: LivithTextStyles.body3Regular),
        ),
        data: (genres) => SingleChildScrollView(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final genre in genres)
                GestureDetector(
                  onTap: () => notifier.toggleGenre(genre.id),
                  child: LivithChip(
                    genre.name,
                    style: selected.contains(genre.id)
                        ? LivithChipStyle.selected
                        : LivithChipStyle.status,
                  ),
                ),
            ],
          ),
        ),
      ),
      footer: LivithButton('다음', onPressed: selected.isNotEmpty ? onNext : null),
    );
  }
}

class _ArtistStep extends ConsumerStatefulWidget {
  const _ArtistStep({required this.onSubmit});

  final Future<void> Function() onSubmit;

  @override
  ConsumerState<_ArtistStep> createState() => _ArtistStepState();
}

class _ArtistStepState extends ConsumerState<_ArtistStep> {
  String _keyword = '';

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(artistSearchProvider(_keyword));
    final selected = ref.watch(onboardingViewModelProvider).artistIdList;
    final notifier = ref.read(onboardingViewModelProvider.notifier);
    final isSubmitting = ref.watch(authViewModelProvider).isLoading;

    return _StepScaffold(
      title: '좋아하는 아티스트를 골라주세요',
      content: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() => _keyword = value),
            style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
            decoration: const InputDecoration(hintText: '아티스트 검색'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('검색에 실패했어요', style: LivithTextStyles.body3Regular),
              ),
              data: (artists) => ListView(
                children: [
                  for (final artist in artists)
                    CheckboxListTile(
                      value: selected.contains(artist.id),
                      onChanged: (_) => notifier.toggleArtist(artist.id),
                      title: Text(artist.name),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      footer: LivithButton(
        '가입 완료',
        isLoading: isSubmitting,
        onPressed: selected.isNotEmpty ? () => widget.onSubmit() : null,
      ),
    );
  }
}
