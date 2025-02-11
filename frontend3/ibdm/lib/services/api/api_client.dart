import 'dart:io';
// import 'package:dio/browser.dart'; //! fails on non-web platforms
import 'package:dio/dio.dart'
    show
        Dio,
        DioException,
        ErrorInterceptorHandler,
        FormData,
        Interceptor,
        MultipartFile,
        Options,
        RequestInterceptorHandler,
        RequestOptions,
        Response,
        ResponseInterceptorHandler,
        ResponseType;
import 'package:dio_cookie_manager/dio_cookie_manager.dart' show CookieManager;
import 'package:flutter/services.dart'
    show ByteData, TargetPlatform, Uint8List, rootBundle;
import 'package:dio/io.dart' show IOHttpClientAdapter;
import 'package:flutter/foundation.dart'
    show ByteData, TargetPlatform, Uint8List, defaultTargetPlatform, kIsWeb;
import 'package:ibdm/config/api.config.dart' show ApiConfig;
import 'package:ibdm/services/api/api_client/export.dart'
    show ApiClient, IbdmApiClient, Role, RoleMapper;
import 'package:cookie_jar/cookie_jar.dart' show FileStorage, PersistCookieJar;
import 'package:ibdm/services/api/api_client/models/post_api_users_response.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
/* 
extension RoleExtension on Role {
  String get name {
    return this.json ?? this.toString().split(".").last;
  }
} */

class ApiClientInstance {
  static final dio = Dio();

  ApiClientInstance._() {
    init();
  }

  static init() async {
    // set default configurations
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.extra["withCredentials"] = true;

    dio.interceptors.add(TestInterceptor());
    dio.interceptors.add(RoleFixInterceptor());

    if (kIsWeb) {
      (dio.httpClientAdapter as dynamic).withCredentials = true;
    } else {
      final persistentCookieJar = PersistCookieJar(
        storage: FileStorage(
          "${(await getApplicationDocumentsDirectory()).path}/.cookies/",
        ),
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

    print("ApiClientInstance: Initialized");
  }

  static Future<IbdmApiClient> getApiClient() async {
    await init();
    return ApiClient(dio, baseUrl: ApiConfig.base_url).ibdmApi;
  }
}

extension WebAddUsers on IbdmApiClient {
  Future<PostApiUsersResponse> addUsersOnWeb({
    required String email,
    required String password,
    required Role role,
    Uint8List? avatar,
    String? avatarFileName = "avatar.jpg",
    String? name,
    String? phoneNumber,
    String? superiorId,
  }) async {
    if (avatar != null && avatarFileName == null) {
      throw Exception(
          "AddUsersOnWeb: avatarFileName must be provided when avatar is provided");
    }

    logger.i("addUsersOnWeb: Start");
    final extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final headers = <String, dynamic>{};
    final data = FormData();
    data.fields.add(MapEntry(
      'email',
      email,
    ));
    data.fields.add(MapEntry(
      'password',
      password,
    ));
    data.fields.add(MapEntry(
      'role',
      role.name,
    ));
    if (avatar != null) {
      data.files.add(MapEntry(
        'avatar',
        MultipartFile.fromBytes(avatar, filename: avatarFileName),
      ));
    }
    if (name != null) {
      data.fields.add(MapEntry(
        'name',
        name,
      ));
    }

    if (phoneNumber != null) {
      data.fields.add(MapEntry(
        'phone_number',
        phoneNumber,
      ));
    }
    if (superiorId != null) {
      data.fields.add(MapEntry(
        'superior_id',
        superiorId,
      ));
    }
    logger.i("addUsersOnWeb: Added all");
    /* final options = RequestOptions(
      baseUrl: ApiConfig.base_url,
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
      data: _data,
      queryParameters: queryParameters,
    ); */
    final options = _setStreamType<PostApiUsersResponse>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          ApiClientInstance.dio.options,
          '/api/users',
          queryParameters: queryParameters,
          data: data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          ApiClientInstance.dio.options.baseUrl,
          ApiConfig.base_url,
        )));
    logger.i("addUsersOnWeb: options");
    final result =
        await ApiClientInstance.dio.fetch<Map<String, dynamic>>(options);

    //final result = await ApiClientInstance.dio.fetch(options);

    logger.i("addUsersOnWeb: fetched");
    late PostApiUsersResponse value;
    try {
      value = PostApiUsersResponse.fromJson(result.data!);
    } on Object catch (e, s) {
      //errorLogger?.logError(e, s, options);
      logger.e("add users web failed", stackTrace: s, error: e);
      rethrow;
    }
    logger.d("addUsersOnWeb: End");
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print("Interceptor Error: ${err.message}");
    super.onError(err, handler);
  }
}

class RoleFixInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("RoleFixInterceptor: Start");
    if (options.data is Map<String, dynamic>) {
      if (options.data.containsKey('role')) {
        options.data.fields['role'] = Role.values
            .firstWhere((role) => role.name == options.data['role'])
            .json;
      }
    } else if (options.data is FormData) {
      if (_hasRoleField((options.data as FormData).fields)) {
        print("RoleFixInterceptor: request has role field");
        for (var e in (options.data as FormData).fields) {
          if (e.key == "role") {
            print(
                "RoleFixInterceptor: Found role field with value: ${e.value}");
            MapEntry<String, String> newE = MapEntry(
                e.key,
                Role.values.firstWhere(
                      (r) => r.name == e.value,
                      orElse: () {
                        if (Role.values.indexWhere((r) => r.json == e.value) ==
                            -1) {
                          logger.e(
                              "RoleFixInterceptor: Role value ${e.value} not found in Role Enum (name or json value)");
                          throw Exception(
                              "RoleFixInterceptor: Role value ${e.value} not found in Role Enum (name or json value)");
                        }
                        return Role.fromJson(e.value);
                      },
                    ).json ??
                    "");
            (options.data as FormData)
                .fields
                .insert((options.data as FormData).fields.indexOf(e), newE);
            print("RoleFixInterceptor: created new role value: $newE");
            (options.data as FormData).fields.remove(e);
            print(
                "RoleFixInterceptor: Changed ${e.key} from ${e.value} to ${newE.value}");
          }
        }
      }
    }
    print("RoleFixInterceptor: Finished");
    super.onRequest(options, handler);
  }

  bool _hasRoleField(List<MapEntry<String, String>> data) {
    for (var e in data) {
      if (e.key.toLowerCase() == "role") {
        return true;
      }
    }
    return false;
  }
}
