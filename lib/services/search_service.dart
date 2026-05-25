import 'package:livith/models/concert.dart';
import 'package:livith/models/search_query.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';

import 'package:dio/dio.dart';

/// 콘서트 검색 인터페이스.
///
/// iOS `SearchRepository` 일부 대응.
abstract interface class SearchService {
  /// 키워드/장르 조건으로 콘서트를 검색한다.
  Future<List<Concert>> searchConcerts(SearchQuery query);
}

/// Dio 기반 [SearchService] 구현.
final class DioSearchService implements SearchService {
  DioSearchService(this._dio);

  final Dio _dio;

  @override
  Future<List<Concert>> searchConcerts(SearchQuery query) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/search/concerts',
        queryParameters: {
          if (query.keyword.trim().isNotEmpty) 'keyword': query.keyword.trim(),
          if (query.genreNameList.isNotEmpty) 'genre': query.genreNameList,
          'size': 30,
        },
      );
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as Map<String, dynamic>,
      );
      final list = (parsed.data?['data'] as List<dynamic>?) ?? const [];
      return list.cast<Map<String, dynamic>>().map(Concert.fromJson).toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
