import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cybex_flutter_plugin/common.dart';
import 'package:cybex_flutter_plugin/utils/util.dart';
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
  static const String amendOrder = "amendOrder";

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

  static Future<Order> limitOrderCreateOperation(
      Order order, bool isBuy) async {
    if (Platform.isAndroid) {
      order.amountToSell.assetId =
          Utils.wrapId(order.amountToSell.assetId, ASSET);
      order.fee.assetId = Utils.wrapId(order.fee.assetId, ASSET);
      order.minToReceive.assetId =
          Utils.wrapId(order.minToReceive.assetId, ASSET);
      order.seller = Utils.wrapId(order.seller, ACCOUNT);
    }

    String trx = await _channel.invokeMethod(
        CybexFlutterPlugin.limitOrderCreate,
        [order.toRawJson(), order.chainid, order.refBlockId, isBuy]);
    print(trx);
    if (Platform.isAndroid) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.millisecondsSinceEpoch ~/ 1000;
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
        dict["expiration"] = date.millisecondsSinceEpoch ~/ 1000;
      }
      dict["fill_or_kill"] = (op["fill_or_kill"] as bool) ? 1 : 0;
      dict["signature"] = dict["signatures"][0];
      var trxid = await transactionIdOperation(trx);
      print(trxid);
      var order = Order.fromJson(dict);
      order.transactionid = trxid;
      return order;
    } else {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.millisecondsSinceEpoch ~/ 1000;
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
        dict["expiration"] = date.millisecondsSinceEpoch ~/ 1000;
      }
      dict["fill_or_kill"] = (op["fill_or_kill"] as bool) ? 1 : 0;
      dict["signature"] = dict["signatures"][0];

      var txid = await transactionIdOperation(trx);
      var order = Order.fromJson(dict);
      order.transactionid = txid;
      return order;
    }
  }

  static Future<String> signMessageOperation(String str) async {
    final String signature =
        await _channel.invokeMethod(CybexFlutterPlugin.signMessage, [str]);
    return signature;
  }

  static Future<Commission> transferOperation(Commission commission) async {
    if (Platform.isAndroid) {
      commission.fee.assetId = Utils.wrapId(commission.fee.assetId, ASSET);
      commission.from = Utils.wrapId(commission.from, ACCOUNT);
      commission.to = Utils.wrapId(commission.to, ACCOUNT);
      commission.amount.assetId =
          Utils.wrapId(commission.amount.assetId, ASSET);
    }
    final String trx = await _channel.invokeMethod(CybexFlutterPlugin.transfer,
        [commission.toRawJson(), commission.chainid, commission.refBlockId]);
    if (Platform.isAndroid) {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.millisecondsSinceEpoch ~/ 1000;
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
    } else {
      var dict = json.decode(trx);
      final op = dict["operations"][0][1];
      dict["refBlockNum"] = dict["ref_block_num"];
      dict["refBlockPrefix"] = dict["ref_block_prefix"];
      if (dict["expiration"] is String) {
        var date = DateTime.parse("${dict["expiration"]}Z");
        dict["txExpiration"] = date.millisecondsSinceEpoch ~/ 1000;
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
  }

  static Future<TransactionCommon> amendOrderOperation(String jsonstr) async {
    TransactionCommon comm = TransactionCommon();
    final String trx =
        await _channel.invokeMethod(CybexFlutterPlugin.amendOrder, [jsonstr]);
        
    var dict = json.decode(trx);
    var trxid = await transactionIdOperation(trx);
    comm.transactionid = trxid;
    if (Platform.isIOS) {
      comm.sig = dict["signer"];
    } else if (Platform.isAndroid) {
      comm.sig = dict["signature"][0];
    }
    return comm;
  }

  static Future<String> transactionIdOperation(String signedOp) async {
    final String id = await _channel
        .invokeMethod(CybexFlutterPlugin.transactionId, [signedOp]);
    return id;
  }
}
