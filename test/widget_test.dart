import 'package:flutter_test/flutter_test.dart';

import 'package:livith/app.dart';
import 'package:livith/providers/network_providers.dart';
import 'package:livith/services/token_store.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('미인증 상태로 진입하면 로그인 화면이 그려진다', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('카카오로 시작하기'), findsOneWidget);
    expect(find.text('Apple로 시작하기'), findsOneWidget);
  });
}
