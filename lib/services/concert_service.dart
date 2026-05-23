import 'package:livith/models/concert.dart';
import 'package:livith/models/concert_artist.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';
import 'package:livith/services/failure.dart';

import 'package:dio/dio.dart';

/// 콘서트 조회 인터페이스.
///
/// iOS `ConcertRepository`/`HomeRepository` 일부 대응.
abstract interface class ConcertService {
  /// 추천 콘서트 목록.
  Future<List<Concert>> fetchRecommendedConcerts();

  /// 사용자의 관심 콘서트 목록.
  Future<List<Concert>> fetchInterestConcerts();

  /// 콘서트 단건 상세.
  Future<Concert> fetchConcert(int id);

  /// 콘서트 아티스트 상세.
  Future<ConcertArtist> fetchArtist(int concertId);
}

/// Dio 기반 [ConcertService] 구현.
final class DioConcertService implements ConcertService {
  DioConcertService(this._dio);

  final Dio _dio;

  @override
  Future<List<Concert>> fetchRecommendedConcerts() {
    return _concertList('/recommendation/concerts');
  }

  @override
  Future<List<Concert>> fetchInterestConcerts() {
    return _concertList('/users/interest-concerts');
  }

  @override
  Future<Concert> fetchConcert(int id) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/concerts/$id');
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as Map<String, dynamic>,
      );
      final data = parsed.data;
      if (data == null) throw const ParsingFailure();
      return Concert.fromJson(data);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  @override
  Future<ConcertArtist> fetchArtist(int concertId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/concerts/$concertId/artist',
      );
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as Map<String, dynamic>,
      );
      final data = parsed.data;
      if (data == null) throw const ParsingFailure();
      return ConcertArtist.fromJson(data);
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  Future<List<Concert>> _concertList(String path) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(path);
      final parsed = ApiResponse<List<dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as List<dynamic>,
      );
      final data = parsed.data ?? const [];
      return data
          .cast<Map<String, dynamic>>()
          .map(Concert.fromJson)
          .toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
