# 코드 컨벤션

## Purpose
- 이 저장소에서 AI가 기존 Dart 코드와 같은 형태로 파일을 작성하고 수정하기 위한 코드 컨벤션을 정의한다.
- 파일 구조, region 주석, 접근 제어, 오류 선언, 제어 흐름의 흔들림을 줄이기 위한 작업 기준을 고정한다.

## Scope
- `lib/**` 아래의 Dart 소스 파일에 적용한다.
- 아키텍처 선택보다 Dart 코드의 파일 구성, 선언 방식, 주석 형태에 적용한다.
- 다음 용어는 이 문서에서 아래 의미로 사용한다.
- `ViewModel 파일`: `Notifier` 또는 `AsyncNotifier`를 상속한 클래스와 그 `NotifierProvider`/`AsyncNotifierProvider`를 함께 담는 Dart 파일
- `View 파일`: `ConsumerWidget`, `ConsumerStatefulWidget`, `StatelessWidget`, `StatefulWidget` 구현을 담는 Dart 파일
- `Model 파일`: 데이터 모델, DTO, 도메인 객체를 담는 Dart 파일
- `Service 파일`: HTTP/저장소/외부 SDK 호출을 담당하는 클래스를 담는 Dart 파일
- `Repository 파일`: 여러 `Service`를 조합하는 클래스를 담는 Dart 파일
- `Provider 파일`: Service/Repository/공통 의존성을 노출하는 Riverpod `Provider` 정의를 담는 Dart 파일
- `구조 템플릿 적용 파일`: `View 파일`, `ViewModel 파일`
- `비핵심 Dart 파일`: `구조 템플릿 적용 파일`이 아닌 Dart 소스 파일
- `같은 역할 파일`: 같은 디렉터리에 있고 파일명 접두사 또는 접미사가 같은 Dart 파일
- `private 헬퍼 그룹`: 파일 하단에 두는 `// region Helpers ... // endregion` 또는 별도 private 클래스/extension 형태의 구현 블록
- `필요한 섹션`: `docs/templates/mark-template.md`에 정의된 섹션 중 해당 파일에 실제 코드가 있는 섹션
- `로컬 import`: 이 저장소 내부 파일을 가리키는 `package:livith/...` import
- `외부 패키지 import`: pub.dev 패키지 또는 외부 SDK import
- `조기 종료 조건`: 실패 조건을 먼저 검사하고 `return`, `continue`, `break`, `throw`로 흐름을 끝낼 수 있는 조건
- `구조 템플릿 적용 파일`의 region 또는 클래스 구성 순서는 `docs/templates/mark-template.md`를 기준으로 작성한다.
- 새 `비핵심 Dart 파일`의 region/구조는 `같은 역할 파일`을 먼저 따른다.
- `같은 역할 파일`이 없으면 새 `비핵심 Dart 파일`에 region 주석을 추가하지 않는다.
- 테스트 코드는 `docs/rules/tdd.md`를 따른다.

## Do
### File Structure
- import는 `dart:` SDK를 먼저 두고 한 줄 비운 뒤 `package:flutter/...`를 두고 다시 한 줄 비운 뒤 `로컬 import`를 두고 다시 한 줄 비운 뒤 `외부 패키지 import`를 둔다.
- `flutter_riverpod` import는 `외부 패키지 import` 블록의 맨 위에 둔다.
- Dart 코드는 `dart format` 출력 형식을 따른다.
- Dart SDK 버전은 `pubspec.yaml`의 `environment.sdk` 범위를 따른다.
- 기존 Dart 파일의 헤더 주석은 임의로 수정하지 않는다.
- 새 Dart 파일을 만들 때는 같은 디렉터리의 기존 파일 헤더 형식을 따른다.
- 작성자 표기가 필요하면 실제 사용자의 이름만 사용한다.
- `View 파일`의 보조 위젯 메서드, 계산값, 이벤트 헬퍼는 본문 아래 private 메서드 또는 private extension으로 분리한다.
- `View 파일`이 길어질 경우 보조 위젯은 같은 파일 내 private `class _SectionView extends ConsumerWidget`(또는 `StatelessWidget`)으로 분리한다.
- `ViewModel 파일`의 내부 처리 로직, 비동기 작업, 상태 보조 메서드는 private 메서드로 분리한다.
- `ViewModel 파일`에는 ViewModel 클래스 1개 + 그 `NotifierProvider` 또는 `AsyncNotifierProvider` 1개만 둔다. 같은 화면용 보조 State 클래스를 같은 파일에 둘 수 있다.
- 같은 패키지 안에서 동일한 파일명을 사용하지 않는다. DTO 파일명은 타입명과 달라도 된다.
- 고정 설정 `Dio` 인스턴스, `JsonEncoder`, `JsonDecoder`는 `Provider 파일`에서 한 번 생성한 인스턴스를 재사용한다.

