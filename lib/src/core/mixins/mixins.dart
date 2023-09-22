import 'dart:async';

mixin CompleterMixin {
  Completer _completer = Completer();

  /// complete the completer
  void complete() {
    if (!_completer.isCompleted) _completer.complete();
    _completer = Completer();
  }

  /// returns future of completer
  Future<void> get future => _completer.future;
}
