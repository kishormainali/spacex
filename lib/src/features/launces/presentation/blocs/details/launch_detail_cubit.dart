import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/domain/repository/launch_repository.dart';

part 'launch_detail_cubit.freezed.dart';
part 'launch_detail_state.dart';

@injectable
class LaunchDetailCubit extends Cubit<LaunchDetailState> {
  LaunchDetailCubit(this._repository) : super(const LaunchDetailState.initial());
  final LaunchRepository _repository;

  void getLaunchById(String id) async {
    emit(const LaunchDetailState.loading());
    final result = await _repository.getWithRocketAndSite(id).run();
    result.fold(
      (error) => emit(LaunchDetailState.error(message: error.toString())),
      (launch) => emit(LaunchDetailState.success(launch: launch)),
    );
  }
}
