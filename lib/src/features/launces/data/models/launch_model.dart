import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import 'launch_link_model.dart';

part 'launch_model.freezed.dart';
part 'launch_model.g.dart';

@Freezed(when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
class LaunchModel with _$LaunchModel {
  const LaunchModel._();

  @JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
  const factory LaunchModel({
    required String id,
    required String name,
    required String dateLocal,
    @Default(false) bool success,
    @Default(false) bool upcoming,
    required LaunchLinkModel links,
    @Default([]) List<Map<String, dynamic>> failures,
  }) = _LaunchModel;

  factory LaunchModel.fromJson(Map<String, dynamic> json) => _$LaunchModelFromJson(json);

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
