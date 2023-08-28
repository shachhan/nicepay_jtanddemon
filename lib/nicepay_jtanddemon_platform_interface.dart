import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'nicepay_jtanddemon_method_channel.dart';

abstract class NicepayJtanddemonPlatform extends PlatformInterface {
  /// Constructs a NicepayJtanddemonPlatform.
  NicepayJtanddemonPlatform() : super(token: _token);

  static final Object _token = Object();

  static NicepayJtanddemonPlatform _instance = MethodChannelNicepayJtanddemon();

  /// The default instance of [NicepayJtanddemonPlatform] to use.
  ///
  /// Defaults to [MethodChannelNicepayJtanddemon].
  static NicepayJtanddemonPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NicepayJtanddemonPlatform] when
  /// they register themselves.
  static set instance(NicepayJtanddemonPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool?> initJTNetPosManager() {
    throw UnimplementedError('initJTNetPosManager() has not been implemented.');
  }

  Future<bool?> keyChange() {
    throw UnimplementedError('keyChange() has not been implemented.');
  }

  Future<bool?> creditApproval(Map<String, String> map) {
    throw UnimplementedError('creditApproval() has not been implemented.');
  }

  Future<bool?> creditCancel(Map<String, String> map) {
    throw UnimplementedError('creditCancel() has not been implemented.');
  }
}
