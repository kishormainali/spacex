import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:spacex/src/features/launces/data/models/launch_site_model.dart';
import 'package:spacex/src/features/launces/data/models/rocket_model.dart';

import 'launch_link_model.dart';

part 'launch_detail_model.freezed.dart';
part 'launch_detail_model.g.dart';

@Freezed(when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
class LaunchDetailModel with _$LaunchDetailModel {
  const LaunchDetailModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory LaunchDetailModel({
    required String id,
    required String name,
    required String dateLocal,
    required String details,
    @Default(false) bool success,
    @Default(false) bool upcoming,
    required LaunchLinkModel links,
    @JsonKey(name: 'rocket') required String rocketId,
    @JsonKey(name: 'launchpad') required String launchSiteId,
    @JsonKey(includeFromJson: false, includeToJson: false) RocketModel? rocket,
    @JsonKey(includeFromJson: false, includeToJson: false) LaunchSiteModel? site,
    @Default([]) List<Map<String, dynamic>> failures,
  }) = _LaunchDetailModel;

  /// this factory constructor is used to create a fake launch detail model for testing and loading purposes
  /// it is not used in production
  ///
  factory LaunchDetailModel.fake() => LaunchDetailModel(
        id: 'FakeLaunchId',
        name: 'Fake Launch Mission Name',
        dateLocal: DateTime.now().toIso8601String(),
        details: 'Fake Launch Details',
        links: const LaunchLinkModel(
          patch: LaunchPatchModel(
            small: 'https://images2.imgbox.com/94/f2/NN6Ph45r_o.png',
            large: 'https://images2.imgbox.com/5b/02/QcxHUb5V_o.png',
          ),
        ),
        rocketId: 'Fake Rocket Id',
        launchSiteId: 'Fake Launch Site Id',
        rocket: const RocketModel(
          id: 'FakeRocketID',
          name: 'Fake Rocket Name',
          country: 'Fake Rocket Country',
          company: 'Fake Rocket Company',
        ),
        site: const LaunchSiteModel(
          id: 'FakeSiteId',
          name: 'Fake Site Name',
          fullName: 'Fake Site Full Name',
        ),
      );

  factory LaunchDetailModel.fromJson(Map<String, dynamic> json) => _$LaunchDetailModelFromJson(json);

  String get dateString => DateFormat('MMM dd, yyyy hh:mma').format(DateTime.parse(dateLocal));

  String get status {
    if (success) {
      return 'Success';
    } else if (success == false && failures.isNotEmpty) {
      return 'Failed';
    } else {
      return 'Upcoming';
    }
  }

  Color get color {
    if (success) {
      return Colors.green;
    } else if (success == false && failures.isNotEmpty) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }
}
