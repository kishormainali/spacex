import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/presentation/blocs/launches/launch_bloc.dart';

import '../../../../fixtures/reader.dart';
import '../../../../mocks/launch_repository.dart';

void main() {
  late final MockLaunchRepository repository;

  setUpAll(() {
    repository = MockLaunchRepository();
  });

  /// test getters

  test(
    'returns asc when sortString getter is called',
    () {
      final bloc = LaunchBloc(repository);
      expect(bloc.sortString, 'asc');
    },
  );

  test(
    'returns instance of text editing controller when searchController getter is called',
    () {
      final bloc = LaunchBloc(repository);
      expect(bloc.searchController, isA<TextEditingController>());
    },
  );

  group('test get method', () {
    final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));

    blocTest(
      'emits initial state',
      build: () => LaunchBloc(repository),
      expect: () => [],
    );

    blocTest(
      'emits loading and success state',
      build: () {
        when(() => repository.getLaunches()).thenReturn(
          TaskEither.right(paginatedResource),
        );
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.get(),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches()).called(1),
      expect: () => [
        const LaunchState.loading(),
        LaunchState.success(launches: paginatedResource.docs),
      ],
    );

    blocTest(
      'should return error state',
      build: () {
        when(() => repository.getLaunches()).thenReturn(TaskEither.left(const ServerError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.get(),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches()).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Something went wrong'),
      ],
    );

    blocTest(
      'should return error state when network error is returned',
      build: () {
        when(() => repository.getLaunches()).thenReturn(TaskEither.left(const NetworkError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.get(),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches()).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Network Error'),
      ],
    );
  });

  group('test search method', () {
    final paginatedResource = PaginatedResource.fromJson(fixture('search.json'));
    const keyword = 'falcon 1';
    blocTest(
      'emits loading and success state',
      build: () {
        when(() => repository.getLaunches(keyword: keyword)).thenReturn(
          TaskEither.right(paginatedResource),
        );
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.search(keyword),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(keyword: keyword)).called(1),
      expect: () => [
        const LaunchState.loading(),
        LaunchState.success(launches: paginatedResource.docs),
      ],
    );

    blocTest(
      'should return error state',
      build: () {
        when(() => repository.getLaunches(keyword: keyword)).thenReturn(TaskEither.left(const ServerError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.search(keyword),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(keyword: keyword)).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Something went wrong'),
      ],
    );

    blocTest(
      'should return error state when network error is returned',
      build: () {
        when(() => repository.getLaunches(keyword: keyword)).thenReturn(TaskEither.left(const NetworkError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.search(keyword),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(keyword: keyword)).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Network Error'),
      ],
    );
  });

  group('test sort method', () {
    final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));
    const sort = 'desc';
    blocTest(
      'emits loading and success state',
      build: () {
        when(() => repository.getLaunches(sort: sort)).thenReturn(
          TaskEither.right(paginatedResource),
        );
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.sort(sort),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(sort: sort)).called(1),
      expect: () => [
        const LaunchState.loading(),
        LaunchState.success(launches: paginatedResource.docs),
      ],
    );

    blocTest(
      'should return error state',
      build: () {
        when(() => repository.getLaunches(sort: sort)).thenReturn(TaskEither.left(const ServerError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.sort(sort),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(sort: sort)).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Something went wrong'),
      ],
    );

    blocTest(
      'should return error state when network error is returned',
      build: () {
        when(() => repository.getLaunches(sort: sort)).thenReturn(TaskEither.left(const NetworkError()));
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.sort(sort),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(sort: sort)).called(1),
      expect: () => [
        const LaunchState.loading(),
        const LaunchState.error(message: 'Network Error'),
      ],
    );
  });

  group('test fetch more method', () {
    final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));
    final nextPageResource = PaginatedResource.fromJson(fixture('fetch_more.json'));
    const page = 2;
    final updatedData = [...paginatedResource.docs, ...nextPageResource.docs];
    blocTest(
      'emits loading and success state',
      build: () {
        when(() => repository.getLaunches(page: 1)).thenReturn(
          TaskEither.right(paginatedResource),
        );

        when(() => repository.getLaunches(page: page)).thenReturn(
          TaskEither.right(nextPageResource),
        );
        return LaunchBloc(repository)..get();
      },
      skip: 2, // skip 2 previous state from get() method to simulate there is already a success state
      act: (bloc) => bloc.fetchMore(),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches(page: page)).called(1),
      expect: () => [
        LaunchState.success(launches: paginatedResource.docs, isFetching: true),
        LaunchState.success(launches: updatedData, isFetching: false),
      ],
    );
  });

  group('test helper method', () {
    final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));
    blocTest(
      'emits success state',
      build: () {
        when(() => repository.getLaunches()).thenReturn(
          TaskEither.right(paginatedResource),
        );
        return LaunchBloc(repository);
      },
      act: (bloc) => bloc.refresh(),
      wait: const Duration(milliseconds: 500),
      verify: (_) => verify(() => repository.getLaunches()).called(greaterThanOrEqualTo(1)),
    );
  });
}
