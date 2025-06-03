import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:ibdm/config/api.config.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<PersistCookieJar> getCookieJar() async {
  return PersistCookieJar(
    storage: FileStorage(
      "${(await getApplicationDocumentsDirectory()).path}/.cookies/",
    ),
  );
}

getCookies() async {
  if (kIsWeb) {
    return null; // Web does not support cookies in the same way
  }
  // For non-web platforms, get them from presistCookieJar
  final cookieJar = await getCookieJar();
  final cookies = await cookieJar.loadForRequest(Uri.parse(ApiConfig.base_url));
  final cookieStr =
      cookies.map((cookie) => '${cookie.name}=${cookie.value}').join('; ');
  logger.d('Cookie: $cookieStr');
  return cookieStr;
}
