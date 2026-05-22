import 'package:flutter/material.dart';

import 'package:livith/routes/routes.dart';
import 'package:livith/views/screens/home_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Livith',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: Routes.home,
      routes: {
        Routes.home: (_) => const HomeScreen(),
      },
    );
  }
}
