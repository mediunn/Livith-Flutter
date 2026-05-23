import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/concert_comment.dart';

void main() {
  group('ConcertComment.fromJson은', () {
    test('id/writer/content와 선택 필드를 파싱한다', () {
      final comment = ConcertComment.fromJson({
        'id': 7,
        'writer': '라이빗',
        'content': '기대돼요',
        'createdAt': '2026-05-23',
        'userId': 3,
      });

      expect(comment.id, 7);
      expect(comment.writer, '라이빗');
      expect(comment.content, '기대돼요');
      expect(comment.createdAt, '2026-05-23');
      expect(comment.userId, 3);
    });
  });
}
