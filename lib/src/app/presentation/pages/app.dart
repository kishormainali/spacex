import 'package:flutter/material.dart';
import 'package:spacex/src/core/core.dart';

class App extends StatelessWidget {
  App({super.key});

  final _router = getIt<AppRouter>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SpaceX',
      theme: ThemeData(
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          background: Colors.black,
          onBackground: Colors.white,
          onPrimary: Colors.white,
        ),
      ),
      routerDelegate: _router.delegate(),
      routeInformationParser: _router.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => GestureDetector(
        onTap: () {
          /// remove any keyboard appearing on screen by tapping outside
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: child!,
      ),
    );
  }
}
