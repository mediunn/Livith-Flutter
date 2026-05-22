import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_theme.dart';
import 'package:livith/routes/app_router.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Livith',
      theme: LivithTheme.dark,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
