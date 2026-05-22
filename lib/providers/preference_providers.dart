import 'package:livith/models/artist.dart';
import 'package:livith/models/concert.dart';
import 'package:livith/models/genre.dart';
import 'package:livith/models/search_query.dart';
import 'package:livith/providers/service_providers.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 전체 장르 목록.
final genresProvider = FutureProvider.autoDispose<List<Genre>>(
  (ref) => ref.read(preferenceServiceProvider).fetchGenres(),
);

/// 키워드 기반 아티스트 검색 결과. 빈 키워드는 빈 목록을 반환한다.
final artistSearchProvider =
    FutureProvider.autoDispose.family<List<Artist>, String>((ref, keyword) {
  if (keyword.trim().isEmpty) return Future.value(const []);
  return ref.read(preferenceServiceProvider).searchArtists(keyword: keyword);
});

/// 콘서트 검색 결과. 빈 조건은 빈 목록을 반환한다.
final concertSearchProvider =
    FutureProvider.autoDispose.family<List<Concert>, SearchQuery>((ref, query) {
  if (query.isEmpty) return Future.value(const []);
  return ref.read(searchServiceProvider).searchConcerts(query);
});
