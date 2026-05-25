import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/views/widgets/livith_button.dart';
import 'package:livith/views/widgets/livith_card.dart';
import 'package:livith/views/widgets/livith_chip.dart';
import 'package:livith/views/widgets/livith_modal.dart';
import 'package:livith/views/widgets/livith_toast.dart';
import 'package:livith/views/widgets/segmented_tab_bar.dart';

/// 디자인 토큰(색상/타이포) 적용을 시각적으로 검증하기 위한 미리보기 화면.
///
/// 마일스톤 1 검증용이며, 화면 이관이 진행되면 제거한다.
class DesignSystemPreviewScreen extends StatelessWidget {
  const DesignSystemPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design System')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _SectionTitle('Colors'),
          _ColorSwatches(),
          SizedBox(height: 32),
          _SectionTitle('Typography'),
          _TypographySamples(),
          SizedBox(height: 32),
          _SectionTitle('Components'),
          _ComponentSamples(),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: LivithTextStyles.headSemibold),
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  static const _entries = <(String, Color)>[
    ('black100', LivithColors.black100),
    ('black90', LivithColors.black90),
    ('black80', LivithColors.black80),
    ('black50', LivithColors.black50),
    ('black30', LivithColors.black30),
    ('black5', LivithColors.black5),
    ('white100', LivithColors.white100),
    ('yellow30', LivithColors.yellow30),
    ('yellow60', LivithColors.yellow60),
    ('caution100', LivithColors.caution100),
    ('original', LivithColors.original),
    ('translation', LivithColors.translation),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final (name, color) in _entries)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: LivithColors.black80),
                ),
              ),
              const SizedBox(height: 6),
              Text(name, style: LivithTextStyles.caption1Regular),
            ],
          ),
      ],
    );
  }
}

class _ComponentSamples extends StatefulWidget {
  const _ComponentSamples();

  @override
  State<_ComponentSamples> createState() => _ComponentSamplesState();
}

class _ComponentSamplesState extends State<_ComponentSamples> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Buttons', style: LivithTextStyles.body2Semibold),
        const SizedBox(height: 12),
        LivithButton('Primary', onPressed: () {}),
        const SizedBox(height: 8),
        LivithButton('Pink', variant: LivithButtonVariant.pink, onPressed: () {}),
        const SizedBox(height: 8),
        LivithButton('Secondary', variant: LivithButtonVariant.secondary, onPressed: () {}),
        const SizedBox(height: 8),
        const LivithButton('Disabled'),
        const SizedBox(height: 24),
        Text('Chips', style: LivithTextStyles.body2Semibold),
        const SizedBox(height: 12),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            LivithChip('status'),
            LivithChip('selected', style: LivithChipStyle.selected),
            LivithChip('tag', style: LivithChipStyle.tag),
            LivithChip('dark', style: LivithChipStyle.dark),
            LivithChip('outline', style: LivithChipStyle.outline),
          ],
        ),
        const SizedBox(height: 24),
        Text('SegmentedTabBar', style: LivithTextStyles.body2Semibold),
        const SizedBox(height: 12),
        SegmentedTabBar(
          tabs: const ['일정', '셋리스트', '커뮤니티'],
          selectedIndex: _selectedTab,
          badgeCountList: const [null, null, 12],
          onTabSelected: (index) => setState(() => _selectedTab = index),
        ),
        const SizedBox(height: 24),
        Text('Card', style: LivithTextStyles.body2Semibold),
        const SizedBox(height: 12),
        const LivithCard(
          imageUrl: null,
          title: '테일러 스위프트 내한',
          subtitle: '고척스카이돔',
          isSelected: true,
        ),
        const SizedBox(height: 24),
        Text('Modal / Toast', style: LivithTextStyles.body2Semibold),
        const SizedBox(height: 12),
        LivithButton(
          '모달 열기',
          isFullWidth: false,
          onPressed: () => showLivithModal(
            context,
            title: '환영합니다',
            message: '라이빗에 오신 것을 환영해요',
            type: LivithModalType.welcome,
          ),
        ),
        const SizedBox(height: 8),
        LivithButton(
          '토스트 띄우기',
          variant: LivithButtonVariant.secondary,
          isFullWidth: false,
          onPressed: () => showLivithToast(
            context,
            type: LivithToastType.success,
            message: '관심 공연에 추가했어요',
          ),
        ),
      ],
    );
  }
}

class _TypographySamples extends StatelessWidget {
  const _TypographySamples();

  static const _entries = <(String, TextStyle)>[
    ('title', LivithTextStyles.title),
    ('headSemibold', LivithTextStyles.headSemibold),
    ('headMedium', LivithTextStyles.headMedium),
    ('headRegular', LivithTextStyles.headRegular),
    ('body1Semibold', LivithTextStyles.body1Semibold),
    ('body2Semibold', LivithTextStyles.body2Semibold),
    ('body2Regular', LivithTextStyles.body2Regular),
    ('body3Medium', LivithTextStyles.body3Medium),
    ('body4Regular', LivithTextStyles.body4Regular),
    ('caption1Bold', LivithTextStyles.caption1Bold),
    ('caption2Regular', LivithTextStyles.caption2Regular),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in _entries)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('$name · 라이빗 Livith', style: style),
          ),
      ],
    );
  }
}
