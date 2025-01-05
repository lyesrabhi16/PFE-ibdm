import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/services/api/api_client/export.dart';

class ApiClientInstance {
  ApiClientInstance._();
  static Future<IbdmApiClient> getApiClient() async {
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

    return ApiClient(dio, baseUrl: ApiConfig.base_url).ibdmApi;
  }
}
