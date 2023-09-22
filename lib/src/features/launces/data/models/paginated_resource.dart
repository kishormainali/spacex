import 'package:freezed_annotation/freezed_annotation.dart';

import 'launch_model.dart';

part 'paginated_resource.freezed.dart';
part 'paginated_resource.g.dart';

@freezed
class PaginatedResource with _$PaginatedResource {
  const PaginatedResource._();
  const factory PaginatedResource({
    required List<LaunchModel> docs,
    required bool hasNextPage,
    required int page,
    int? prevPage,
    int? nextPage,
  }) = _PaginatedResource;
  factory PaginatedResource.fromJson(Map<String, dynamic> json) => _$PaginatedResourceFromJson(json);
}
