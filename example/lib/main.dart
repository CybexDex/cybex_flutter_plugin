import 'package:cybex_flutter_plugin_example/test.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin/order.dart';
import 'package:cybex_flutter_plugin/commision.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.

    // test();

    // try {
    //   final str = "sss";
    //   String keys = await CybexFlutterPlugin.getUserKeyWith(
    //       "cybex-test", "cybextest123456");
    //   final result = await CybexFlutterPlugin.amendOrderOperation(str);
    // } catch (_) {}

    try {
      final Order order = Order();
      order.chainid = "0";
      order.refBlockNum = 22;
      order.refBlockPrefix = 11;
      order.txExpiration = 600;
      order.fee = AmountToSell(amount: 20, assetId: "1.3.2");
      order.seller = "1.2.29";
      order.amountToSell = AmountToSell(amount: 20, assetId: "1.3.2");
      order.minToReceive = AmountToSell(amount: 10, assetId: "1.3.3");
      order.expiration = 1800;
      order.fillOrKill = 1;

      String keys = await CybexFlutterPlugin.getUserKeyWith(
          "cybex-test", "cybextest123456");
      // Order signedOpOrder =
      //     await CybexFlutterPlugin.limitOrderCreateOperation(order, true);
      // platformVersion = signedOpOrder.toRawJson();

      Commission commission = Commission();
      commission.chainid =
          "90be01e82b981c8f201c9a78a3d31f655743b29ff3274727b1439b093d04aa23";
      commission.refBlockNum = 3635;
      commission.refBlockPrefix = 1746772012;
      commission.txExpiration = 1569297278;
      commission.fee = AmountToSell(amount: 20, assetId: "2");
      commission.from = "29";
      commission.to = "34";
      commission.amount = AmountToSell(amount: 100, assetId: "2");

      Commission signedOpComm =
          await CybexFlutterPlugin.transferOperation(commission);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
