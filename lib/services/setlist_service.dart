import 'package:livith/models/setlist.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';

import 'package:dio/dio.dart';

/// 셋리스트 조회 인터페이스.
///
/// iOS `SetlistRepository` 대응.
abstract interface class SetlistService {
  /// 콘서트의 셋리스트 목록.
  Future<List<Setlist>> fetchSetlists(int concertId);
}

/// Dio 기반 [SetlistService] 구현.
final class DioSetlistService implements SetlistService {
  DioSetlistService(this._dio);

  final Dio _dio;

  @override
  Future<List<Setlist>> fetchSetlists(int concertId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/concerts/$concertId/setlists',
      );
      final parsed = ApiResponse<List<dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as List<dynamic>,
      );
      final data = parsed.data ?? const [];
      return data.cast<Map<String, dynamic>>().map(Setlist.fromJson).toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
