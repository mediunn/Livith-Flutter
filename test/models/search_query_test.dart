import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/search_query.dart';

void main() {
  group('SearchQuery 동등성은', () {
    test('키워드와 장르 목록이 같으면 동등하고 hashCode가 같다', () {
      const a = SearchQuery(keyword: 'taylor', genreIdList: [1, 2]);
      const b = SearchQuery(keyword: 'taylor', genreIdList: [1, 2]);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('장르 목록이 다르면 동등하지 않다', () {
      const a = SearchQuery(keyword: 'x', genreIdList: [1]);
      const b = SearchQuery(keyword: 'x', genreIdList: [2]);

      expect(a == b, isFalse);
    });
  });

  group('SearchQuery.isEmpty는', () {
    test('키워드와 장르가 모두 비면 true를 반환한다', () {
      expect(const SearchQuery().isEmpty, isTrue);
      expect(const SearchQuery(keyword: 'a').isEmpty, isFalse);
      expect(const SearchQuery(genreIdList: [1]).isEmpty, isFalse);
    });
  });
}
