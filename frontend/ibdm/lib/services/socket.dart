import 'package:flutter/foundation.dart';
import 'package:ibdm/services/cookies.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

dynamic getWebSocketChannel(String url) async {
  if (kIsWeb) {
    return WebSocketChannel.connect(Uri.parse(url));
  }
  final cookies = await getCookies();
  final cookiesMap = getCookiesMap(cookies);
  print("Cookies Map: $cookiesMap");
  return IOWebSocketChannel.connect(Uri.parse(url), headers: {
    'cookie': await getCookies() ?? '',
    'X-Csrftoken': cookiesMap["csrftoken"] ?? '',
  });
}

Map<String, String> getCookiesMap(cookieStr) {

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
      return cookies;
    }
