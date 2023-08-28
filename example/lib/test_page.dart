import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nicepay_jtanddemon/nicepay_jtanddemon.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool _isInit = false;
  String? _response;
  final _nicepayJtanddemonPlugin = NicepayJtanddemon();

  @override
  void initState() {
    initJTNetPosManager();
    _nicepayJtanddemonPlugin.startListening();
    super.initState();
  }

  @override
  void dispose() {
    _nicepayJtanddemonPlugin.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            _isInit ? const Text('nicepay init success') : const Text('init failed'),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                Map<String, String> data = {
                  'kind': '1010',
                  'deviceId': '1004930001',
                  'installment': '00',
                  'amount': '1000',
                  'tax': '0',
                  'tip': '0',
                  'originalTradeDate': '      ',
                  'originalApprovalNo': '            ',
                  'originalTradeNo': '            ',
                };
                creditApproval(context, data);
              },
              child: const Text('결제'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initJTNetPosManager() async {
    bool? result;
    try {
      result = await _nicepayJtanddemonPlugin.initJTNetPosManager();
    } on PlatformException {
      result = false;
    }

    // if (!mounted) return;
    setState(() {
      _isInit = result!;
    });
  }

  Future<bool> creditApproval(BuildContext context, Map<String, String> mapData) async {
    try {
      bool? result = await _nicepayJtanddemonPlugin.creditApproval(mapData);
      if (result != null) {
        if (result) {
          _nicepayJtanddemonPlugin.getResponseStream().listen((event) {
            setState(() {
              _response = event;
            });

            if (_response != null) {
              // print('response : $_response');
              showDialog(context: context,
                builder: (_)=> AlertDialog(
                  title: const Text('결제 결과'),
                  content: Text('$_response'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('확인'),
                    ),
                  ],
                ),
              );
            } else {
              print('response is null');
            }
          }, onDone: () {
            print('creditApproval done');
          });
          return result;
        } else {
          return result;
        }
      } else {
        return false;
      }
    } on PlatformException {
      return false;
    }
  }

  Future<bool> creditCancel(Map<String, String> mapData) async {
    bool? result;
    try {
      result = await _nicepayJtanddemonPlugin.creditCancel(mapData);

      return result!;
    } on PlatformException {
      result = false;

      return result;
    }
  }
}
