import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon.dart';

import 'nicepay_jtanddemon_platform_interface.dart';

/// An implementation of [NicepayJtanddemonPlatform] that uses method channels.
class MethodChannelNicepayJtanddemon extends NicepayJtanddemonPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = MethodChannel(CHANNELS.METHOD.name);

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool?> initJTNetPosManager() async {
    try {
      final result =
          await methodChannel.invokeMethod<bool>('init');
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> keyChange() async {
    // todo : keyChange
    try {
      final result = await methodChannel.invokeMethod<bool>('keyChange');
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> creditApproval(Map<String, String> map) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('creditApproval', map);
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> creditCancel(Map<String, String> map) async {
    try {
      final result = await methodChannel.invokeMethod<bool>('creditCancel', map);
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
