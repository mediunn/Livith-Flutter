import 'package:livith/models/concert.dart';
import 'package:livith/models/setlist.dart';
import 'package:livith/models/song_lyrics.dart';
import 'package:livith/providers/service_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 콘서트 상세 화면 데이터(콘서트 + 셋리스트).
final class ConcertDetail {
  const ConcertDetail({required this.concert, required this.setlistList});

  final Concert concert;
  final List<Setlist> setlistList;
}

/// 콘서트 상세 데이터. 셋리스트 조회 실패는 빈 목록으로 처리한다.
final concertDetailProvider =
    FutureProvider.autoDispose.family<ConcertDetail, int>((ref, concertId) async {
  final concert = await ref.read(concertServiceProvider).fetchConcert(concertId);
  List<Setlist> setlistList;
  try {
    setlistList = await ref.read(setlistServiceProvider).fetchSetlists(concertId);
  } on Object {
    setlistList = const [];
  }
  return ConcertDetail(concert: concert, setlistList: setlistList);
});

/// 곡 가사.
final songLyricsProvider =
    FutureProvider.autoDispose.family<SongLyrics, int>((ref, songId) {
  return ref.read(songServiceProvider).fetchLyrics(songId);
});
