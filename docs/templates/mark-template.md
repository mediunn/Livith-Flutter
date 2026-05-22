# 파일 구조 템플릿

## Purpose
- 이 저장소에서 Dart 파일의 region 주석과 내부 구성을 일관되게 작성하기 위한 템플릿이다.
- 파일 종류별로 사용할 region 이름과 권장 순서를 고정한다.

## Common Rules
- region 주석은 항상 `// region <섹션명>` ~ `// endregion` 쌍으로 작성한다.
- 같은 역할에는 같은 region 이름만 쓴다.
- 허용 목록 밖의 새 region 이름을 만들지 않는다.
- 여러 선언을 담는 명사형 region 이름은 복수형을 사용한다.
- 단일 개념이나 역할을 나타내는 region 이름은 단수형을 허용한다.
- 템플릿 허용 목록 기준으로 필요한 region 섹션이 2개 이하면 region 주석을 생략할 수 있다.
- 내부 구현 메서드는 같은 파일의 private extension 또는 별도 private 클래스로 모은다.
- private extension 안의 메서드 이름에 다시 `_`를 붙이지 않는다.

## View File
- 허용 region: `Fields`, `Constructor`, `Build`, `Computed Values`, `UI Builders`, `Helpers`, `Constants`, `Literals`, `Preview`
- 권장 순서: `Fields` -> `Constructor` -> `Build` -> `Computed Values` -> `UI Builders` -> `Helpers` -> `Constants` -> `Literals` -> `Preview`
- 보조 Widget을 만들어 반환하는 메서드는 UI 조합으로 보고 `UI Builders`에 둔다.
- 순수 값 계산 getter/메서드는 `Computed Values`에 둔다.

```dart
class ExampleScreen extends ConsumerWidget {
  // region Fields
  final String title;
  // endregion

  // region Constructor
  const ExampleScreen({super.key, required this.title});
  // endregion

  // region Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exampleViewModelProvider);
    return _buildBody(context, ref, state);
  }
  // endregion
}

// region Computed Values
extension _ExampleScreenComputed on ExampleScreen {}
// endregion

// region UI Builders
extension _ExampleScreenBuilders on ExampleScreen {
  Widget _buildBody(BuildContext context, WidgetRef ref, ExampleState state) {
    return const SizedBox.shrink();
  }
}
// endregion

// region Helpers
extension _ExampleScreenHelpers on ExampleScreen {}
// endregion

// region Constants
class _Constants {
  static const double cornerRadius = 12;
}
// endregion

// region Literals
class _Literals {
  static const String title = '타이틀';
}
// endregion
```

## ViewModel File
- 허용 region: `Provider`, `State`, `ViewModel`, `Public Interface`, `State Mutations`, `Helpers`
- 권장 순서: `Provider` -> `State` -> `ViewModel` -> `Public Interface` -> `State Mutations` -> `Helpers`
- `Provider`에는 해당 `NotifierProvider` 또는 `AsyncNotifierProvider` 선언만 둔다.
- 외부에 노출되는 메서드(사용자 액션, 데이터 로드 트리거 등)는 `Public Interface`에 둔다.
- 상태 변경(`state = ...`)을 수행하는 메서드는 `State Mutations`에 둔다.

```dart
// region Provider
final exampleViewModelProvider =
    NotifierProvider.autoDispose<ExampleViewModel, ExampleState>(
  ExampleViewModel.new,
);
// endregion

// region State
class ExampleState {
  const ExampleState({this.items = const [], this.isLoading = false});

  final List<String> items;
  final bool isLoading;

  ExampleState copyWith({List<String>? items, bool? isLoading}) {
    return ExampleState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
// endregion

// region ViewModel
final class ExampleViewModel extends AutoDisposeNotifier<ExampleState> {
  @override
  ExampleState build() => const ExampleState();

  // region Public Interface
  Future<void> load() async {
    _setLoading(true);
    final result = await ref.read(exampleServiceProvider).fetch();
    _emit(state.copyWith(items: result, isLoading: false));
  }
  // endregion
}
// endregion

// region State Mutations
extension _ExampleViewModelMutations on ExampleViewModel {
  void _emit(ExampleState next) => state = next;
  void _setLoading(bool value) => state = state.copyWith(isLoading: value);
}
// endregion

// region Helpers
extension _ExampleViewModelHelpers on ExampleViewModel {}
// endregion
```

## AsyncNotifier File
- 비동기 초기 로딩이 있는 ViewModel은 `AsyncNotifier<T>`/`AutoDisposeAsyncNotifier<T>`를 사용한다.
- 같은 region 이름을 그대로 사용하되, `build` 본문이 `Future`를 반환하고 `state` 타입이 `AsyncValue<T>`임에 유의한다.

```dart
// region Provider
final concertListViewModelProvider =
    AsyncNotifierProvider.autoDispose<ConcertListViewModel, List<Concert>>(
  ConcertListViewModel.new,
);
// endregion

// region ViewModel
final class ConcertListViewModel
    extends AutoDisposeAsyncNotifier<List<Concert>> {
  @override
  Future<List<Concert>> build() async {
    return ref.read(concertRepositoryProvider).fetchAll();
  }

  // region Public Interface
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(concertRepositoryProvider).fetchAll(),
    );
  }
  // endregion
}
// endregion
```

## Disallowed Names
- `Private`
- `Helper`
- `Helper Method`
- `Private Methods`
- `UI Components`
- `Public Methods`
- `Intent`
- `Event`
