import 'package:livith/models/concert_comment.dart';
import 'package:livith/services/api_response.dart';
import 'package:livith/services/dio_failure_mapper.dart';

import 'package:dio/dio.dart';

/// 콘서트 커뮤니티 댓글 인터페이스.
///
/// iOS `CommentRepository` 대응.
abstract interface class CommentService {
  /// 콘서트 댓글 목록.
  Future<List<ConcertComment>> fetchComments(int concertId);

  /// 댓글 작성.
  Future<void> createComment(int concertId, String content);

  /// 댓글 삭제.
  Future<void> deleteComment(int commentId);
}

/// Dio 기반 [CommentService] 구현.
final class DioCommentService implements CommentService {
  DioCommentService(this._dio);

  final Dio _dio;

  @override
  Future<List<ConcertComment>> fetchComments(int concertId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/concerts/$concertId/comments',
      );
      final parsed = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data ?? const {},
        (data) => data as Map<String, dynamic>,
      );
      final list = (parsed.data?['data'] as List<dynamic>?) ?? const [];
      return list
          .cast<Map<String, dynamic>>()
          .map(ConcertComment.fromJson)
          .toList();
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  @override
  Future<void> createComment(int concertId, String content) async {
    try {
      await _dio.post<Map<String, dynamic>>(
        '/concerts/$concertId/comments',
        data: {'content': content},
      );
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      await _dio.delete<Map<String, dynamic>>('/comments/$commentId');
    } on DioException catch (exception) {
      throw mapDioException(exception);
    }
  }
}
