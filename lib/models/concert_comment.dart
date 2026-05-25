/// 콘서트 커뮤니티 댓글.
///
/// iOS `ConcertComment` 대응.
final class ConcertComment {
  const ConcertComment({
    required this.id,
    required this.writer,
    required this.content,
    this.createdAt,
    this.userId,
  });

  final int id;
  final String writer;
  final String content;
  final String? createdAt;
  final int? userId;

  factory ConcertComment.fromJson(Map<String, dynamic> json) {
    return ConcertComment(
      id: json['id'] as int,
      writer: json['writer'] as String? ?? '',
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      userId: json['userId'] as int?,
    );
  }
}