### Naming
- 파일명은 `snake_case.dart`로 작성한다 (예: `concert_list_screen.dart`, `concert_list_view_model.dart`).
- View 파일명은 화면 단위에서 `_screen.dart`, 재사용 컴포넌트는 `_view.dart` 또는 의미를 드러내는 접미사를 사용한다.
- ViewModel 파일명은 `_view_model.dart` 접미사를 쓴다.
- Service 파일명은 `_service.dart`, Repository 파일명은 `_repository.dart` 접미사를 쓴다.
- Provider 변수명은 `<대상>Provider` 형식으로 작성한다 (예: `concertListViewModelProvider`, `dioProvider`).
- 클래스, enum, typedef, extension 이름은 `UpperCamelCase`로 작성한다.
- 변수, 함수, 메서드, 파라미터, 필드는 `lowerCamelCase`로 작성한다.
- 상수는 `lowerCamelCase`로 작성한다 (예: `static const cornerRadius = 12.0`).
- 배열, 목록, 선택된 항목 모음처럼 순서가 있는 컬렉션 이름은 단순 복수형 `s` 접미사보다 `List` 접미사를 우선 사용한다.
- 새 내부 API 이름을 만들 때는 `concertList`, `selectedConcertIdList`, `recommendedKeywordList`처럼 목록 성격이 바로 드러나게 작성한다.
- 함수 파라미터, 프로퍼티, 로컬 변수 모두 같은 기준으로 맞춘다.

### Region / 파일 구조
- 파일 내 구역 표시가 필요하면 `// region <섹션명>` 과 `// endregion` 쌍을 사용한다.
- `구조 템플릿 적용 파일`에서 `필요한 섹션`이 3개 이상이면 region 주석을 쓴다.
- `구조 템플릿 적용 파일`의 region 이름과 순서는 `docs/templates/mark-template.md`를 그대로 따른다.
- 기존 `구조 템플릿 적용 파일`을 수정하면서 region 명을 함께 수정할 때는 템플릿 이름으로 맞춘다.

### Access Control
- 같은 파일에서만 쓰는 식별자는 언더스코어(`_`) 접두사로 라이브러리 private으로 선언한다.
- 같은 디렉터리 안에서만 쓰는 식별자도 언더스코어(`_`) 접두사를 우선 고려한다.
- 상속 의도가 없는 클래스는 Dart 3의 `final class` 또는 `sealed class`로 선언한다.
- `ViewModel`의 상태 변경은 클래스 내부 메서드에서만 수행하고, 외부에 setter나 mutable 필드를 노출하지 않는다.
- `Provider`는 파일 최상위 `final` 상수로 선언한다.

### Private Helpers
- 타입 내부의 private 메서드가 많으면 같은 파일 안의 private extension(`extension _ViewModelHelpers on ExampleViewModel { ... }`)으로 묶는다.
- private extension 안의 메서드 이름에는 다시 `_`를 붙이지 않는다.

### Error Handling
- 도메인 메서드(특히 `Service`/`Repository`)에서 발생 가능한 실패는 도메인 Exception 또는 `Either<Failure, T>` / sealed class 기반 `Result` 타입으로 표현한다.
- `AsyncNotifier`에서는 `AsyncValue.guard` 또는 `try/catch` 후 `state = AsyncError(...)`로 실패를 표현한다.
- 외부 SDK가 `throw`를 강제하는 경우에만 `try/catch`로 잡아 도메인 실패로 매핑한다.
- `catch`로 잡은 예외는 무시(`catch (_) {}`)하지 않는다. 도메인 Failure로 변환하거나 명시적으로 처리한다.

