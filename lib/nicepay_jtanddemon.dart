
// ignore_for_file: constant_identifier_names

import 'package:nicepay_jtanddemon/nicepay_jtanddemon_response.dart';
import 'nicepay_jtanddemon_platform_interface.dart';

class NicepayJtanddemon {
  Future<String?> getPlatformVersion() {
    return NicepayJtanddemonPlatform.instance.getPlatformVersion();
  }

  Future<bool?> initJTNetPosManager() {
    return NicepayJtanddemonPlatform.instance.initJTNetPosManager();
  }

  Future<bool?> keyChange() {
    return NicepayJtanddemonPlatform.instance.keyChange();
  }

  Future<bool?> creditApproval(Map<String, String> map) {
    return NicepayJtanddemonPlatform.instance.creditApproval(map);
  }

  Future<bool?> creditCancel(Map<String, String> map) {
    return NicepayJtanddemonPlatform.instance.creditCancel(map);
  }

  String? getResponse() {
    return JtanddemonResponse().getResponse();
  }

  Stream<String> getResponseStream() {
    return JtanddemonResponse().responseStream;
  }

  void startListening() {
    JtanddemonResponse().startListening();
  }

  void stopListening() {
    JtanddemonResponse().stopListening();
  }
}

enum CHANNELS {
  METHOD,
  RESPONSE;

  String get name {
    switch (this) {
      case CHANNELS.METHOD:
        return 'nicepay_jtanddemon/method';
      case CHANNELS.RESPONSE:
        return 'nicepay_jtanddemon/response';
    }
  }
}