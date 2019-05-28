import 'dart:async';

import 'package:flutter/services.dart';
import 'order.dart';
import 'commision.dart';

class CybexFlutterPlugin {
  static const String limitOrderCreate = "limitOrderCreate";
  static const String transfer = "transfer";
  static const String signMessage = "signMessage";
  static const String transactionId = "transactionId";
  static const String getUserKey = "getUserKey";
  static const String resetDefaultKey = "resetDefaultKey";
  static const String cancelDefaultKey = "cancelDefaultKey";

  static const MethodChannel _channel =
      const MethodChannel('cybex_flutter_plugin');

  static Future<String> getUserKeyWith(String username, String password) async {
    final String trx = await _channel.invokeMethod(CybexFlutterPlugin.getUserKey, [username, password]);
    return trx;
  }

  static Future<Null> resetDefaultPubKey(String pubKey) async {
    final String _ = await _channel.invokeMethod(CybexFlutterPlugin.resetDefaultKey, pubKey);
    return Null;
  }

  static Future<Null> cancelDefaultPubKey() async {
    final String _ = await _channel.invokeMethod(CybexFlutterPlugin.cancelDefaultKey);
    return Null;
  }

  static Future<Order> limitOrderCreateOperation(Order order) async {
    final String trx = await _channel.invokeMethod(CybexFlutterPlugin.limitOrderCreate, [order.toRawJson(), order.chainid]);
    return Order.fromRawJson(trx);
  }

  static Future<String> signMessageOperation(Order order) async {
    final String signature = await _channel.invokeMethod(CybexFlutterPlugin.signMessage, order.toRawJson());
    return signature;
  }

  static Future<Commission> transferOperation(Order order) async {
    final String trx = await _channel.invokeMethod(CybexFlutterPlugin.transfer, [order.toRawJson(), order.chainid]);
    return Commission.fromRawJson(trx);
  }

  static Future<String> transactionIdOperation(String signedOp) async {
    final String id = await _channel.invokeMethod(CybexFlutterPlugin.transactionId, signedOp);
    return id;
  }
}
