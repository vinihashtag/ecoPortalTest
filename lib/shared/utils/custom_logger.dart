import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class LoggerApp {
  LoggerApp._();

  static const String _nameApp = 'coolmovies';

  static void success(dynamic message) {
    if (message is! String) message = message.toString();
    log('\x1B[32m$message\x1B[0m', name: '$_nameApp${Get.routing.current}', time: DateTime.now());
  }

  static void info(dynamic message) {
    if (message is! String) message = message.toString();

    if (kDebugMode) {
      log('\x1B[34m$message\x1B[0m', name: '$_nameApp${Get.routing.current}', time: DateTime.now());
    }
  }

  static void error(dynamic message, [Object? exception, StackTrace? stackTrace]) {
    if (message is! String) message = message.toString();

    if (kDebugMode) {
      log('\x1B[31m$message\x1B[0m',
          name: '$_nameApp${Get.routing.current}', stackTrace: stackTrace, time: DateTime.now());
    }
  }

  static void warning(dynamic message) {
    if (message is! String) message = message.toString();
    if (kDebugMode) {
      log('\x1B[33m$message\x1B[0m', name: '$_nameApp${Get.routing.current}', time: DateTime.now());
    }
  }

  static void debug(dynamic message) {
    if (kDebugMode) log(message, name: '$_nameApp${Get.currentRoute}', time: DateTime.now());
  }
}
