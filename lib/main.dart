import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kazan_guide/core/app.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';
import 'package:logger/logger.dart';

late Logger logger;

void mainWithFlavor(Flavor flavor, String name) {
  runZonedGuarded(
    () async {
      /// сейчас флавор не настроен на нативе
      FlavorConfig(flavor: flavor, name: name);

      logger = Logger();

      runApp(const App());
    },
    (e, st) {
      logger.e(e, stackTrace: st);
      /// TODO on error
    },
  );
}
