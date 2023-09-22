import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';

abstract class LaunchRemoteSource {
  Future<PaginatedResource> getLaunches({
    String keyword = '',
    int page = 1,
    String sort = 'asc',
  });

  Future<LaunchDetailModel> getLaunchById(String id);

  Future<RocketModel> getRocketById(String id);

  Future<LaunchSiteModel> getSiteById(String id);
}

@LazySingleton(as: LaunchRemoteSource)
class LaunchRemoteSourceImpl implements LaunchRemoteSource {
  const LaunchRemoteSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<LaunchDetailModel> getLaunchById(String id) async {
    return _handleCall(_dio.get('/v5/launches/$id'), (data) => LaunchDetailModel.fromJson(data));
  }

  @override
  Future<RocketModel> getRocketById(String id) {
    return _handleCall(_dio.get('/v4/rockets/$id'), (data) => RocketModel.fromJson(data));
  }

  @override
  Future<LaunchSiteModel> getSiteById(String id) {
    return _handleCall(_dio.get('/v4/launchpads/$id'), (data) => LaunchSiteModel.fromJson(data));
  }

  @override
  Future<PaginatedResource> getLaunches({
    String keyword = '',
    int page = 1,
    String sort = 'asc',
  }) {
    return _handleCall(
      _dio.post('/v5/launches/query', data: _buildQuery(keyword, page, sort)),
      (data) => PaginatedResource.fromJson(data),
    );
  }

  /// builds query for launches
  Map<String, dynamic> _buildQuery(
    String keyword,
    int page,
    String sort,
  ) {
    return {
      'query': keyword.trim().isNotEmpty
          ? {
              '\$text': {
                '\$search': '"${keyword.trim()}"',
              }
            }
          : {},
      'options': {
        'limit': 10,
        'page': page,
        'select': {
          'name': 1,
          'date_local': 1,
          'success': 1,
          'failures': 1,
          'upcoming': 1,
          'links.patch': 1,
        },
        'sort': {
          'date_local': sort,
        },
      },
    };
  }

  /// handles network calls and throws exceptions
  Future<T> _handleCall<T>(Future<Response> call, T Function(dynamic data) onData) async {
    try {
      final response = await call;
      if (response.statusCode == 200) {
        return onData(response.data);
      } else {
        throw ServerException(message: response.statusMessage ?? 'Something went wrong');
      }
    } on DioException catch (dioError) {
      return switch (dioError.type) {
        DioExceptionType.connectionError => throw const NetworkException(),
        _ => throw ServerException(message: dioError.message ?? 'Something went wrong'),
      };
    } catch (e, stackTrace) {
      logger.e('ERROR', error: e, stackTrace: stackTrace);
      if (e is DioException) rethrow;
      throw ServerException(message: e.toString());
    }
  }
}
