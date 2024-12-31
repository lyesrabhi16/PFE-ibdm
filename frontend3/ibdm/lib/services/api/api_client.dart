import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:ibdm/services/api/serializers/LoginRequest/login_request_body.dart';
import 'package:ibdm/services/api/serializers/LoginRequest/login_request_response.dart';
import 'package:ibdm/services/api/serializers/dashboard_serializer.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: 'https://10.2.60.9:8443')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/api/auth/dashboard')
  Future<DashboardSerializer> getDashboard();

  @POST('/api/auth/login')
  Future<LoginRequestResponse> login(@Body() LoginRequestBody body);

  static Future<ApiClient> getApiClient() async {
    // create Dio instance
    Dio dio = Dio();

    // set default configurations
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';

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

    return ApiClient(dio);
  }
}
