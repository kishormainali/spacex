part of 'launch_detail_cubit.dart';

@freezed
class LaunchDetailState with _$LaunchDetailState {
  const factory LaunchDetailState.initial() = _Initial;
  const factory LaunchDetailState.loading() = _Loading;
  const factory LaunchDetailState.error({required String message}) = _Error;
  const factory LaunchDetailState.success({
    required LaunchDetailModel launch,
  }) = _Success;
}
