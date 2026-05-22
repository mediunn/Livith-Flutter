# 아키텍처

## Purpose
- Model, View, ViewModel 사이의 책임과 의존 방향을 고정하여 변경의 영향 범위를 제한한다.
- Riverpod을 상태 관리와 의존성 주입의 단일 수단으로 사용하여 일관된 코드 구조를 유지한다.

## Scope
- 이 저장소의 모든 Dart 코드에 적용한다.
- 기능 단위로 패키지를 쪼개지 않고, `lib/` 단일 디렉터리 안에서 레이어 디렉터리로 분리한다.
- 상태 관리는 `flutter_riverpod` 으로 통일한다. 다른 상태 관리 패키지(`provider`, `bloc`, `get_it` 등)는 도입하지 않는다.
- 다음 용어는 이 문서에서 아래 의미로 사용한다.
- `Model`: 데이터 구조, 도메인 객체, DTO, 비즈니스 규칙을 담은 불변 Dart 클래스
- `View`: `Widget`을 정의하는 Dart 클래스. Riverpod을 구독해야 하면 `ConsumerWidget` 또는 `ConsumerStatefulWidget`을 상속한다.
- `ViewModel`: `Notifier<State>` 또는 `AsyncNotifier<State>`를 상속한 클래스. View가 구독하는 상태와 사용자 액션에 대응하는 메서드를 노출한다.
- `Provider`: Riverpod의 `NotifierProvider`, `AsyncNotifierProvider`, 또는 의존성을 노출하는 `Provider`
- `Service`: HTTP, 로컬 저장소, 외부 SDK 같은 외부 시스템과의 통신을 담당하는 클래스
- `Repository`: 여러 `Service`를 조합하거나 캐싱이 필요한 경우에 도메인 단위 인터페이스를 제공하는 클래스 (선택적)

## Do

### 디렉터리 구조
- 모든 앱 코드는 `lib/` 아래에 평탄한 레이어 디렉터리로 둔다.
- 디렉터리는 다음 구조를 따른다:

```
lib/
  main.dart
  app.dart
  models/         # Model 클래스, DTO, 도메인 객체
  views/          # View (Screen, Page, 재사용 컴포넌트)
    screens/      # 화면 단위 View
    widgets/      # 재사용 가능한 View 컴포넌트
  view_models/    # ViewModel (Notifier / AsyncNotifier) 및 해당 Provider
  services/       # 네트워크, 저장소, 외부 SDK 클라이언트
  repositories/   # Service 조합 레이어 (선택)
  providers/      # Service/Repository/공통 의존성을 노출하는 Provider
  routes/         # 라우팅 정의
  core/           # 상수, 테마, 유틸리티, 확장
```

- 새 화면을 추가할 때는 `views/screens/<screen_name>_screen.dart`, `view_models/<screen_name>_view_model.dart` 형태로 같은 이름을 공유한다.
- ViewModel과 그 ViewModel을 노출하는 `NotifierProvider`(또는 `AsyncNotifierProvider`)는 같은 파일에 둔다.

### 의존 방향
- `View → ViewModel → (Repository or Service) → Model` 방향으로만 의존한다.
- `View`는 `ref.watch(viewModelProvider)`로 상태를 구독하고, `ref.read(viewModelProvider.notifier).method()`로 액션을 호출한다.
- `ViewModel`은 `ref.read(serviceProvider)` 또는 `ref.read(repositoryProvider)`로 의존성을 가져온다.
- `Model`은 `flutter/material.dart`, `flutter_riverpod` 등 UI/상태관리 프레임워크에 의존하지 않는다.
- `Service`는 `Model`과 외부 패키지에만 의존한다. `flutter_riverpod`에 의존하지 않는다.

