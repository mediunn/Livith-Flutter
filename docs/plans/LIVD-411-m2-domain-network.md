# LIVD-411 마일스톤 2 — 도메인 모델 + 네트워킹

## 배경
- 마일스톤 1에서 디자인시스템과 `dio` 네트워킹 토대(`dioProvider`, `AuthInterceptor`, 인메모리 `TokenStore`)를 구축했다.
- 화면 이관(M3~)을 시작하려면 공통 네트워킹 인프라(응답 래퍼·에러 매핑·토큰 영속화)와 인증/유저 도메인이 먼저 필요하다.
- iOS는 도메인 엔티티 ~30개, API ~60개를 갖지만, 한 번에 전부 이식하면 사용되지 않는 코드가 대량 생긴다. 따라서 **공통 인프라 + 인증/유저 도메인까지만** M2에서 다루고, 나머지 도메인 모델·Service는 그것을 사용하는 화면 마일스톤에서 추가한다(YAGNI).

## 목표
- 모든 도메인 Service가 공유할 네트워킹 인프라(응답 디코딩, 에러 매핑, 토큰 영속/갱신)를 완성한다.
- 인증/온보딩(M3)에 필요한 인증·유저 도메인 모델과 Service를 이식한다.
- M2 완료 시 M3(로그인/온보딩) 화면을 ViewModel→Service→Model 흐름으로 구현할 수 있다.

## 작업 항목
- [ ] **1. 공통 응답/에러 모델**
  - iOS `ServerResponse<T>`(status/message/data) 대응 `ApiResponse<T>` 디코딩 헬퍼
  - 도메인 실패를 표현하는 `Failure` sealed class (네트워크/인증/서버/파싱)
  - Dio 에러 → `Failure` 매핑 (TDD)
- [ ] **2. 토큰 영속화**
  - `flutter_secure_storage` 기반 `SecureTokenStore`로 M1 `InMemoryTokenStore` 교체 (`tokenStoreProvider` override)
  - 401 응답 시 refresh → 재요청하는 인터셉터 로직 (TDD)
- [ ] **3. 환경별 baseURL**
  - `--dart-define`(`LIVITH_API_BASE_URL`) 기반 설정 정리, 실제 dev/prod URL 반영
- [ ] **4. 인증/유저 도메인 모델**
  - `User`, `SocialProvider`, `TempUser`, `SignupInfo`, `Nickname` 등 불변 모델 + `fromJson` (TDD)
- [ ] **5. 인증/유저 Service**
  - `AuthService`: apple/kakao 로그인, signup, logout, withdraw, 닉네임 중복확인
  - `UserService`: `GET /users/me`, 닉네임 수정
  - 응답 DTO → 도메인 Model 매핑 (TDD)
- [ ] **6. Provider 등록**
  - `authServiceProvider`, `userServiceProvider`를 `lib/providers/`에 노출

## 영향 범위
- `pubspec.yaml` (flutter_secure_storage, 코드젠 도입 시 json_serializable/build_runner)
- `lib/models/` (인증/유저 도메인 모델)
- `lib/services/` (auth_service, user_service, secure_token_store, api_response, failure)
- `lib/providers/` (authServiceProvider, userServiceProvider, tokenStore override)
- `test/` (모델 fromJson, 에러 매핑, 토큰 갱신, Service 파싱 테스트)

## 기술 결정
| 결정 사항 | 선택지 | 결정 | 근거 |
|-----------|--------|------|------|
| JSON 직렬화 | 수동 fromJson / json_serializable | **수동 fromJson** | M2 범위 모델 수가 적고(인증/유저), 코드젠 의존성·빌드 단계를 미루는 편이 단순. 모델이 급증하는 화면 마일스톤에서 json_serializable 재검토 |
| 토큰 저장 | flutter_secure_storage / shared_preferences | **flutter_secure_storage** | iOS Keychain 대응, 토큰은 민감정보 |
| 도메인/DTO 분리 | 통합 / Mapper 분리 | **형식 다를 때만 분리** | architecture.md 준수. 응답 구조와 도메인이 같으면 단일 Model |
| 에러 표현 | Exception / sealed Failure | **sealed Failure** | code-convention의 Result/Either 지향과 정합, AsyncValue.error 매핑 용이 |

## 주의 사항
- `Model`에 `flutter/material.dart`·`dio`·`flutter_riverpod` import 금지.
- `Service`에 `flutter_riverpod` import 금지 (Provider 파일에서만).
- 토큰 갱신 인터셉터는 무한 재요청 방지(refresh 실패 시 로그아웃 처리) 로직 포함.
- Model `fromJson`, Mapper, 에러 매핑, 토큰 갱신은 **TDD 대상**. Dio 조립/Provider 배선은 예외.
- 실제 API 응답 키는 iOS DTO(`Projects/Data/*/Model`)를 근거로 맞춘다.

## 검증 방법
- `flutter analyze` 무경고
- `flutter test` 통과 (모델 fromJson, 에러 매핑, 토큰 갱신, Service 파싱 단위 테스트)
- M3 착수 시 실제 로그인 플로우로 통합 확인
