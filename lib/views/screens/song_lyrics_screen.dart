import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/song_lyrics.dart';
import 'package:livith/providers/concert_detail_providers.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';
import 'package:livith/views/widgets/segmented_tab_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 곡 가사 화면.
///
/// iOS `SongLyricsView` 대응. 원문/발음/번역을 전환해 표시한다.
class SongLyricsScreen extends ConsumerStatefulWidget {
  const SongLyricsScreen({super.key, required this.songId});

  final int songId;

  @override
  ConsumerState<SongLyricsScreen> createState() => _SongLyricsScreenState();
}

class _SongLyricsScreenState extends ConsumerState<SongLyricsScreen> {
  int _mode = 0;

  @override
  Widget build(BuildContext context) {
    final lyricsAsync = ref.watch(songLyricsProvider(widget.songId));

    return Scaffold(
      appBar: LivithNavigationBar.back(title: '가사', onBack: () => context.pop()),
      body: lyricsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('가사를 불러오지 못했어요', style: LivithTextStyles.body3Regular),
        ),
        data: (lyrics) => Column(
          children: [
            SegmentedTabBar(
              tabs: const ['원문', '발음', '번역'],
              selectedIndex: _mode,
              onTabSelected: (index) => setState(() => _mode = index),
            ),
            Expanded(child: _lyricList(lyrics)),
          ],
        ),
      ),
    );
  }

  Widget _lyricList(SongLyrics lyrics) {
    final lines = switch (_mode) {
      1 => lyrics.pronunciationList,
      2 => lyrics.translationList,
      _ => lyrics.lyricList,
    };
    if (lines.isEmpty) {
      return Center(
        child: Text('해당 가사가 없어요', style: LivithTextStyles.body3Regular),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: lines.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          lines[index],
          style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
        ),
      ),
    );
  }
}
