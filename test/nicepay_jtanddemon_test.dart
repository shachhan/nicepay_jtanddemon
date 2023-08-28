import 'package:flutter_test/flutter_test.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon_platform_interface.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockNicepayJtanddemonPlatform
    with MockPlatformInterfaceMixin
    implements NicepayJtanddemonPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final NicepayJtanddemonPlatform initialPlatform = NicepayJtanddemonPlatform.instance;

  test('$MethodChannelNicepayJtanddemon is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelNicepayJtanddemon>());
  });

  test('getPlatformVersion', () async {
    NicepayJtanddemon nicepayJtanddemonPlugin = NicepayJtanddemon();
    MockNicepayJtanddemonPlatform fakePlatform = MockNicepayJtanddemonPlatform();
    NicepayJtanddemonPlatform.instance = fakePlatform;

    expect(await nicepayJtanddemonPlugin.getPlatformVersion(), '42');
  });
}
