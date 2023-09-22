part of 'launch_bloc.dart';

@freezed
class LaunchEvent with _$LaunchEvent {
  const factory LaunchEvent.get({@Default(false) bool refresh}) = _Get;
  const factory LaunchEvent.search({required String keyword}) = _Search;
  const factory LaunchEvent.sort({required String sort}) = _Sort;
  const factory LaunchEvent.fetchMore() = _FetchMore;
}
