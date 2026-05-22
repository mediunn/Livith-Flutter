import 'package:flutter_test/flutter_test.dart';

import 'package:livith/models/setlist.dart';
import 'package:livith/models/song_lyrics.dart';

void main() {
  group('SetlistSong.fromJson은', () {
    test('id/title/order를 파싱한다', () {
      final song = SetlistSong.fromJson({'id': 1, 'title': 'Love Story', 'order': 3});

      expect(song.id, 1);
      expect(song.title, 'Love Story');
      expect(song.order, 3);
    });
  });

  group('Setlist.fromJson은', () {
    test('id/title/artist와 songs 목록을 파싱한다', () {
      final setlist = Setlist.fromJson({
        'id': 9,
        'title': 'Eras Setlist',
        'artist': 'Taylor Swift',
        'songs': [
          {'id': 1, 'title': 'A'},
          {'id': 2, 'title': 'B'},
        ],
      });

      expect(setlist.id, 9);
      expect(setlist.title, 'Eras Setlist');
      expect(setlist.artist, 'Taylor Swift');
      expect(setlist.songList.length, 2);
      expect(setlist.songList.first.title, 'A');
    });

    test('songs가 없으면 빈 목록으로 둔다', () {
      final setlist = Setlist.fromJson({'id': 1, 'title': 'X'});

      expect(setlist.songList, isEmpty);
    });
  });

  group('SongLyrics.fromJson은', () {
    test('가사/발음/번역 배열과 youtubeId를 파싱한다', () {
      final lyrics = SongLyrics.fromJson({
        'id': 5,
        'title': 'Song',
        'artist': 'Artist',
        'lyrics': ['l1', 'l2'],
        'pronunciation': ['p1'],
        'translation': ['t1', 't2'],
        'youtubeId': 'abc',
      });

      expect(lyrics.id, 5);
      expect(lyrics.lyricList, ['l1', 'l2']);
      expect(lyrics.pronunciationList, ['p1']);
      expect(lyrics.translationList, ['t1', 't2']);
      expect(lyrics.youtubeId, 'abc');
    });
  });
}
