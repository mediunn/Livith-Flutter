import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/concert_artist.dart';

void main() {
  group('ConcertArtist.fromJson은', () {
    test('name과 선택 필드(imageUrl/introduction)를 파싱한다', () {
      final artist = ConcertArtist.fromJson({
        'name': 'Taylor Swift',
        'imageUrl': 'https://img/a.jpg',
        'introduction': '미국의 싱어송라이터',
      });

      expect(artist.name, 'Taylor Swift');
      expect(artist.imageUrl, 'https://img/a.jpg');
      expect(artist.introduction, '미국의 싱어송라이터');
    });

    test('선택 필드가 없으면 null로 둔다', () {
      final artist = ConcertArtist.fromJson({'name': 'IU'});

      expect(artist.imageUrl, isNull);
      expect(artist.introduction, isNull);
    });
  });
}