### Control Flow
- `조기 종료 조건`은 함수 초반에 `if (... ) return;` 으로 먼저 정리한다.
- 실패 조건, null 검사, 타입 캐스팅 실패, 빈 값 검사는 함수 초반에 먼저 정리한다.
- 조건 분기가 늘어날 때는 조기 반환과 보조 메서드 분리로 중첩을 줄인다.
- nullable 처리는 `?.`, `??`, `late`, 패턴 매칭 중 의미가 가장 명확한 것을 사용한다.

## Don't
### File Structure
- `View 파일`에서 보조 위젯 메서드와 계산값을 `build` 메서드 사이에 흩어 놓지 않는다.
- `ViewModel 파일`에서 내부 처리 로직을 공개 인터페이스 사이에 섞어 넣지 않는다.
- 한 파일에 두 개 이상의 ViewModel 클래스를 두지 않는다.
- 작성자 이름에 AI 에이전트 이름이나 도구 이름을 넣지 않는다.
- 실제 사용자의 이름을 확실히 알 수 없으면 작성자 이름을 추측해 넣지 않는다.
- 같은 패키지 안에 파일명이 중복되는 Dart 파일을 두지 않는다.
- 고정 설정 `Dio`/codec 객체를 호출마다 새로 생성하지 않는다.

### Naming
- 새 내부 배열/목록 이름을 만들 때 `concerts`, `selectedIds`, `keywords`처럼 단순 복수형 `s` 접미사를 기본 규칙처럼 사용하지 않는다.
- 같은 역할의 컬렉션 이름에서 `List` 접미사 규칙과 단순 복수형을 혼용하지 않는다.
- 파일명에 `UpperCamelCase`나 `kebab-case`를 사용하지 않는다.
- 화면 단위 파일에 `_page`, `_view`, `_screen`을 임의로 섞어 쓰지 않는다 (`_screen`을 우선 사용한다).
- Provider 변수명에 `Provider` 접미사를 빠뜨리지 않는다.

### Region / 파일 구조
- 같은 파일 안에서 `// region` 형식과 임의의 구분 주석 형식을 혼용하지 않는다.
- `구조 템플릿 적용 파일`에 `docs/templates/mark-template.md`에 없는 region 이름을 임의로 만들지 않는다.
- 기존 `구조 템플릿 적용 파일`이 예전에 다른 region 이름을 썼다는 이유로 새 코드에도 그 이름을 복제하지 않다.

### Access Control
- 같은 파일 안에서만 쓰는 타입과 멤버를 public(`_` 없는) 이름으로 두지 않는다.
- `ViewModel`의 상태를 외부에서 직접 수정할 수 있게 setter 또는 mutable 필드로 열어 두지 않는다.
- `notifier.state = ...`를 `ViewModel` 외부에서 호출하지 않는다.

### Private Helpers
- 타입 본문 안에 의미 단위 없이 private 메서드를 길게 나열하지 않는다.
- private extension 안의 메서드에 다시 `_` 접두사를 붙이지 않는다.

### Error Handling
- 도메인 메서드의 실패 케이스를 표현하지 않은 채 `dynamic` 또는 `Object?`로 던지지 않는다.
- 잡은 예외를 그대로 무시(`catch (_) {}`)하지 않는다.

### Control Flow
- `조기 종료 조건`을 본문 안쪽 `if` 중첩으로 처리하지 않는다.
- 여러 단계의 `if` 중첩으로 깊은 중첩을 만들지 않는다.

## Exception
- `구조 템플릿 적용 파일`에서 `필요한 섹션`이 2개 이하면 region 주석을 생략할 수 있다.
- 외부 패키지의 콜백 시그니처가 nullable 또는 specific 타입을 강제하는 경우 그 시그니처를 그대로 따른다.
- 외부 SDK, 시스템 API, 서버 응답 모델, 서드파티 타입 이름은 원래 시그니처와 계약을 우선 따른다.
- 생성 코드(`build_runner`로 생성된 `*.g.dart`, `*.freezed.dart`)는 도구 출력 형식을 우선 따른다.
- 한 번의 예외로 템플릿 밖 region 이름이나 미정의 에러 패턴 사용을 다른 내부 API로 확장하지 않는다.
- `Set`, `Map`처럼 자료구조 또는 키 기반 매핑 의미가 이름의 핵심인 경우에는 `List` 접미사를 강제하지 않는다.

