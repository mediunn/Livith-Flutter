# 프로젝트 운영

## Purpose
- Flutter 프로젝트의 의존성 설치, 코드 생성, 빌드, 테스트 실행 절차에서 반복되는 환경 오류를 줄인다.
- 검증 명령을 고정하여 환경 차이로 인한 회귀를 줄인다.

## Scope
- 이 저장소의 모든 Flutter/Dart 명령(`flutter pub`, `dart pub`, `flutter test`, `flutter build`, `build_runner`)에 적용한다.
- 다음 용어는 이 문서에서 아래 의미로 사용한다.
- `flutter pub get`: 의존성을 설치하거나 갱신하는 명령
- `flutter pub run build_runner`: `freezed`, `json_serializable`, `injectable` 등 코드 생성 도구 실행 명령
- `flutter test`: 단위/위젯 테스트 실행 명령
- `flutter build apk` / `flutter build ios`: 플랫폼 빌드 명령
- `flutter analyze`: 정적 분석 명령
- `dart format`: 코드 포맷팅 명령
- `생산 코드 검증 명령`: `flutter analyze` 와 `flutter build apk --debug` (또는 `--profile`)
- `테스트 검증 명령`: `flutter test`
- `코드 생성 검증 명령`: `dart run build_runner build --delete-conflicting-outputs`

## Do

### 의존성 관리
- `pubspec.yaml` 또는 `pubspec.lock`이 변경된 후에는 빌드 또는 테스트 전에 반드시 `flutter pub get`을 실행한다.
- 새 패키지를 추가할 때는 직접 `pubspec.yaml`을 편집하지 말고 `flutter pub add <package>` 또는 `flutter pub add --dev <package>`를 사용한다.
- 워크스페이스 패키지 간 경로 의존성은 `path:` 형식으로 명시한다.

### 코드 생성
- `freezed`, `json_serializable`, `riverpod_generator`, `auto_route` 등 코드 생성기를 사용하는 어노테이션 또는 part 파일이 변경된 후에는 `dart run build_runner build --delete-conflicting-outputs`를 실행한다.
- 코드 생성 결과(`*.g.dart`, `*.freezed.dart`)는 직접 수정하지 않는다.
- 생성 결과를 새로 만들어야 하면 `--delete-conflicting-outputs` 플래그를 사용한다.

### 명령 실행 순서
- 모든 `flutter` 또는 `dart` 명령은 순차 실행한다. 같은 작업 디렉터리를 대상으로 하는 명령을 병렬로 실행하지 않는다.
- `flutter clean`은 빌드 캐시와 `.dart_tool/`을 모두 제거하고 다음 빌드 시간이 크게 늘어난다는 점을 확인한 뒤, 필요한 범위와 예상 시간을 사용자에게 보고하고 승인을 받은 후에만 실행한다.

### 정적 분석과 포맷
- Dart 파일을 수정한 후에는 `flutter analyze`를 실행해 lint 경고를 확인한다.
- 새 파일을 작성하거나 기존 파일을 크게 수정한 경우에는 `dart format <path>`를 실행한다.
- `analysis_options.yaml`에 정의된 lint 규칙은 임의로 비활성화하지 않는다.

### 테스트 실행
- 테스트 실행은 `flutter test` 또는 `flutter test <path>`를 사용한다.
- 특정 테스트 파일만 실행하려면 `flutter test test/path/to/file_test.dart`로 경로를 지정한다.
- 특정 테스트만 실행하려면 `flutter test --name "<test name pattern>"`을 사용한다.
- 위젯 테스트(integration_test 포함)는 동일하게 `flutter test`로 실행한다.
- 골든 테스트는 첫 생성 시 `flutter test --update-goldens`로 기준 이미지를 만들고, 이후에는 그냥 `flutter test`로 검증한다.
- 테스트 결과를 빌드 결과로 갈음하지 않는다. 빌드 성공은 테스트 통과와 별개로 다룬다.

### 생산 코드 컴파일 검증
- 컴파일 회귀 확인이 필요할 때는 `flutter analyze`와 `flutter build apk --debug` 또는 `flutter build ios --no-codesign`를 실행한다.
- 정적 분석 통과만으로 빌드 성공을 단정하지 않는다. iOS는 `flutter build ios --no-codesign`, Android는 `flutter build apk --debug`로 확인한다.

### 디바이스 / 시뮬레이터
- 디바이스를 지정해야 할 때는 `flutter devices`로 사용 가능한 디바이스 ID를 확인한 뒤 `-d <device-id>`로 지정한다.
- 기본 실행 디바이스는 사용자가 지정한 디바이스를 우선 사용한다.

## Don't
- `pubspec.yaml` 변경 후 `flutter pub get` 없이 `flutter test`나 `flutter build`를 실행하지 않는다.
- 코드 생성이 필요한 변경 후 `build_runner` 실행 없이 테스트나 빌드를 실행하지 않는다.
- `flutter`, `dart pub` 명령을 같은 작업 디렉터리에서 병렬로 실행하지 않는다.
- 생성된 코드(`*.g.dart`, `*.freezed.dart`)를 직접 손대지 않는다.
- `flutter clean`을 의존성 동기화나 코드 생성 문제 해결을 위해 먼저 시도하지 않는다. 원인을 먼저 확인한다.
- `flutter analyze` 경고를 무시하고 다음 단계로 진행하지 않는다 (분석 통과를 빌드/테스트 전 조건으로 본다).
- 빌드 명령 결과만으로 테스트 통과 여부를 판단하지 않는다.
- 디바이스를 지정해야 하는 상황에서 디바이스 확인 없이 명령을 실행하지 않는다.

## Exception
- `flutter clean`은 사용자가 필요성과 예상 시간을 확인하고 명시적으로 승인한 경우에만 실행한다.
- 코드 생성이 실패해 충돌이 남은 경우에 한해 `--delete-conflicting-outputs`로 재생성한다.
- 한 번의 예외로 현재 환경의 기본 검증 명령을 바꾸지 않는다. fallback 사용 후에는 원인을 트러블슈팅 문서에 기록한다.

## Checklist
- `pubspec.yaml`이나 `pubspec.lock` 변경 후 `flutter pub get`을 실행했는가
- 코드 생성이 필요한 변경 후 `dart run build_runner build`를 실행했는가
- Dart 파일 수정 후 `flutter analyze`로 lint 경고를 확인했는가
- 테스트 실행은 `flutter test`로 수행했는가
- 빌드 검증은 `flutter build apk --debug` 또는 `flutter build ios --no-codesign`로 수행했는가
- 디바이스 지정이 필요한 명령에서 `flutter devices` 결과를 기반으로 ID를 지정했는가
- `flutter clean` 실행 전에 영향 범위와 예상 시간을 사용자에게 보고하고 승인을 받았는가
- 모든 `flutter`/`dart` 명령이 병렬이 아닌 순차로 실행되었는가
