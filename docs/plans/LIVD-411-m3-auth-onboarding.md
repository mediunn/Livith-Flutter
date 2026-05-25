# LIVD-411 마일스톤 3 — 인증 / 온보딩

## 배경
- M1(디자인시스템), M2(인증/유저 모델·Service·토큰)를 토대로 첫 사용자 플로우인 로그인/온보딩을 구현한다.
- iOS 흐름: 로그인(카카오/애플) → 약관 동의 → 닉네임 설정 → 선호 장르 → 선호 아티스트 → 가입 완료 → 메인.

## 목표
- 로그인~온보딩 화면과 ViewModel, 라우팅을 완성해 가입/로그인 흐름이 동작한다.
- 선호 장르/아티스트 조회에 필요한 모델·Service를 추가한다(M3 범위에서 필요한 만큼).

## 작업 항목
- [ ] **1. 라우팅(go_router) 도입** — 라우트 정의, 인증 상태 기반 리다이렉트
- [ ] **2. 인증 상태 ViewModel** — `AuthNotifier`(로그인 여부/토큰 로드/로그아웃), 앱 시작 시 `SecureTokenStore.load`
- [ ] **3. 소셜 로그인 추상화** — `SocialAuthService` 인터페이스(애플/카카오 토큰 획득). **네이티브 키가 필요하므로 M3는 인터페이스 + stub 구현**, 실제 SDK(kakao_flutter_sdk/sign_in_with_apple) 연동은 키 설정 후 교체
- [ ] **4. 로그인 화면 + ViewModel** — 소셜 버튼 → AuthService 로그인 → 기존/신규 분기
- [ ] **5. 약관 동의 화면**
- [ ] **6. 닉네임 설정 화면 + ViewModel** — `Nickname` 검증 + 중복확인(`isNicknameAvailable`)
- [ ] **7. 선호 장르 화면** — `/genres` 조회(Genre 모델·PreferenceService 추가)
- [ ] **8. 선호 아티스트 화면 + 가입** — `/search/artists` 조회, `SignupInfo`로 `signup` 호출
- [ ] **9. 검증** — analyze/test, 에뮬레이터 흐름 확인(소셜 로그인은 stub 토큰으로)

## 영향 범위
- `pubspec.yaml` (go_router; 추후 kakao_flutter_sdk/sign_in_with_apple)
- `lib/routes/`, `lib/view_models/`, `lib/views/screens/`, `lib/models/`(Genre/Artist), `lib/services/`(social_auth, preference), `lib/providers/`
- `test/`

## 기술 결정
| 결정 사항 | 선택지 | 결정 | 근거 |
|-----------|--------|------|------|
| 라우팅 | Navigator / go_router | **go_router** | 인증 리다이렉트·다중 화면에 선언적 라우팅 유리(M1 결정 이행) |
| 소셜 로그인 SDK | 즉시 연동 / 인터페이스+stub | **인터페이스+stub** | 카카오/애플 네이티브 키·콘솔 설정이 외부 의존. 흐름·UI를 먼저 완성하고 키 확보 후 실연동 |
| 온보딩 상태 공유 | 화면별 분리 / 온보딩 전역 Notifier | **온보딩 전역 Notifier** | 닉네임·장르·아티스트 선택을 마지막 signup까지 누적해야 함 |

## 주의 사항
- 소셜 로그인 실제 토큰 획득은 stub. 실제 키 연동 지점은 `SocialAuthService` 구현 교체로 국한한다.
- ViewModel·모델·Service·매퍼는 TDD. 화면 위젯 배선과 SDK 연결은 예외 허용.
- 실제 API 서버 URL(`LIVITH_API_BASE_URL`)이 없으면 통합 확인은 stub/모의로 제한된다.

## 검증 방법
- `flutter analyze` 무경고, `flutter test` 통과(ViewModel/모델 단위 테스트)
- 에뮬레이터에서 로그인(stub)→온보딩→가입 화면 전환 확인
