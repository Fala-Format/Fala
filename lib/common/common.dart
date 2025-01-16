import 'dart:io';

import 'package:fala/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showMessage(String message, {BuildContext? context}) {
  context ??= navigatorKey.currentContext;
  if(context != null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 3),
    ));
  }
}

String appVersion = "v1";

void syncICloud() {
  if(Platform.isIOS) {
    MethodChannel('io.fala.ios.client/native').invokeMethod("syncICloud");
  }
}