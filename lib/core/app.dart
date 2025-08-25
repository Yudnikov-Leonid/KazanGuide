import 'package:flutter/material.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppNavigator _navigator;

  @override
  void initState() {
    _navigator = const AppNavigator(initialState: [MainPage()]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    builder: (context, _) => _navigator,
  );
}
