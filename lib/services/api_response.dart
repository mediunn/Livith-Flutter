/// 서버 공통 응답 래퍼.
///
/// iOS `BaseResponse<T>` 대응. JSON 키: `statusCode`, `error`, `message`, `data`.
final class ApiResponse<T> {
  const ApiResponse({
    required this.statusCode,
    this.error,
    required this.message,
    this.data,
  });

  final int statusCode;
  final String? error;
  final String message;
  final T? data;

  /// `data`는 [dataParser]로 변환한다. `data`가 null이면 변환하지 않는다.
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) dataParser,
  ) {
    final data = json['data'];
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      error: json['error'] as String?,
      message: json['message'] as String? ?? '',
      data: data == null ? null : dataParser(data),
    );
  }
}
