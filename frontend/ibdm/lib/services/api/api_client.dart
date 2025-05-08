import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
import 'package:cookie_jar/cookie_jar.dart' show FileStorage, PersistCookieJar;
import 'package:ibdm/services/api_django/api_client/export.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:universal_html/html.dart' as uhtml;
import 'package:open_filex/open_filex.dart';
import 'package:flutter/material.dart';

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
    dio.options.baseUrl = ApiConfig.base_url;
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';
    dio.options.extra["withCredentials"] = true;
    dio.interceptors.add(TestInterceptor());
    dio.interceptors.add(CsrfInterceptor());
    //dio.interceptors.add(RoleFixInterceptor());

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
        ByteData caCert = await rootBundle.load('assets/certificates/CA.pem');
        // trust CA
        dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
          SecurityContext sc = SecurityContext();
          sc.setTrustedCertificatesBytes(Uint8List.view(caCert.buffer));
          HttpClient client = HttpClient(context: sc);
          return client;
        });
      }
    }
    //dio.interceptors.add(CsrfInterceptor());
    dio.interceptors.add(EnumFixInterceptor());

    printMessage("ApiClientInstance: Initialized");
  }

  static Future<IbdmApiClient> getApiClient() async {
    await init();
    return IbdmApiClient(
      dio,
      baseUrl: ApiConfig.base_url,
    );
  }
}

class CsrfInterceptor extends Interceptor {
  final headerName = "X-CSRFToken";
  final cookieName = "csrftoken";
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printMessage("CsrfInterceptor: Start");

    Map<String, String> getCookies() {
      String cookieStr = "";
      if (kIsWeb) {
        cookieStr = uhtml.document.cookie ?? "";
      } else {
        cookieStr = options.headers['cookie'] ?? "";
      }

      //logger.d("Cookies: $cookieStr");
      final regexCookieNameAndValueExtractor = RegExp(r'(\w+)=([^;]+)');

      final matches = regexCookieNameAndValueExtractor.allMatches(cookieStr);
// Map to store the cookies
      Map<String, String> cookies = {};
      for (var match in matches) {
        String cookieName = match.group(1)!;
        String cookieValue = match.group(2)!;
        cookies[cookieName] = cookieValue;
      }

      // Print the cookies map
      //printMessage(cookies);
      return cookies;
    }

    final cookies = getCookies();
    if (cookies.containsKey(cookieName) && cookies[cookieName] != null) {
      options.headers[headerName] = cookies[cookieName];
      printMessage("CsrfInterceptor: Added Header '$headerName'");
    }
    printMessage("CsrfInterceptor: End");
    super.onRequest(options, handler);
  }
}

extension DownloadFile on IbdmApiClient {
  Future<void> downloadFile({
    required BuildContext context,
    required String url,
    required String fileName,
  }) async {
    String filePath = "";

    if (kIsWeb) {
      // Gestion pour le Web
      final anchorElement = uhtml.AnchorElement(href: url)
        ..download = url
        ..click();
      filePath = "Téléchargé via le navigateur";
    } else {
      try {
        // Gestion pour Windows & iOS & Android
        Directory directory;
        if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else if (Platform.isWindows) {
          directory =
              await getDownloadsDirectory() ?? await getTemporaryDirectory();
        } else if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory() ??
              await getTemporaryDirectory();
        } else {
          throw Exception("Plateforme non supportée !");
        }

        filePath = "${directory.path}/$fileName";
        Dio dio = Dio();
        // download file
        await dio.download(url, filePath);
        // Open File after download
        if (Platform.isWindows) {
          Process.run('explorer.exe', [directory.path]);
        } else if (Platform.isAndroid) {
          OpenFilex.open(filePath);
        } else if (Platform.isIOS) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Fichier enregistré dans : ${directory.path}")),
          );
        }
      } catch (e) {
        filePath = "Erreur de téléchargement : $e";
      }
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fichier téléchargé : $filePath"),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }
}

extension DownloadCertificate on IbdmApiClient {
  void downloadCertificate(BuildContext context) async {
    final api = await ApiClientInstance.getApiClient();
    if (kIsWeb) {
      if (context.mounted) {
        await api.downloadFile(
            context: context, url: ApiConfig.ca_url, fileName: "ibdm_ca.crt");
      }
    } else {
      if (context.mounted) {
        await api.downloadFile(
          context: context,
          url: ApiConfig.ca_url,
          fileName: "ibdm_ca.crt",
        );
      }
    }
  }
}

