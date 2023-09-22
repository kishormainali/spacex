import 'dart:async';

abstract class EnvVars {
  String get baseUrl;
}

class Env implements EnvVars {
  factory Env() => _instance;

  Env._();

  static final Env _instance = Env._();

  late EnvVars _vars;

  FutureOr<void> load(EnvVars vars) => _vars = vars;

  @override
  String get baseUrl => _vars.baseUrl;
}
