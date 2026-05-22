import 'package:livith/models/temp_user.dart';

/// 소셜 로그인 결과.
///
/// iOS `LoginStatus` 대응. 응답의 `isNewUser`로 기존/신규 사용자를 구분한다.
sealed class LoginStatus {
  const LoginStatus();

  /// 로그인 응답 JSON을 [LoginStatus]로 파싱한다.
  factory LoginStatus.fromJson(Map<String, dynamic> json) {
    final isNewUser = json['isNewUser'] as bool? ?? false;
    if (isNewUser) {
      return NewUser(TempUser.fromJson(json['tempUserData'] as Map<String, dynamic>));
    }
    return ExistingUser(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

/// 기존 사용자. 액세스/리프레시 토큰을 보유한다.
final class ExistingUser extends LoginStatus {
  const ExistingUser({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;
}

/// 신규 사용자. 온보딩(가입) 진행이 필요하다.
final class NewUser extends LoginStatus {
  const NewUser(this.tempUser);

  final TempUser tempUser;
}
