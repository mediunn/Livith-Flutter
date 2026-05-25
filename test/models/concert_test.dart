import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/concert.dart';

void main() {
  group('ConcertStatus.fromValue는', () {
    test('서버 문자열을 enum으로 매핑하고 미지의 값은 unknown으로 둔다', () {
      expect(ConcertStatus.fromValue('ONGOING'), ConcertStatus.ongoing);
      expect(ConcertStatus.fromValue('UPCOMING'), ConcertStatus.upcoming);
      expect(ConcertStatus.fromValue(null), ConcertStatus.unknown);
      expect(ConcertStatus.fromValue('???'), ConcertStatus.unknown);
    });
  });

  group('Concert.fromJson은', () {
    test('필수/선택 필드를 파싱하고 status를 enum으로 변환한다', () {
      final concert = Concert.fromJson({
        'id': 5,
        'title': 'Eras Tour',
        'artist': 'Taylor Swift',
        'status': 'UPCOMING',
        'poster': 'https://img/p.jpg',
        'startDate': '2026-06-01',
        'endDate': '2026-06-02',
        'venue': '고척돔',
        'daysLeft': 10,
      });

      expect(concert.id, 5);
      expect(concert.title, 'Eras Tour');
      expect(concert.artist, 'Taylor Swift');
      expect(concert.status, ConcertStatus.upcoming);
      expect(concert.posterUrl, 'https://img/p.jpg');
      expect(concert.venue, '고척돔');
      expect(concert.daysLeft, 10);
    });
  });
}
