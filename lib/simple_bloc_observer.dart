import 'package:bloc/bloc.dart';
import 'package:spacex/src/core/logging/logger.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.e('BLOC ERROR ON ${bloc.runtimeType}', error: error, stackTrace: stackTrace);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.d('BLOC CHANGE ON ${bloc.runtimeType} ::: CURRENT STATE: ${change.currentState} ::: NEXT STATE: ${change.nextState}');
  }
}
