import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/models/concert.dart';
import 'package:livith/models/setlist.dart';
import 'package:livith/providers/concert_detail_providers.dart';
import 'package:livith/providers/service_providers.dart';
import 'package:livith/views/widgets/async_image_view.dart';
import 'package:livith/views/widgets/livith_navigation_bar.dart';
import 'package:livith/views/widgets/segmented_tab_bar.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 콘서트 상세 화면.
///
/// iOS `ConcertView` 대응. 정보/셋리스트 탭을 표시한다(아티스트/커뮤니티 탭은 후속).
class ConcertDetailScreen extends ConsumerStatefulWidget {
  const ConcertDetailScreen({super.key, required this.concertId});

  final int concertId;

  @override
  ConsumerState<ConcertDetailScreen> createState() => _ConcertDetailScreenState();
}

class _ConcertDetailScreenState extends ConsumerState<ConcertDetailScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(concertDetailProvider(widget.concertId));

    return Scaffold(
      appBar: LivithNavigationBar.backOnly(onBack: () => context.pop()),
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text('공연 정보를 불러오지 못했어요', style: LivithTextStyles.body3Regular),
        ),
        data: (detail) => Column(
          children: [
            SegmentedTabBar(
              tabs: const ['정보', '셋리스트', '커뮤니티'],
              selectedIndex: _tab,
              onTabSelected: (index) => setState(() => _tab = index),
            ),
            Expanded(
              child: switch (_tab) {
                0 => _InfoTab(concert: detail.concert),
                1 => _SetlistTab(setlistList: detail.setlistList),
                _ => _CommunityTab(concertId: widget.concertId),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTab extends StatelessWidget {
  const _InfoTab({required this.concert});

  final Concert concert;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 240,
            child: AsyncImageView(url: concert.posterUrl),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          concert.title,
          style: LivithTextStyles.headSemibold.copyWith(color: LivithColors.white100),
        ),
        const SizedBox(height: 8),
        Text(
          concert.artist,
          style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.black50),
        ),
        if (concert.venue != null) ...[
          const SizedBox(height: 16),
          _InfoRow(label: '장소', value: concert.venue!),
        ],
        if (concert.startDate != null)
          _InfoRow(label: '일정', value: concert.startDate!),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(label, style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.black50)),
          ),
          Expanded(
            child: Text(value, style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.white100)),
          ),
        ],
      ),
    );
  }
}

class _CommunityTab extends ConsumerStatefulWidget {
  const _CommunityTab({required this.concertId});

  final int concertId;

  @override
  ConsumerState<_CommunityTab> createState() => _CommunityTabState();
}

class _CommunityTabState extends ConsumerState<_CommunityTab> {
  final TextEditingController _controller = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _isSending = true);
    try {
      await ref.read(commentServiceProvider).createComment(widget.concertId, content);
      _controller.clear();
      ref.invalidate(concertCommentsProvider(widget.concertId));
    } on Object {
      // 전송 실패는 무시하고 입력은 유지한다.
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(concertCommentsProvider(widget.concertId));

    return Column(
      children: [
        Expanded(
          child: commentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('댓글을 불러오지 못했어요', style: LivithTextStyles.body3Regular),
            ),
            data: (comments) {
              if (comments.isEmpty) {
                return Center(
                  child: Text('첫 댓글을 남겨보세요', style: LivithTextStyles.body3Regular),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: comments.length,
                separatorBuilder: (_, _) => const Divider(color: LivithColors.black80),
                itemBuilder: (_, index) {
                  final comment = comments[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.writer,
                        style: LivithTextStyles.caption1Semibold.copyWith(color: LivithColors.black50),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        comment.content,
                        style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.white100),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: LivithTextStyles.body3Regular.copyWith(color: LivithColors.white100),
                  decoration: const InputDecoration(hintText: '댓글을 입력하세요'),
                ),
              ),
              IconButton(
                onPressed: _isSending ? null : _send,
                icon: const Icon(Icons.send, color: LivithColors.yellow30),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SetlistTab extends StatelessWidget {
  const _SetlistTab({required this.setlistList});

  final List<Setlist> setlistList;

  @override
  Widget build(BuildContext context) {
    if (setlistList.isEmpty) {
      return Center(
        child: Text('등록된 셋리스트가 없어요', style: LivithTextStyles.body3Regular),
      );
    }
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        for (final setlist in setlistList) ...[
          Text(
            setlist.title,
            style: LivithTextStyles.body1Semibold.copyWith(color: LivithColors.white100),
          ),
          const SizedBox(height: 8),
          for (final song in setlist.songList)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                song.title,
                style: LivithTextStyles.body2Regular.copyWith(color: LivithColors.white100),
              ),
              trailing: const Icon(Icons.chevron_right, color: LivithColors.black50),
              onTap: () => context.push('/song/${song.id}'),
            ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
