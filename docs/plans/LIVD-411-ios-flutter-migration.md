# LIVD-411 iOS 프로젝트 플러터로 이관

## 배경
- Livith는 K-pop 콘서트 정보 플랫폼(콘서트 일정·셋리스트·가사번역·응원법·커뮤니티)으로, 현재 iOS(Swift/SwiftUI, Tuist 14개 모듈, ~473 파일)로 구현되어 있다.
- 이를 Flutter(Riverpod + MVVM)로 이관한다. iOS는 화면 74개, 도메인 엔티티 ~30개, API 엔드포인트 ~60개 규모이므로 단일 PR로 불가능하다.
- 따라서 전체를 마일스톤으로 분할하고, 본 문서는 **전체 로드맵 + 마일스톤 1(기반 + 디자인시스템)** 을 다룬다. 이후 마일스톤은 별도 plan 문서로 분리한다.

## 목표
- 전체 이관의 마일스톤 로드맵을 확정한다.
- **마일스톤 1 완료 시**: iOS의 디자인 토큰(색상/타이포)과 핵심 공통 위젯, 네트워킹/DI 토대가 Flutter에 구축되어, 이후 화면 이관이 이 토대 위에서 진행 가능한 상태가 된다.

## 전체 로드맵 (마일스톤)
| # | 마일스톤 | 범위 | 상태 |
|---|----------|------|------|
| **M1** | **기반 + 디자인시스템** | 색상/타이포/폰트, 공통 위젯, 네트워킹·DI 토대, 폴더 구조 | **본 문서** |
| M2 | 도메인 모델 + 네트워킹 | ~30 엔티티, API 클라이언트, ~60 엔드포인트, 토큰/인증 인터셉터, 로컬 저장소 | 예정 |
| M3 | 인증 / 온보딩 | 로그인(카카오/애플) → 약관 → 닉네임 → 선호 장르/아티스트 | 예정 |
| M4 | 홈 탭 | 홈, 관심 공연, 공지, 선호도 수정 | 예정 |
| M5 | 탐색 탭 | 탐색, 검색, 필터 바텀시트 | 예정 |
| M6 | 콘서트 상세 | 콘서트 상세(4탭), 셋리스트, 가사, 굿즈 | 예정 |
| M7 | 마이 탭 | 마이페이지, 설정, 알림설정, 회원탈퇴 | 예정 |
| M8 | 외부 연동 / 마무리 | FCM, Amplitude, 딥링크, 위젯 검토 | 예정 |

> M2~M8은 각각 시작 시점에 별도 plan 문서(`docs/plans/LIVD-XXX-*.md`)를 작성하고 확인받는다.

---

## 마일스톤 1 — 작업 항목

- [ ] **1. 폰트 에셋 도입**
  - iOS 레포에서 Noto Sans KR 4종(Bold/SemiBold/Medium/Regular, ttf), Pretendard 9종(otf)을 `assets/fonts/`로 복사
  - `pubspec.yaml`의 `fonts:` 섹션에 family `NotoSansKR`, `Pretendard` 등록
- [ ] **2. 색상 토큰** (`lib/core/theme/livith_colors.dart`)
  - iOS `LivithColor` 12색을 `Color` 상수로 정의 (아래 표)
- [ ] **3. 타이포그래피** (`lib/core/theme/livith_typography.dart`)
  - iOS `Notosans` 13스타일을 `TextStyle`로 정의 (size/weight/height/letterSpacing)
- [ ] **4. 앱 테마** (`lib/core/theme/livith_theme.dart`)
  - 다크 기반 `ThemeData` 구성(배경 Black100), `app.dart`에 적용
- [ ] **5. 핵심 공통 위젯** (`lib/views/widgets/`) — iOS DesignSystem 대응
  - 우선순위: 버튼 계열(LivithButton/ActionButton/TextButton), 카드(LivithCard), 칩(LivithChip), 네비게이션 헤더(LivithNavigationView), 세그먼트 탭바, 모달(LivithModal/DangerModal), 토스트, 비동기 이미지(AsyncImageView→cached_network_image), FlowLayout(자동 줄바꿈)
  - 이번 마일스톤은 토큰+위젯 골격 우선. 화면별 특수 컴포넌트는 해당 화면 마일스톤에서 추가
- [ ] **6. 네트워킹 토대** (`lib/services/`, `lib/providers/`)
  - Dio 기반 `ApiClient` Service + `Provider<ApiClient>` 노출
  - 토큰 인터셉터/401 갱신 골격(실제 토큰 저장은 M2)
  - **TDD 적용**: 요청 빌더/인터셉터 로직은 실패 테스트 → 구현
