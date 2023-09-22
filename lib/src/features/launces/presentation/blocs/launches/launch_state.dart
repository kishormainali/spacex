part of 'launch_bloc.dart';

@freezed
class LaunchState with _$LaunchState {
  const factory LaunchState.initial() = _Initial;
  const factory LaunchState.loading() = _Loading;
  const factory LaunchState.error({required String message}) = _Error;
  const factory LaunchState.success({
    required List<LaunchModel> launches,
    @Default(false) bool isFetching,
  }) = _Success;
}
