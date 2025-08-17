import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kazan_guide/core/app.dart';

void main() {
  runZonedGuarded(() async {
    // WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();

    runApp(const App());
  }, (error, st) {
    /// TODO on error
  });
}