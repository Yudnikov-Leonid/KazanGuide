import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kazan_guide/core/navigation/go_router.dart';
import 'package:kazan_guide/core/presentation/colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routerConfig: router,
    title: 'Baru',
    scrollBehavior: const AppScrollBehavior(),
    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.green,
        backgroundColor: Colors.white,
      ),
      fontFamily: 'Montserrat',
      textTheme: Theme.of(
        context,
      ).textTheme.copyWith(bodyLarge: const TextStyle(color: Colors.black)),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey.shade300,
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.green,
        backgroundColor: Colors.black,
      ),
      fontFamily: 'Montserrat',
      textTheme: Theme.of(
        context,
      ).textTheme.copyWith(bodyLarge: const TextStyle(color: Colors.white)),
    ),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
  );
}

class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
