import 'package:flutter_test/flutter_test.dart';

import 'package:livith/app.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('홈 화면이 정상적으로 그려진다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Livith'), findsOneWidget);
    expect(find.text('Hello, Riverpod + MVVM!'), findsOneWidget);
  });
}
