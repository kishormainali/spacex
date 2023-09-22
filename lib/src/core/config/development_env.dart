import 'package:spacex/src/core/config/env.dart';

class DevelopmentEnv extends EnvVars {
  @override
  String get baseUrl => 'https://api.spacexdata.com';
}
