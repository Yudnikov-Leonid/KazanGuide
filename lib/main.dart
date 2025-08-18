import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kazan_guide/core/app.dart';
import 'package:kazan_guide/core/di/initialize_depencies.dart';
import 'package:kazan_guide/core/error_app.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:logger/logger.dart';

late Logger logger;

void mainWithFlavor(Flavor flavor, String name) {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized().deferFirstFrame();

      /// сейчас флавор не настроен на нативе
      FlavorConfig(flavor: flavor, name: name);

      logger = Logger();

      final dependencies = await initializeDependencies();

      WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();
      runApp(dependencies.inject(child: const App()));
    },
    (e, st) {
      logger.e(e, stackTrace: st);

      WidgetsFlutterBinding.ensureInitialized().allowFirstFrame();
      runApp(ErrorApp(error: e));
    },
  );
}
