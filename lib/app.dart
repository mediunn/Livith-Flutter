import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_theme.dart';
import 'package:livith/routes/routes.dart';
import 'package:livith/views/screens/design_system_preview_screen.dart';
import 'package:livith/views/screens/home_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Livith',
      theme: LivithTheme.dark,
      initialRoute: Routes.designSystemPreview,
      routes: {
        Routes.home: (_) => const HomeScreen(),
        Routes.designSystemPreview: (_) => const DesignSystemPreviewScreen(),
      },
    );
  }
}
