import 'package:livith/models/artist.dart';
import 'package:livith/models/genre.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 선호 장르/아티스트 조회 인터페이스.
///
/// iOS `PreferenceRepository`/`SearchRepository` 일부 대응.
abstract interface class PreferenceService {
  /// 전체 장르 목록을 조회한다.
  Future<List<Genre>> fetchGenres();

  /// 키워드로 아티스트를 검색한다.
  Future<List<Artist>> searchArtists({required String keyword, int size});
}

/// Dio 기반 [PreferenceService] 구현.
final class DioPreferenceService implements PreferenceService {
  DioPreferenceService(this._dio);

  final Dio _dio;

  @override
  Future<List<Genre>> fetchGenres() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/genres');
      return _list(response).map(Genre.fromJson).toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  @override
  Future<List<Artist>> searchArtists({required String keyword, int size = 20}) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search/artists',
        queryParameters: {'keyword': keyword, 'size': size},
      );
      return _list(response).map(Artist.fromJson).toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  List<Map<String, dynamic>> _list(Response<Map<String, dynamic>> response) {
    final parsed = ApiResponse<List<dynamic>>.fromJson(
      response.data ?? const {},
      (data) => data as List<dynamic>,
    );
    final data = parsed.data;
    if (data == null) throw const ParsingFailure();
    return data.cast<Map<String, dynamic>>();
  }
}
