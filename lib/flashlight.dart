import 'dart:async';

import 'package:flutter/services.dart';

class Flashlight {
  static const MethodChannel _channel =
      const MethodChannel('flashlight');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
