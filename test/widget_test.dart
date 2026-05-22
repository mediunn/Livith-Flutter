import 'package:flutter_test/flutter_test.dart';

import 'package:livith/app.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('앱 진입 시 디자인시스템 미리보기 화면이 그려진다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));

    expect(find.text('Design System'), findsOneWidget);
    expect(find.text('Colors'), findsOneWidget);
    expect(find.text('Typography'), findsOneWidget);
  });
}
