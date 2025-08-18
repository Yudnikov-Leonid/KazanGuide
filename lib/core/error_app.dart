import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kazan_guide/core/presentation/KButton.dart';
import 'package:kazan_guide/flavors/flavor_config.dart';

/// переписать, чтобы можно было сделать повторную попытку. Но пока приложение
/// слишком маленькое, чтобы инициализация могла выдавать ошибку
class ErrorApp extends StatelessWidget {
  const ErrorApp({required this.error, super.key});

  final Object error;

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    builder:
        (context, _) => Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ошибка при инициализации${FlavorConfig.isDev() ? ': $error' : ''}',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  KButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('Закрыть'),
                  ),
                ],
              ),
            ),
          ),
        ),
  );
}
