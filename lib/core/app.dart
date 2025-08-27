import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kazan_guide/core/navigation/app_navigator.dart';
import 'package:kazan_guide/core/navigation/pages.dart';
import 'package:kazan_guide/core/presentation/colors.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.green,
        backgroundColor: Colors.white,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(
          context,
        ).textTheme.copyWith(bodyLarge: const TextStyle(color: Colors.black)),
      ),
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        surfaceTintColor: AppColors.green,
        backgroundColor: Colors.black,
      ),
      textTheme: GoogleFonts.montserratTextTheme(
        Theme.of(
          context,
        ).textTheme.copyWith(bodyLarge: const TextStyle(color: Colors.white)),
      ),
    ),
    themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    builder: (context, _) => const AppNavigator(initialState: [MainPage()]),
  );
}
