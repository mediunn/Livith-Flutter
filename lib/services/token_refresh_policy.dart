/// 401 응답에 대해 토큰 갱신을 시도할지 판단한다.
///
/// 무한 재요청을 막기 위해 이미 재시도한 요청은 제외하고,
/// 리프레시 토큰이 있을 때만 갱신을 시도한다.
bool shouldAttemptRefresh({
  required int? statusCode,
  required bool hasRefreshToken,
  required bool alreadyRetried,
}) {
  if (statusCode != 401) return false;
  if (alreadyRetried) return false;
  return hasRefreshToken;
}
