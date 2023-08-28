import 'dart:async';
import 'package:flutter/services.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon.dart';

class JtanddemonResponse {
  final _eventChannel = EventChannel(CHANNELS.RESPONSE.name);
  StreamSubscription? _eventSubscription;
  String? _response;

  Stream<String> get responseStream {
    return _eventChannel.receiveBroadcastStream().cast<String>();
  }

  void startListening() {
    resetResponse();

    _eventSubscription = _eventChannel.receiveBroadcastStream().listen((event) {});
  }

  void stopListening() {
    _eventSubscription?.cancel();
    _eventSubscription = null;

    resetResponse();
  }

  void onEvent(String event) {
    _response = event;
  }

  String? getResponse() {
    _eventSubscription?.onData((data) {
      _response = data;
    });
    return _response;
  }

  // reset _response
  void resetResponse() {
    _response = null;
  }

}