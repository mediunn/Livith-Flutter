import 'package:flutter/foundation.dart';

/// 콘서트 검색 조건.
///
/// `FutureProvider.family`의 키로 쓰이므로 값 동등성을 보장한다.
@immutable
final class SearchQuery {
  const SearchQuery({this.keyword = '', this.genreIdList = const []});

  final String keyword;
  final List<int> genreIdList;

  @override
  bool operator ==(Object other) {
    return other is SearchQuery &&
        other.keyword == keyword &&
        listEquals(other.genreIdList, genreIdList);
  }

  @override
  int get hashCode => Object.hash(keyword, Object.hashAll(genreIdList));

  bool get isEmpty => keyword.trim().isEmpty && genreIdList.isEmpty;
}
