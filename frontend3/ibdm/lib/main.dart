import 'package:flutter/material.dart';
import 'package:ibdm/app.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {
  // remove the # from the url
  setPathUrlStrategy();

  runApp(MyApp());
}
