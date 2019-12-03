import 'dart:async';

import 'package:flutter/services.dart';

class Flashlight {
  static const MethodChannel _channel =
      const MethodChannel('com.bh.flutterplugins/flashlight');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future turnOn() => _channel.invokeMethod('turnOn');

  static Future turnOff() => _channel.invokeMethod('turnOff');

  static Future<bool> get hasTorch async =>
      await _channel.invokeMethod('hasTorch');

  static Future flash(Duration duration) =>
      turnOn().whenComplete(() => Future.delayed(duration, () => turnOff()));
}
