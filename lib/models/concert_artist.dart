/// 콘서트 아티스트 상세.
///
/// iOS `Artist`(콘서트 상세) 대응. `/concerts/{id}/artist` 응답에서 생성한다.
final class ConcertArtist {
  const ConcertArtist({
    required this.name,
    this.imageUrl,
    this.introduction,
  });

  final String name;
  final String? imageUrl;
  final String? introduction;

  factory ConcertArtist.fromJson(Map<String, dynamic> json) {
    return ConcertArtist(
      name: (json['artist'] ?? json['name']) as String? ?? '',
      imageUrl: (json['imgUrl'] ?? json['imageUrl']) as String?,
      introduction: (json['detail'] ?? json['introduction']) as String?,
    );
  }
}
