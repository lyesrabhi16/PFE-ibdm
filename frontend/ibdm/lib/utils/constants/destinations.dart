import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/utils/constants/routes.dart';

class Destination {
  final String title;
  final IconData icon;
  final String route;
  final GetPage page;
  int? index;
  Destination({
    required this.title,
    required this.icon,
    required this.route,
    required this.page,
  });

  static List<Destination> getDestinations(context) => Routes.destinations;

  static Map<String, Destination> getDestinationsMap(
    context, {
    int startIndexOffset = 0,
  }) {
    Map<String, Destination> destMap = {};
    for (var i = 0; i < getDestinations(context).length; i++) {
      Destination dest = getDestinations(context)[i];
      dest.index = i + startIndexOffset;
      destMap[dest.route] = dest;
    }

    for (var e in Routes.customRoutes.entries) {
      print("set dest ${e.key} ${destMap[e.value]} ");
      final v = destMap[e.value];
      if (v != null) {
        Destination dest = v;
        destMap[e.key] = dest;
        print("dest ${e.key} ${destMap[e.value]} is set");
      } else {
        print(
            "dest ${e.key} ${destMap[e.value]} is not set because it is null");
      }
    }

    return destMap;
  }
}
