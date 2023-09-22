import 'package:fpdart/fpdart.dart';
import 'package:spacex/src/core/errors/app_error.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';

abstract class LaunchRepository {
  TaskEither<AppError, PaginatedResource> getLaunches({
    String keyword = '',
    int page = 1,
    String sort = 'asc',
  });
  TaskEither<AppError, LaunchDetailModel> getLaunchById(String id);
  TaskEither<AppError, RocketModel> getRocketById(String id);
  TaskEither<AppError, LaunchSiteModel> getSiteById(String id);
  TaskEither<AppError, LaunchDetailModel> getWithRocketAndSite(String id);
}
