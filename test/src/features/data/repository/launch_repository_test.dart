import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/data/repository/launch_repository_impl.dart';

import '../../../../fixtures/reader.dart';
import '../../../../mocks/launch_remote_source.dart';

void main() {
  late final MockLaunchRemoteSource remoteSource;
  late final LaunchRepositoryImpl repository;

  setUpAll(() {
    remoteSource = MockLaunchRemoteSource();
    repository = LaunchRepositoryImpl(remoteSource);
  });

  test('should return paginated launch response', () async {
    /// arrange
    final paginatedResponse = PaginatedResource.fromJson(fixture('launches.json'));
    when(remoteSource.getLaunches).thenAnswer((invocation) async => paginatedResponse);

    /// act
    final result = await repository.getLaunches().run();

    /// assert
    verify(remoteSource.getLaunches);
    expect(result, isA<Right<AppError, PaginatedResource>>());
  });

  test('should return rocket details', () async {
    /// arrange
    final rocket = RocketModel.fromJson(fixture('rocket.json'));
    const id = '5e9d0d95eda69973a809d1ec';
    when(() => remoteSource.getRocketById(any())).thenAnswer((invocation) async => rocket);

    /// act
    final result = await repository.getRocketById(id).run();

    /// assert
    verify(() => remoteSource.getRocketById(id));
    expect(result, isA<Right<AppError, RocketModel>>());
  });

  test('should return site details', () async {
    /// arrange
    final rocket = LaunchSiteModel.fromJson(fixture('site.json'));
    const id = '5e9d0d95eda69973a809d1ec';
    when(() => remoteSource.getSiteById(any())).thenAnswer((invocation) async => rocket);

    /// act
    final result = await repository.getSiteById(id).run();

    /// assert
    verify(() => remoteSource.getSiteById(id));
    expect(result, isA<Right<AppError, LaunchSiteModel>>());
  });

  test('should returns launch details with rocket and launch site', () async {
    /// arrange
    var launch = LaunchDetailModel.fromJson(fixture('launch.json'));
    const id = '5e9d0d95eda69973a809d1ec';
    when(() => remoteSource.getLaunchById(any())).thenAnswer((invocation) async => launch);

    final rocket = RocketModel.fromJson(fixture('rocket.json'));
    final rocketId = launch.rocketId;
    when(() => remoteSource.getRocketById(any())).thenAnswer((invocation) async => rocket);

    final site = LaunchSiteModel.fromJson(fixture('site.json'));
    final siteId = launch.launchSiteId;
    when(() => remoteSource.getSiteById(any())).thenAnswer((invocation) async => site);
    launch = launch.copyWith(rocket: rocket, site: site);

    /// act
    final result = await repository.getWithRocketAndSite(id).run();

    /// assert
    verify(() => remoteSource.getLaunchById(id));
    verify(() => remoteSource.getRocketById(rocketId));
    verify(() => remoteSource.getSiteById(siteId));

    expect(result, isA<Right<AppError, LaunchDetailModel>>());
  });
}
