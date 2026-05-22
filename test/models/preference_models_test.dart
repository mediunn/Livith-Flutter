import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/artist.dart';
import 'package:livith/models/genre.dart';

void main() {
  group('Genre.fromJson은', () {
    test('id와 name을 파싱한다', () {
      final genre = Genre.fromJson({'id': 1, 'name': 'POP'});

      expect(genre.id, 1);
      expect(genre.name, 'POP');
    });
  });

  group('Artist.fromJson은', () {
    test('id/name과 선택 필드(imageUrl/genreId)를 파싱한다', () {
      final artist = Artist.fromJson({
        'id': 10,
        'name': 'Taylor Swift',
        'imageUrl': 'https://img/x.jpg',
        'genreId': 4,
      });

      expect(artist.id, 10);
      expect(artist.name, 'Taylor Swift');
      expect(artist.imageUrl, 'https://img/x.jpg');
      expect(artist.genreId, 4);
    });

    test('선택 필드가 없으면 null로 둔다', () {
      final artist = Artist.fromJson({'id': 11, 'name': 'IU'});

      expect(artist.imageUrl, isNull);
      expect(artist.genreId, isNull);
    });
  });
}
