import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:spacex/src/app/app.dart';
import 'package:spacex/src/core/config/config.dart';
import 'package:spacex/src/core/di/injector.dart';
import 'package:spacex/src/core/logging/logger.dart';

import 'simple_bloc_observer.dart';

void bootstrap() {
  runZonedGuarded(
    () async {
      /// bindings should be initialized in same zone
      WidgetsFlutterBinding.ensureInitialized();

      /// add observer to monitor bloc changes
      Bloc.observer = SimpleBlocObserver();

      /// load environment variables
      await Env().load(DevelopmentEnv());

      /// configure dependency injection
      await configureInjection();

      /// run app
      runApp(App());
    },
    (error, stack) {
      logger.e('Zoned Errors', error: error, stackTrace: stack);
      runApp(_ErrorApp(
        error: error,
        stack: stack,
      ));
    },
  );
}

class _ErrorApp extends StatelessWidget {
  const _ErrorApp({
    required this.error,
    required this.stack,
  });

  final Object error;
  final StackTrace stack;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            '$error\n\n$stack',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
