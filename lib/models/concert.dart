/// 콘서트 진행 상태.
enum ConcertStatus {
  ongoing('ONGOING'),
  upcoming('UPCOMING'),
  completed('COMPLETED'),
  canceled('CANCELED'),
  past('PAST'),
  unknown('UNKNOWN');

  const ConcertStatus(this.value);

  final String value;

  static ConcertStatus fromValue(String? value) {
    return ConcertStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => ConcertStatus.unknown,
    );
  }
}

/// 콘서트.
///
/// iOS `Concert`/`FetchConcertInfo` 대응.
final class Concert {
  const Concert({
    required this.id,
    required this.title,
    required this.artist,
    required this.status,
    this.posterUrl,
    this.startDate,
    this.endDate,
    this.venue,
    this.daysLeft,
  });

  final int id;
  final String title;
  final String artist;
  final ConcertStatus status;
  final String? posterUrl;
  final String? startDate;
  final String? endDate;
  final String? venue;
  final int? daysLeft;

  factory Concert.fromJson(Map<String, dynamic> json) {
    return Concert(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      artist: json['artist'] as String? ?? '',
      status: ConcertStatus.fromValue(json['status'] as String?),
      posterUrl: json['posterUrl'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      venue: json['venue'] as String?,
      daysLeft: json['daysLeft'] as int?,
    );
  }
}
