import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelNicepayJtanddemon platform = MethodChannelNicepayJtanddemon();
  const MethodChannel channel = MethodChannel('nicepay_jtanddemon');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