extension WebUsersFixedApis on IbdmApiClient {
  Future<User> addUsersOnWeb({
    required String email,
    required String role,
    String? firstName,
    String? lastName,
    String? username,
    String? password,
    String? phoneNumber,
    List<int>? userPermissions,
    Uint8List? avatar,
    String? avatarFileName = "avatar.jpg",
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
    final _data = FormData();
    _data.fields.add(MapEntry(
      'email',
      email,
    ));
    _data.fields.add(MapEntry(
      'role',
      role,
    ));
    if (firstName != null) {
      _data.fields.add(MapEntry(
        'first_name',
        firstName,
      ));
    }
    if (lastName != null) {
      _data.fields.add(MapEntry(
        'last_name',
        lastName,
      ));
    }
    if (username != null) {
      _data.fields.add(MapEntry(
        'username',
        username,
      ));
    }
    if (password != null) {
      _data.fields.add(MapEntry(
        'password',
        password,
      ));
    }
    if (phoneNumber != null) {
      _data.fields.add(MapEntry(
        'phone_number',
        phoneNumber,
      ));
    }
    if (avatar != null) {
      _data.files.add(MapEntry(
        'avatar',
        MultipartFile.fromBytes(avatar, filename: avatarFileName),
      ));
    }
    if (userPermissions != null) {
      _data.files.add(MapEntry(
          'user_permissions',
          MultipartFile.fromBytes(
            userPermissions,
            filename: null,
          )));
    }
    if (userPermissions != null) {
      _data.files.add(MapEntry(
          'user_permissions',
          MultipartFile.fromBytes(
            userPermissions,
            filename: null,
          )));
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
    final _options = _setStreamType<User>(Options(
      method: 'POST',
      headers: headers,
      extra: extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          ApiClientInstance.dio.options,
          '/api/v1/user-management/users/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          ApiClientInstance.dio.options.baseUrl,
          ApiConfig.base_url,
        )));
    logger.i("addUsersOnWeb: options");
    final result =
        await ApiClientInstance.dio.fetch<Map<String, dynamic>>(_options);

    //final result = await ApiClientInstance.dio.fetch(options);

    logger.i("addUsersOnWeb: fetched");
    late User value;
    try {
      value = User.fromJson(result.data!);
    } on Object catch (e, s) {
      //errorLogger?.logError(e, s, options);
      logger.e("add users web failed", stackTrace: s, error: e);
      rethrow;
    }
    logger.d("addUsersOnWeb: End");
    return value;
  }

  Future<User> partialUpdateUserOnWeb({
    required int id,
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? password,
    String? phoneNumber,
    Uint8List? avatar,
    String? role,
    List<int>? userPermissions,
    String? avatarFileName,
  }) async {
    logger.e("avatar: ${avatar}");
    if (avatar != null && avatarFileName == null) {
      throw Exception(
          "partialUpdateUserOnWeb: avatarFileName must be provided when avatar is provided");
    }
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    if (firstName != null) {
      _data.fields.add(MapEntry(
        'first_name',
        firstName,
      ));
    }
    if (lastName != null) {
      _data.fields.add(MapEntry(
        'last_name',
        lastName,
      ));
    }
    if (username != null) {
      _data.fields.add(MapEntry(
        'username',
        username,
      ));
    }
    if (email != null) {
      _data.fields.add(MapEntry(
        'email',
        email,
      ));
    }
    if (password != null) {
      _data.fields.add(MapEntry(
        'password',
        password,
      ));
    }
    if (phoneNumber != null) {
      _data.fields.add(MapEntry(
        'phone_number',
        phoneNumber,
      ));
    }
    if (avatar != null) {
      if (avatar != null) {
        logger.d("avatar in api request: ${avatar} ${avatarFileName}");
        _data.files.add(MapEntry(
          'avatar',
          MultipartFile.fromBytes(avatar, filename: avatarFileName),
        ));
      }
    }
    if (role != null) {
      _data.fields.add(MapEntry(
        'role',
        role,
      ));
    }
    if (userPermissions != null) {
      _data.files.add(MapEntry(
          'user_permissions',
          MultipartFile.fromBytes(
            userPermissions,
            filename: null,
          )));
    }
    final _options = _setStreamType<User>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
        .compose(
          ApiClientInstance.dio.options,
          '/api/v1/user-management/users/${id}/',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(
            baseUrl: _combineBaseUrls(
          ApiClientInstance.dio.options.baseUrl,
          ApiConfig.base_url,
        )));
    final _result =
        await ApiClientInstance.dio.fetch<Map<String, dynamic>>(_options);
    late User _value;
    try {
      _value = User.fromJson(_result.data!);
    } on Object catch (e, s) {
      logger.e("partialUpdateUserOnWeb failed", stackTrace: s, error: e);
      //errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
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

class EnumFixInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printMessage("EnumFixInterceptor: Start");
    checkEnumFromQuery(options, "report_type", ReportType.values);
    if (options.data is FormData) {
      checkEnumFromForm(options, "monitored_value", AlertEnum.values);
      checkEnumFromForm(options, "rapport", RapportEnum.values);
      checkEnumFromForm(options, "interval", IntervalEnum.values);
    }
    printMessage("EnumFixInterceptor: Finished");
    super.onRequest(options, handler);
  }

  /* void checkEnumFromMap(RequestOptions options, String fieldName, List values) {
    if (options.data.containsKey(fieldName)) {
      dynamic v = null;
      for (dynamic item in values) {
        if (getTypeSafeName(item) == options.data[fieldName]) {
          v = getTypeSafeJson(item);
          break;
        }
      }
      options.data.fields[fieldName] = v;
    }
  } */

  String getTypeSafeName(dynamic r) {
    if (r is RapportEnum) return r.name;
    if (r is AlertEnum) return r.name;
    if (r is IntervalEnum) return r.name;
    if (r is ReportType) return r.name;
    throw ("EnumFixInterceptor: Type not found");
  }

  String? getTypeSafeJson(dynamic r) {
    if (r is RapportEnum) return r.json;
    if (r is AlertEnum) return r.json;
    if (r is IntervalEnum) return r.json;
    if (r is ReportType) return r.json;
    throw ("EnumFixInterceptor: Type not found");
  }

  void checkEnumFromQuery(
      RequestOptions options, String fieldName, List values) {
    if (options.queryParameters.containsKey(fieldName)) {
      printMessage("EnumFixInterceptor: request has $fieldName field");
      dynamic v = null;
      for (dynamic item in values) {
        if (getTypeSafeName(item) == options.queryParameters[fieldName]) {
          v = getTypeSafeJson(item);
          break;
        }
      }
      if (v != null) {
        options.queryParameters[fieldName] = v;
      }
    }
  }

  void checkEnumFromForm(
      RequestOptions options, String fieldName, List values) {
    if (_hasField((options.data as FormData).fields, fieldName)) {
      printMessage("EnumFixInterceptor: request has $fieldName field");
      for (var e in (options.data as FormData).fields) {
        if (e.key == fieldName) {
          printMessage(
              "EnumFixInterceptor: Found $fieldName field with value: ${e.value}");
          printMessage("runtimeType: ${values.runtimeType}");

          dynamic v = null;

          for (dynamic item in values) {
            if (getTypeSafeName(item) == e.value) {
              v = item;
              break;
            } else if (getTypeSafeJson(item) == e.value) {
              v = item;
              break;
            }
          }
          printMessage("v: $v");
          MapEntry<String, String> newE =
              MapEntry(e.key, v != null ? getTypeSafeJson(v) ?? "" : "");
          (options.data as FormData)
              .fields
              .insert((options.data as FormData).fields.indexOf(e), newE);
          printMessage(
              "EnumFixInterceptor: created new $fieldName value: $newE");
          (options.data as FormData).fields.remove(e);
          printMessage(
              "EnumFixInterceptor: Changed ${e.key} from ${e.value} to ${newE.value}");
        }
      }
    }
  }

  bool _hasField(List<MapEntry<String, String>> data, String field) {
    for (var e in data) {
      if (e.key.toLowerCase() == field) {
        if (e.value.isEmpty) {
          data.remove(e);
          return false;
        }
        return true;
      }
    }
    return false;
  }
}

class TestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printMessage("Interceptor Request: ${options.uri}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    printMessage(
        "Interceptor Response: ${response.statusCode} ${response.statusMessage}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    printMessage("Interceptor Error: ${err.message} ${err.response?.data}");
    super.onError(err, handler);
  }
}
/* 
class RoleFixInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    printMessage("RoleFixInterceptor: Start");
    if (options.data is Map<String, dynamic>) {
      if (options.data.containsKey('role')) {
        options.data.fields['role'] = Role.values
            .firstWhere((role) => role.name == options.data['role'])
            .json;
      }
    } else if (options.data is FormData) {
      if (_hasRoleField((options.data as FormData).fields)) {
        printMessage("RoleFixInterceptor: request has role field");
        for (var e in (options.data as FormData).fields) {
          if (e.key == "role") {
            printMessage(
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
            printMessage("RoleFixInterceptor: created new role value: $newE");
            (options.data as FormData).fields.remove(e);
            printMessage(
                "RoleFixInterceptor: Changed ${e.key} from ${e.value} to ${newE.value}");
          }
        }
      }
    }
    printMessage("RoleFixInterceptor: Finished");
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
 */
