import 'package:flutter/material.dart';
import 'package:ibdm/utils/constants/routes.dart';

class Destination {
  final String title;
  final IconData icon;
  final String route;
  int? index;
  Destination(this.title, this.icon, this.route);

  static List<Destination> getDestinations(context) => [
        Destination("Home", Icons.home, Routes.home),
        Destination("Protected", Icons.lock, "/protected"),
        Destination("Users", Icons.people, Routes.users),
        Destination("Settings", Icons.settings, Routes.settings),
      ];

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
    return destMap;
  }
}
