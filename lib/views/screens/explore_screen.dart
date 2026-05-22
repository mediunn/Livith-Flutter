import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/concert.dart';
import 'package:livith/models/search_query.dart';
import 'package:livith/providers/preference_providers.dart';
import 'package:livith/views/widgets/livith_card.dart';
import 'package:livith/views/widgets/livith_chip.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 탐색 화면.
///
/// iOS `ExploreView`/`SearchView` 대응. 키워드/장르로 콘서트를 검색한다.
class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  String _keyword = '';
  final Set<int> _genreIdSet = {};

  SearchQuery get _query =>
      SearchQuery(keyword: _keyword, genreIdList: _genreIdSet.toList());

  @override
  Widget build(BuildContext context) {
    final genresAsync = ref.watch(genresProvider);
    final resultsAsync = ref.watch(concertSearchProvider(_query));

    return Scaffold(
      appBar: LivithNavigationBar.logo(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: TextField(
              onChanged: (value) => setState(() => _keyword = value),
              style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
              decoration: const InputDecoration(hintText: '공연·아티스트 검색'),
            ),
          ),
          genresAsync.maybeWhen(
            data: (genres) => SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  for (final genre in genres)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () => setState(() {
                          _genreIdSet.contains(genre.id)
                              ? _genreIdSet.remove(genre.id)
                              : _genreIdSet.add(genre.id);
                        }),
                        child: LivithChip(
                          genre.name,
                          style: _genreIdSet.contains(genre.id)
                              ? LivithChipStyle.selected
                              : LivithChipStyle.status,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            orElse: () => const SizedBox(height: 42),
          ),
          const SizedBox(height: 12),
          Expanded(child: _results(resultsAsync)),
        ],
      ),
    );
  }

  Widget _results(AsyncValue<List<Concert>> resultsAsync) {
    return resultsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text('검색에 실패했어요', style: LivithTextStyles.body3Regular),
      ),
      data: (concerts) {
        if (concerts.isEmpty) {
          return Center(
            child: Text('검색어나 장르를 선택해보세요', style: LivithTextStyles.body3Regular),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            children: [
              for (final concert in concerts)
                LivithCard(
                  imageUrl: concert.posterUrl,
                  title: concert.title,
                  subtitle: concert.venue,
                  titleLineLimit: 2,
                  onTap: () => context.push('/concert/${concert.id}'),
                ),
            ],
          ),
        );
      },
    );
  }
}
