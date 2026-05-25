import 'package:livith/models/song_lyrics.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 곡 가사 조회 인터페이스.
///
/// iOS `SongRepository` 대응.
abstract interface class SongService {
  /// 곡 가사를 조회한다.
  Future<SongLyrics> fetchLyrics(int songId);
}

/// Dio 기반 [SongService] 구현.
final class DioSongService implements SongService {
  DioSongService(this._dio);

  final Dio _dio;

  @override
  Future<SongLyrics> fetchLyrics(int songId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/songs/$songId');
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as Map<String, dynamic>,
      );
      final data = parsed.data;
      if (data == null) throw const ParsingFailure();
      return SongLyrics.fromJson(data);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
