import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/data/source/launch_remote_source.dart';

import '../../../../fixtures/reader.dart';
import '../../../../mocks/queries.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late final Dio dio;
  late final LaunchRemoteSourceImpl remoteSource;

  setUpAll(() {
    dio = MockDio();
    remoteSource = LaunchRemoteSourceImpl(dio);
  });

  group('test launch items', () {
    test('should return server exception', () async {
      /// arrange
      when(() => dio.post(any(), data: any(named: 'data'))).thenThrow(const ServerException());

      /// act
      final call = remoteSource.getLaunches;

      /// assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
    test('should return server exception when server returns data', () async {
      /// arrange
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer(
        (invocation) async => Response(
          requestOptions: RequestOptions(path: '/v5/launches/query'),
          statusCode: 400,
        ),
      );

      /// act
      final call = remoteSource.getLaunches;

      /// assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });

    test('should return paginated Launches', () async {
      /// arrange
      ///
      final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer((invocation) async => Response(
            data: fixture('launches.json'),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/v5/launches/query'),
          ));

      /// act
      final response = await remoteSource.getLaunches();

      /// assert
      /// result should be equal to paginatedResource
      verify(() => dio.post('/v5/launches/query', data: emptyQuery));
      expect(paginatedResource, equals(response));
    });

    test('should return paginated Launches when keyword is passed', () async {
      /// arrange
      ///
      final paginatedResource = PaginatedResource.fromJson(fixture('launches.json'));
      when(() => dio.post(any(), data: any(named: 'data'))).thenAnswer((invocation) async => Response(
            data: fixture('launches.json'),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/v5/launches/query'),
          ));

      /// act
      final response = await remoteSource.getLaunches(keyword: 'test');

      /// assert
      /// result should be equal to paginatedResource
      verify(() => dio.post('/v5/launches/query', data: searchQuery));
      expect(paginatedResource, equals(response));
    });
  });

  test('should return single rocket when passed to id', () async {
    /// arrange
    final rocket = RocketModel.fromJson(fixture('rocket.json'));
    const id = '5e9d0d95eda69973a809d1ec';
    when(() => dio.get(any())).thenAnswer((invocation) async => Response(
          data: fixture('rocket.json'),
          statusCode: 200,
          requestOptions: RequestOptions(path: '/v4/rockets/$id'),
        ));

    //act

    final response = await remoteSource.getRocketById(id);

    /// assert
    verify(() => dio.get('/v4/rockets/$id'));
    expect(rocket, equals(response));
  });

  test(
    'should return single launch site when id is passed',
    () async {
      /// arrange
      final site = LaunchSiteModel.fromJson(fixture('site.json'));
      const id = '5e9e4502f5090995de566f86';

      when(() => dio.get(any())).thenAnswer((invocation) async => Response(
            data: fixture('site.json'),
            statusCode: 200,
            requestOptions: RequestOptions(path: '/v4/launchpads/$id'),
          ));

      /// act
      final response = await remoteSource.getSiteById(id);

      /// assert
      verify(() => dio.get('/v4/launchpads/$id'));
      expect(site, equals(response));
    },
  );

  test('should return launch detail model', () async {
    /// arrange
    const id = '5eb87d46ffd86e000604b32a';
    final launchDetails = LaunchDetailModel.fromJson(fixture('launch.json'));
    when(() => dio.get(any())).thenAnswer((invocation) async => Response(
          data: fixture('launch.json'),
          statusCode: 200,
          requestOptions: RequestOptions(path: '/v5/launches/$id'),
        ));

    /// act
    final response = await remoteSource.getLaunchById(id);

    /// assert
    verify(() => dio.get('/v5/launches/$id'));
    expect(launchDetails, equals(response));
  });
}
