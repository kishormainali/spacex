import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:rxdart/rxdart.dart';

/// helper function to debounce events
EventTransformer<Event> debounceRestartable<Event>(Duration duration) {
  return (events, mapper) => restartable<Event>().call(events.debounceTime(duration), mapper);
}
