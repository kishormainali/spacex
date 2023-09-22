import 'package:freezed_annotation/freezed_annotation.dart';

part 'rocket_model.freezed.dart';
part 'rocket_model.g.dart';

@Freezed(when: FreezedWhenOptions.none, map: FreezedMapOptions.none)
class RocketModel with _$RocketModel {
  const RocketModel._();

  const factory RocketModel({
    required String id,
    required String name,
    required String country,
    required String company,
  }) = _RocketModel;
  factory RocketModel.fromJson(Map<String, dynamic> json) => _$RocketModelFromJson(json);
}
