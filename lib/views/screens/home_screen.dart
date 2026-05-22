import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/concert.dart';
import 'package:livith/view_models/home_view_model.dart';
import 'package:livith/views/widgets/livith_card.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 홈 화면.
///
/// iOS `HomeView` 대응. 관심 공연 섹션과 추천 공연 그리드를 표시한다.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: LivithNavigationBar.logo(),
      body: homeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('공연 정보를 불러오지 못했어요', style: LivithTextStyles.body3Regular),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(homeViewModelProvider),
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              if (state.interestConcertList.isNotEmpty) ...[
                const _SectionTitle('관심 공연'),
                _ConcertRow(concertList: state.interestConcertList),
                const SizedBox(height: 24),
              ],
              const _SectionTitle('추천 공연'),
              _ConcertGrid(concertList: state.recommendedConcertList),
            ],
          ),
        ),
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Text(
        title,
        style: LivithTextStyles.body1Semibold.copyWith(color: LivithColors.white100),
      ),
    );
  }
}

class _ConcertRow extends StatelessWidget {
  const _ConcertRow({required this.concertList});

  final List<Concert> concertList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: concertList.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, index) => _card(concertList[index]),
      ),
    );
  }
}

class _ConcertGrid extends StatelessWidget {
  const _ConcertGrid({required this.concertList});

  final List<Concert> concertList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 12,
        runSpacing: 16,
        children: [for (final concert in concertList) _card(concert)],
      ),
    );
  }
}

Widget _card(Concert concert) {
  return LivithCard(
    imageUrl: concert.posterUrl,
    title: concert.title,
    subtitle: concert.venue,
    titleLineLimit: 2,
  );
}
