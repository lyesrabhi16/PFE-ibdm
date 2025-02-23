import 'package:flutter/material.dart';
import 'package:ibdm/app.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/user_controller.dart';

void main() {
  // remove the # from the url
  setPathUrlStrategy();
  Get.put(UserController()); 
  runApp(MyApp());
}
  