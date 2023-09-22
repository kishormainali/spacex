import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/presentation/blocs/details/launch_detail_cubit.dart';

import '../../../../fixtures/reader.dart';
import '../../../../mocks/launch_repository.dart';

void main() {
  late final MockLaunchRepository repository;

  setUpAll(() {
    repository = MockLaunchRepository();
  });

  group('test launch details', () {
    /// arrange
    const id = '5eb87d46ffd86e000604b32a';
    var launch = LaunchDetailModel.fromJson(fixture('launch.json'));
    final rocket = RocketModel.fromJson(fixture('rocket.json'));
    final site = LaunchSiteModel.fromJson(fixture('site.json'));

    launch = launch.copyWith(
      rocket: rocket,
      site: site,
    );

    blocTest(
      'should return nothing when created',
      build: () => LaunchDetailCubit(repository),
      expect: () => [],
    );

    blocTest(
      'should return loading and success state',
      build: () {
        when(() => repository.getWithRocketAndSite(id)).thenReturn(TaskEither.right(launch));
        return LaunchDetailCubit(repository);
      },
      act: (cubit) => cubit.getLaunchById(id),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getWithRocketAndSite(id)).called(1),
      expect: () => [
        const LaunchDetailState.loading(),
        LaunchDetailState.success(launch: launch),
      ],
    );

    blocTest(
      'should return loading and error state when server error is returned',
      build: () {
        when(() => repository.getWithRocketAndSite(id)).thenReturn(TaskEither.left(const ServerError(message: 'Something went wrong')));
        return LaunchDetailCubit(repository);
      },
      act: (cubit) => cubit.getLaunchById(id),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getWithRocketAndSite(id)).called(1),
      expect: () => [
        const LaunchDetailState.loading(),
        const LaunchDetailState.error(message: 'Something went wrong'),
      ],
    );

    blocTest(
      'should return loading and error state when network error is returned',
      build: () {
        when(() => repository.getWithRocketAndSite(id)).thenReturn(TaskEither.left(NetworkError()));
        return LaunchDetailCubit(repository);
      },
      act: (cubit) => cubit.getLaunchById(id),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getWithRocketAndSite(id)).called(1),
      expect: () => [
        const LaunchDetailState.loading(),
        const LaunchDetailState.error(message: 'Network Error'),
      ],
    );
  });
}
