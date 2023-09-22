import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:spacex/src/core/core.dart';

@module
abstract class Modules {
  @lazySingleton
  Dio get dio => Dio(
        BaseOptions(
          baseUrl: Env().baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      )
        ..httpClientAdapter = Http2Adapter(
          ConnectionManager(
            idleTimeout: const Duration(seconds: 30),
            onClientCreate: (_, config) => config.onBadCertificate = (_) => false,
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            request: false,
            requestBody: kDebugMode,
            responseBody: kDebugMode,
            requestHeader: false,
            responseHeader: false,
            logPrint: logger.d,
          ),
        );
}
