import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_link_model.freezed.dart';
part 'launch_link_model.g.dart';

@Freezed(when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
class LaunchLinkModel with _$LaunchLinkModel {
  const LaunchLinkModel._();
  const factory LaunchLinkModel({
    required LaunchPatchModel patch,
  }) = _LaunchLinkModel;
  factory LaunchLinkModel.fromJson(Map<String, dynamic> json) => _$LaunchLinkModelFromJson(json);
}

@Freezed(when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
class LaunchPatchModel with _$LaunchPatchModel {
  const LaunchPatchModel._();
  const factory LaunchPatchModel({
    @Default('') String small,
    @Default('') String large,
  }) = _LaunchPatchModel;
  factory LaunchPatchModel.fromJson(Map<String, dynamic> json) => _$LaunchPatchModelFromJson(json);
}
