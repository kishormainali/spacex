import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/data/source/launch_remote_source.dart';
import 'package:spacex/src/features/launces/domain/repository/launch_repository.dart';

@LazySingleton(as: LaunchRepository)
class LaunchRepositoryImpl implements LaunchRepository {
  const LaunchRepositoryImpl(this._remoteSource);

  final LaunchRemoteSource _remoteSource;
  @override
  TaskEither<AppError, LaunchDetailModel> getLaunchById(String id) {
    return _handleCall(_remoteSource.getLaunchById(id));
  }

  @override
  TaskEither<AppError, PaginatedResource> getLaunches({
    String keyword = '',
    int page = 1,
    String sort = 'asc',
  }) {
    return _handleCall(_remoteSource.getLaunches(
      keyword: keyword,
      page: page,
      sort: sort,
    ));
  }

  @override
  TaskEither<AppError, RocketModel> getRocketById(String id) {
    return _handleCall(_remoteSource.getRocketById(id));
  }

  @override
  TaskEither<AppError, LaunchDetailModel> getWithRocketAndSite(String id) {
    return TaskEither.Do((_) async {
      final launch = await _(getLaunchById(id));
      final rocket = await _(getRocketById(launch.rocketId));
      final site = await _(getSiteById(launch.launchSiteId));
      return launch.copyWith(rocket: rocket, site: site);
    });
  }

  @override
  TaskEither<AppError, LaunchSiteModel> getSiteById(String id) {
    return _handleCall(_remoteSource.getSiteById(id));
  }

  TaskEither<AppError, T> _handleCall<T>(Future<T> call) {
    return TaskEither.tryCatch(
      () async {
        return await call;
      },
      (error, stackTrace) {
        logger.e('ServerError', error: error, stackTrace: stackTrace);
        if (error is ApiException) {
          return switch (error) {
            ServerException(:final message) => ServerError(message: message),
            NetworkException() => const NetworkError(),
          };
        }
        return ServerError(message: error.toString());
      },
    );
  }
}
