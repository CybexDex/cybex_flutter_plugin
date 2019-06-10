import 'dart:async';
import 'dart:convert';
import 'dart:io';

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
    final String trx = await _channel
        .invokeMethod(CybexFlutterPlugin.getUserKey, [username, password]);
    return trx;
  }

  static Future<bool> resetDefaultPubKey(String pubKey) async {
    final bool res = await _channel
        .invokeMethod(CybexFlutterPlugin.resetDefaultKey, [pubKey]);
    return res;
  }

  static Future<bool> cancelDefaultPubKey() async {
    final bool res =
        await _channel.invokeMethod(CybexFlutterPlugin.cancelDefaultKey);
    return res;
  }

  static Future<Order> limitOrderCreateOperation(Order order) async {
    String trx = await _channel.invokeMethod(
        CybexFlutterPlugin.limitOrderCreate,
        [order.toRawJson(), order.chainid]);
    print(trx);
    if (Platform.isAndroid) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.microsecondsSinceEpoch;
      }
      dict["fee"] = {
        "assetId": op["fee"]["asset_id"],
        "amount": op["fee"]["amount"]
      };
      dict["seller"] = op["seller"];
      dict["amountToSell"] = {
        "assetId": op["amount_to_sell"]["asset_id"],
        "amount": op["amount_to_sell"]["amount"]
      };
      dict["minToReceive"] = {
        "assetId": op["min_to_receive"]["asset_id"],
        "amount": op["min_to_receive"]["amount"]
      };

      if (op["expiration"] is String) {
        var date = DateTime.parse("${op["expiration"]}Z");
        dict["expiration"] = date.microsecondsSinceEpoch;
      }
      dict["fill_or_kill"] = (op["fill_or_kill"] as bool) ? 1 : 0;
      dict["signature"] = dict["signatures"][0];
      var trxid = await transactionIdOperation(trx);
      print(trxid);
      var order = Order.fromJson(dict);
      order.transactionid = trxid;
      return order;
    } else if (Platform.isIOS) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.microsecondsSinceEpoch;
      }
      dict["fee"] = {
        "assetId": op["fee"]["asset_id"],
        "amount": op["fee"]["amount"]
      };
      dict["seller"] = op["seller"];
      dict["amountToSell"] = {
        "assetId": op["amount_to_sell"]["asset_id"],
        "amount": op["amount_to_sell"]["amount"]
      };
      dict["minToReceive"] = {
        "assetId": op["min_to_receive"]["asset_id"],
        "amount": op["min_to_receive"]["amount"]
      };

      if (op["expiration"] is String) {
        var date = DateTime.parse("${op["expiration"]}Z");
        dict["expiration"] = date.microsecondsSinceEpoch;
      }
      dict["fill_or_kill"] = (op["fill_or_kill"] as bool) ? 1 : 0;
      dict["signature"] = dict["signatures"][0];

      var txid = await transactionIdOperation(trx);
      var order = Order.fromJson(dict);
      order.transactionid = txid;
      return order;
    }
    return Order.fromRawJson(trx);
  }

  static Future<String> signMessageOperation(String str) async {
    final String signature =
        await _channel.invokeMethod(CybexFlutterPlugin.signMessage, [str]);
    return signature;
  }

  static Future<Commission> transferOperation(Commission commission) async {
    final String trx = await _channel.invokeMethod(CybexFlutterPlugin.transfer,
        [commission.toRawJson(), commission.chainid]);
    if (Platform.isAndroid) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.microsecondsSinceEpoch;
      }
      dict["fee"] = {
        "assetId": op["fee"]["asset_id"],
        "amount": op["fee"]["amount"]
      };
      dict["from"] = op["from"];
      dict["to"] = op["to"];

      dict["amount"] = {
        "assetId": op["amount"]["asset_id"],
        "amount": op["amount"]["amount"]
      };

      dict["signature"] = dict["signatures"][0];

      var txid = await transactionIdOperation(trx);
      var comm = Commission.fromJson(dict);
      comm.txId = txid;
      comm.transactionid = txid;
      return comm;
    } else if (Platform.isIOS) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.microsecondsSinceEpoch;
      }
      dict["fee"] = {
        "assetId": op["fee"]["asset_id"],
        "amount": op["fee"]["amount"]
      };
      dict["from"] = op["from"];
      dict["to"] = op["to"];

      dict["amount"] = {
        "assetId": op["amount"]["asset_id"],
        "amount": op["amount"]["amount"]
      };

      dict["signature"] = dict["signatures"][0];

      var txid = await transactionIdOperation(trx);
      var comm = Commission.fromJson(dict);
      comm.txId = txid;
      comm.transactionid = txid;
      return comm;
    }
    return Commission.fromRawJson(trx);
  }

  static Future<String> transactionIdOperation(String signedOp) async {
    final String id = await _channel
        .invokeMethod(CybexFlutterPlugin.transactionId, [signedOp]);
    return id;
  }
}