### Model
- `Model`은 불변(immutable) 클래스로 정의한다. 변경이 필요하면 `copyWith` 메서드로 새 인스턴스를 만든다.
- 등가 비교가 필요한 `Model`은 `Equatable`을 상속하거나 `==`/`hashCode`를 직접 구현한다.
- 비즈니스 규칙(검증, 계산)은 가능한 `Model` 안의 메서드로 둔다.
- DTO(서버 응답 형식)와 도메인 `Model`이 동일한 구조라면 같은 클래스를 써도 되고, 형식이 달라지면 별도 `Model`을 둔다.
- JSON 변환은 `fromJson` / `toJson` 메서드 또는 `json_serializable`로 처리한다.

### View
- `View`는 가능한 `ConsumerWidget`으로 작성한다. 로컬 UI 상태가 필요하면 `ConsumerStatefulWidget`을 사용한다.
- `View`의 `build`는 `ref.watch`로 ViewModel 상태를 구독하고, 사용자 액션은 `ref.read(...notifier).method()`로 호출한다.
- 한 화면에서 여러 상태를 사용해야 하면 `ref.watch`를 여러 번 호출한다. 큰 상태 객체를 만들어 모든 것을 한 곳에 모으지 않는다.
- 로컬 UI 상태(애니메이션, 폼 입력 임시 값, `TextEditingController`)는 `ConsumerStatefulWidget`에서 관리한다.
- `View`는 비즈니스 로직(API 호출, 데이터 변환)을 직접 수행하지 않는다.

### ViewModel
- `ViewModel`은 `Notifier<State>` 또는 `AsyncNotifier<State>`를 상속한다.
- 동기 상태는 `Notifier<State>`, 비동기 초기화/리프레시가 있는 상태는 `AsyncNotifier<State>`를 사용한다.
- `state`는 클래스 내부의 메서드에서만 변경한다. 외부에서 `notifier.state = ...`를 직접 대입하지 않는다.
- 의존성은 `ref.read(...)`로 가져오고, 생성자 파라미터로 받지 않는다 (`Notifier`는 인자 없는 생성자만 허용).
- ViewModel의 `State`는 불변 `Model` 클래스로 정의한다.
- ViewModel 파일에 해당 `NotifierProvider` / `AsyncNotifierProvider` 정의를 함께 둔다.
- 화면 간 공유되지 않는 ViewModel은 `autoDispose` 변형을 사용한다 (`NotifierProvider.autoDispose<T, S>`).
- 파라미터가 필요한 ViewModel은 `family` 변형을 사용한다.

### Service / Repository
- 네트워크, 로컬 저장소 같은 외부 의존을 다루는 코드는 모두 `Service`로 분리한다.
- `Service`는 일반 클래스로 작성하고, Riverpod에 의존하지 않는다.
- `Service`는 `lib/providers/` 또는 `lib/services/` 아래에서 `Provider<Service>`로 노출한다.
- `Repository`는 여러 `Service`를 조합하거나 캐싱이 필요한 경우에만 추가한다. 단순 1:1 래핑은 두지 않는다.
- 외부 SDK의 에러는 `Service` 또는 `Repository` 안에서 도메인 Exception(또는 `Either<Failure, T>`)으로 매핑한다.

### Provider / 의존성 주입
- 의존성은 Riverpod Provider로만 노출한다. `get_it` 같은 별도 서비스 로케이터는 도입하지 않는다.
- 공통 의존성(`Dio`, `SharedPreferences`, `FirebaseAuth` 등)은 `lib/providers/` 아래에 `Provider`로 노출한다.
- 외부 패키지의 비동기 초기화가 필요한 의존성(`SharedPreferences.getInstance()` 등)은 `FutureProvider` 또는 진입점에서 `ProviderScope`의 `overrides`로 주입한다.
- 앱 진입점은 `runApp(ProviderScope(child: const App()));` 형태로 작성한다.

### 라우팅
- 라우팅 정의는 `lib/routes/` 아래에 모은다.
- `MaterialApp.routes`, `onGenerateRoute`, 또는 `go_router` 중 어떤 것을 쓰든 라우트 경로는 상수로 분리한다 (`class Routes { static const home = '/home'; }`).
- 화면 전환 로직은 `View`의 이벤트 핸들러에서 `Navigator` 또는 라우터 API로 호출한다.
- `ViewModel`에서 화면 전환이 필요한 경우 라우터 인스턴스를 Provider로 노출하고 `ref.read(routerProvider).go(...)`로 호출한다.

