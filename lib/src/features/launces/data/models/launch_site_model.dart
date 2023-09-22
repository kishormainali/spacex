import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_site_model.freezed.dart';
part 'launch_site_model.g.dart';

@freezed
class LaunchSiteModel with _$LaunchSiteModel {
  const LaunchSiteModel._();
  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory LaunchSiteModel({
    required String id,
    required String name,
    required String fullName,
  }) = _LaunchSiteModel;
  factory LaunchSiteModel.fromJson(Map<String, dynamic> json) => _$LaunchSiteModelFromJson(json);
}
