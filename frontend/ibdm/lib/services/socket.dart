import 'package:flutter/foundation.dart';
import 'package:ibdm/services/cookies.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

dynamic getWebSocketChannel(String url) async {
  if (kIsWeb) {
    return WebSocketChannel.connect(Uri.parse(url));
  }
  return IOWebSocketChannel.connect(Uri.parse(url), headers: {
    'cookie': await getCookies() ?? '',
  });
}
