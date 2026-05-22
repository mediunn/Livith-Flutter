/// 도메인 계층에서 사용하는 실패 표현.
///
/// `Service`/`Repository`는 외부(네트워크/저장소) 오류를 이 타입으로 매핑한다.
sealed class Failure {
  const Failure(this.message);

  final String message;
}

/// 네트워크 연결/타임아웃 실패.
final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '네트워크 연결을 확인해주세요']);
}

/// 인증 실패(401). 토큰 갱신 불가 시 로그아웃 처리에 사용한다.
final class AuthFailure extends Failure {
  const AuthFailure([super.message = '인증이 필요합니다']);
}

/// 서버 응답 오류(4xx/5xx).
final class ServerFailure extends Failure {
  const ServerFailure(super.message, {this.statusCode});

  final int? statusCode;
}

/// 응답 파싱 실패.
final class ParsingFailure extends Failure {
  const ParsingFailure([super.message = '응답을 해석할 수 없습니다']);
}

/// 분류되지 않은 실패.
final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = '알 수 없는 오류가 발생했습니다']);
}