## Checklist
### File Structure
- `dart:` import와 `package:flutter/...` import 사이에 한 줄이 비어 있는지 확인한다.
- `package:flutter/...` import와 `로컬 import` 사이에 한 줄이 비어 있는지 확인한다.
- `로컬 import`와 `외부 패키지 import` 사이에 한 줄이 비어 있는지 확인한다.
- `flutter_riverpod` import가 `외부 패키지 import` 블록의 맨 위에 위치하는지 확인한다.
- 기존 Dart 파일의 헤더 주석을 임의로 바꾸지 않았는지 확인한다.
- 새 Dart 파일의 헤더가 같은 디렉터리의 기존 파일 형식을 따르는지 확인한다.
- 작성자 이름에 실제 사용자 이름만 사용했고, 에이전트 이름이나 추측한 이름을 넣지 않았는지 확인한다.
- `View 파일`에서 보조 위젯과 계산값이 private 메서드/extension/별도 private 클래스로 내려가 있는지 확인한다.
- `ViewModel 파일`에서 내부 처리 로직이 private 메서드로 내려가 있는지 확인한다.
- `ViewModel 파일`에 ViewModel 클래스 1개와 그 Provider 1개만 있는지 확인한다.
- 같은 패키지 안에 파일명 중복이 없는지 확인한다.
- 고정 설정 `Dio`/codec 객체를 재사용하고 있는지 확인한다.

### Naming
- 파일명이 `snake_case.dart` 형식을 따르는지 확인한다.
- 화면 단위 파일이 `_screen.dart` 접미사를 사용했는지 확인한다.
- ViewModel 파일이 `_view_model.dart`, Service가 `_service.dart`, Repository가 `_repository.dart` 접미사를 사용했는지 확인한다.
- Provider 변수명이 `<대상>Provider` 형식을 따르는지 확인한다.
- 새 배열/목록 이름에 프로젝트 관례대로 `List` 접미사를 사용했는지 확인한다.
- 같은 역할의 컬렉션 이름에서 `List` 접미사 규칙과 단순 복수형을 혼용하지 않았는지 확인한다.

### Region / 파일 구조
- region 주석이 항상 `// region <섹션명>` ~ `// endregion` 쌍 형식인지 확인한다.
- `구조 템플릿 적용 파일`에서 `필요한 섹션`이 3개 이상이면 region 주석을 썼는지 확인한다.
- `구조 템플릿 적용 파일`의 region 이름과 순서가 `docs/templates/mark-template.md`와 일치하는지 확인한다.

### Access Control
- 같은 파일에서만 쓰는 식별자에 `_` 접두사를 사용했는지 확인한다.
- 상속 의도가 없는 클래스에 `final class` 등 적절한 modifier를 사용했는지 확인한다.
- `ViewModel`의 상태가 외부에서 직접 수정 불가능한지 확인한다.
- `notifier.state = ...`가 `ViewModel` 내부에서만 호출되는지 확인한다.

### Private Helpers
- 타입 내부의 private 메서드가 의미 단위로 묶여 있는지 확인한다.
- private extension 안의 메서드에 다시 `_` 접두사를 붙이지 않았는지 확인한다.

### Error Handling
- 도메인 실패 가능 API가 도메인 Exception 또는 `Either`/`Result`를 사용하고 있는지 확인한다.
- `AsyncNotifier`가 실패를 `AsyncError`로 노출하고 있는지 확인한다.
- 외부 예외를 도메인 실패로 매핑하고 있는지 확인한다.

### Control Flow
- `조기 종료 조건`을 함수 초반에 정리했는지 확인한다.
- 여러 단계의 조건문이 조기 반환이나 보조 메서드 분리 없이 깊게 중첩되지 않았는지 확인한다.
