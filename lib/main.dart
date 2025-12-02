import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';
import 'package:kazan_guide/core/app.dart';
import 'package:kazan_guide/core/di/initialize_depencies.dart';
import 'package:kazan_guide/core/error_app.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:logger/logger.dart';

late Logger logger;

/// flutter build apk -t lib/flavors/main_dev.dart --flavor dev
/// flutter build apk -t lib/flavors/main_prod.dart --flavor prod

void main({Flavor? flavor}) {
  bool isAppRunning = false;

  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();

      /// сейчас flavor настроен только на андроид, 25.08.2025
      FlavorConfig(flavor: flavor!);

      GoRouter.optionURLReflectsImperativeAPIs = true;
      usePathUrlStrategy();

      logger = Logger();

      final dependencies = await initializeDependencies();

      isAppRunning = true;
      WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();
      runApp(dependencies.inject(child: const App()));
    },
    (e, st) {
      logger.e(e, stackTrace: st);

      if (!isAppRunning) {
        WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();
        runApp(ErrorApp(error: e));
      }
    },
  );
}