- [ ] **7. 폴더 구조 정비**
  - `lib/core/theme/`, 위젯 디렉터리 정리, 기존 `home_screen.dart`의 임시 내용을 디자인시스템 미리보기로 대체(검증용)

### 색상 토큰 (iOS → Flutter)
| 토큰 | HEX | 토큰 | HEX |
|------|-----|------|-----|
| black100 | #14171B | black5 | #F2F4F6 |
| black90 | #222831 | white100 | #FFFFFF |
| black80 | #2F3745 | yellow30 | #FFFF97 |
| black50 | #808794 | yellow60 | #FFEB56 |
| black30 | #DBDCDF | caution100 | #E11936 |
| original | #CAD0FF | translation | #FFBAB4 |

### 타이포 스타일 (Noto Sans KR, kerning = size × −5%)
| 스타일 | weight | size | height(배) |
|--------|--------|------|-----------|
| title | Bold | 26 | 1.38 |
| head{Semibold/Medium/Regular} | SemiBold/Medium/Regular | 22 | 1.38 |
| body1Semibold | SemiBold | 18 | 1.38 |
| body2{Semibold/Medium/Regular} | - | 16 | 1.38 |
| body3{Semibold/Medium/Regular} | - | 15 | 1.38 |
| body4{Semibold/Medium/Regular} | - | 14 | 1.38 |
| caption1Bold/Semibold | Bold/SemiBold | 12 | 1.28 |
| caption1Regular | Regular | 12 | 1.18 |
| caption2{Semibold/Regular} | SemiBold/Regular | 10 | 1.18 |

## 영향 범위
- `pubspec.yaml` (의존성: dio, cached_network_image / fonts 섹션)
- `assets/fonts/` (신규)
- `lib/core/theme/` (신규: livith_colors / livith_typography / livith_theme)
- `lib/views/widgets/` (공통 위젯 다수)
- `lib/services/`, `lib/providers/` (ApiClient 토대)
- `lib/app.dart`, `lib/views/screens/home_screen.dart` (테마 적용/미리보기)
- `test/` (네트워킹 토대 단위 테스트)

## 기술 결정
| 결정 사항 | 선택지 | 결정 | 근거 |
|-----------|--------|------|------|
| HTTP 클라이언트 | dio / http | **dio** | 인터셉터·토큰 자동 갱신·취소 토큰 필요 (iOS의 인터셉터 구조 대응) |
| 이미지 로딩 | cached_network_image / 기타 | **cached_network_image** | iOS Kingfisher의 URL 캐싱 대응 |
| 폰트 도입 | 에셋 직접 포함 / google_fonts | **에셋 직접 포함** | iOS와 동일 ttf/otf 사용으로 렌더링 일치, Pretendard는 google_fonts 미제공 |
| 색상/타이포 표현 | 상수 클래스 / ThemeExtension | **상수 클래스 + ThemeData 병행** | iOS가 named token 직접 참조 방식이라 이행 단순. 추후 ThemeExtension 검토 |
| 라우팅 | Navigator / go_router | **go_router** (M3에서 확정) | 화면 74개·탭+스택 구조라 선언적 라우팅 유리. M1은 토대만, 실제 도입은 인증 마일스톤 |
| 테마 모드 | 다크 고정 / 라이트 지원 | **다크 고정** | iOS가 Black100 배경의 다크 단일 테마 |

## 주의 사항
- `Model`에 `flutter/material.dart`·`flutter_riverpod` import 금지. 색상/타이포는 `core/theme`(UI 레이어)에 두므로 무방.
- `Service`(ApiClient)에 `flutter_riverpod` import 금지 — Provider는 `lib/providers/`에서만.
- 네트워킹 토대는 **TDD 대상**: red → green → refactor 순서 준수. 디자인 토큰/순수 위젯은 위젯 테스트 선택.
- 폰트 라이선스(Noto Sans KR=OFL, Pretendard=OFL) 확인 — 재배포 가능. 라이선스 파일도 함께 포함.
- 마일스톤 1은 화면 동작이 아닌 "토대" 구축이므로, 검증은 디자인시스템 미리보기 화면으로 수행.
- 진행 중 실패/방향 전환 발생 시 `docs/troubleshooting/LIVD-411-*.md`에 즉시 기록.

## 검증 방법
- `flutter analyze` 무경고
- `flutter test` 통과 (네트워킹 토대 단위 테스트 포함)
- 에뮬레이터(Pixel 7 / API 36)에서 디자인시스템 미리보기 화면 실행 → 색상/타이포/공통 위젯이 iOS와 시각적으로 일치하는지 수동 확인