### 비동기 작업 관리
- `AsyncNotifier`의 `build` 메서드에서 초기 비동기 로딩을 수행한다.
- 리프레시는 `ref.invalidateSelf()` 또는 외부에서 `ref.invalidate(viewModelProvider)`로 트리거한다.
- 진행 상태는 `AsyncValue`(`AsyncData`/`AsyncLoading`/`AsyncError`)로 표현하고, View에서 패턴 매칭으로 분기한다.
- 동일 작업이 중복 실행되면 안 되는 경우에는 `ViewModel`에 진행 플래그를 두거나 `AsyncNotifier`의 `AsyncValue.isLoading`을 활용한다.

## Don't
- `Model` 에서 `flutter/material.dart`, `flutter_riverpod`, `dio` 같은 외부 프레임워크를 import하지 않는다.
- `Service`에서 `flutter_riverpod`을 import하지 않는다 (Provider 정의 파일에서만 import한다).
- `Service`에서 `View`나 `ViewModel`을 참조하지 않는다.
- `View`에서 `Service`나 `Repository`를 직접 호출하지 않는다 (`ViewModel`을 거친다).
- `View`에서 `Model`을 직접 수정하지 않는다 (`ViewModel` 메서드를 호출한다).
- `ViewModel` 외부에서 `notifier.state = ...`로 상태를 직접 변경하지 않는다.
- DTO 전용 필드(서버 응답 키 그대로)를 `View`에 노출하지 않는다. 필요하면 도메인 `Model`로 변환한다.
- 한 화면의 비즈니스 로직을 여러 `ViewModel`로 쪼개지 않는다 (한 화면 = 한 `ViewModel`이 기본).
- `lib/features/` 같은 기능 단위 디렉터리를 새로 만들지 않는다.
- `ChangeNotifier`, `provider`, `bloc`, `get_it`을 도입하지 않는다.

## Exception
- 단순 데이터를 표시만 하는 정적인 화면은 `ViewModel` 없이 `ConsumerWidget`에서 직접 다른 Provider만 구독해 작성할 수 있다.
- 로컬 UI 상태(폼 입력 임시 값, 애니메이션 상태)는 `ViewModel`로 빼지 않고 `ConsumerStatefulWidget` 내부에서 관리한다.
- 외부 패키지가 자체 상태 관리 객체(예: `TextEditingController`, `ScrollController`)를 요구하면 `View` 내부 또는 `ViewModel` 내부 필드로 보유한다.
- 화면 간 공유 상태가 필요한 경우, 화면 단위가 아닌 전역 Provider를 만들고 `autoDispose`를 사용하지 않는다.

## Checklist
- 모든 코드가 `lib/{models,views,view_models,services,repositories,providers,routes,core}/` 아래에 위치하는가
- `View → ViewModel → Service/Repository → Model` 의존 방향이 지켜졌는가
- `Model`에 UI/상태관리 프레임워크 import가 없는가
- `Service`에 `flutter_riverpod` import가 없는가
- `ViewModel`이 `Notifier` 또는 `AsyncNotifier`를 상속하고, 외부에서 `state`를 직접 대입하지 않는가
- `View`가 `ConsumerWidget`/`ConsumerStatefulWidget`을 사용하고 `ref.watch`/`ref.read`로만 상호작용하는가
- 네트워크/저장소 코드가 `Service`로 분리되었는가
- ViewModel과 해당 Provider가 같은 파일에 있고, 화면별로 `autoDispose`를 적용했는가
- 화면 추가 시 `views/screens/<name>_screen.dart`와 `view_models/<name>_view_model.dart`의 이름이 짝을 이루는가
- `ChangeNotifier`, `provider`, `bloc`, `get_it` 등 금지된 패키지를 도입하지 않았는가
