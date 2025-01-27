import 'dart:io';

import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/services.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client/export.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiClientInstance {
  ApiClientInstance._();
  static Future<IbdmApiClient> getApiClient() async {
    // create Dio instance
    Dio dio = Dio();

    // set default configurations
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.extra["withCredentials"] = true;

    dio.interceptors.add(TestInterceptor());

    if (kIsWeb) {
      BrowserHttpClientAdapter browserHttpClientAdapter =
          BrowserHttpClientAdapter();

      dio.httpClientAdapter = browserHttpClientAdapter;
    } else {
      final persistentCookieJar = PersistCookieJar(
        ignoreExpires: true,
      );
      dio.interceptors.add(CookieManager(persistentCookieJar));

      // trust CA on Android app (android only)
      if (defaultTargetPlatform == TargetPlatform.android) {
        // get CA certificate
        ByteData caCert = await rootBundle.load('assets/certificates/myCA.pem');
        // trust CA
        dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
          SecurityContext sc = SecurityContext();
          sc.setTrustedCertificatesBytes(Uint8List.view(caCert.buffer));
          HttpClient client = HttpClient(context: sc);
          return client;
        });
      }
    }

    return ApiClient(dio, baseUrl: ApiConfig.base_url).ibdmApi;
  }
}

class TestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("Interceptor Request: ${options.uri}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("Interceptor Response: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("Interceptor Error: ${err.message}");
    super.onError(err, handler);
  }
}
