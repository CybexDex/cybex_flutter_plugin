import 'order.dart';
import 'dart:convert';
import 'common.dart';

class Commission with TransactionCommon {
  int refBlockNum;
  int refBlockPrefix;
  int txExpiration;
  AmountToSell fee;
  String from;
  String to;
  AmountToSell amount;
  String signature;
  String txId;
  String assetId;
  bool isTwo;
  String fromMemoKey;
  String toMemoKey;
  String gatewayMemoKey;
  String gatewayAssetId;
  String memo;

  Commission(
      {this.refBlockNum,
      this.refBlockPrefix,
      this.txExpiration,
      this.fee,
      this.from,
      this.to,
      this.amount,
      this.signature,
      this.txId,
      this.assetId,
      this.isTwo,
      this.fromMemoKey,
      this.gatewayAssetId,
      this.gatewayMemoKey,
      this.toMemoKey,
      this.memo});

  factory Commission.fromRawJson(String str) =>
      Commission.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Commission.fromJson(Map<String, dynamic> json) => new Commission(
      refBlockNum: json["refBlockNum"],
      refBlockPrefix: json["refBlockPrefix"],
      txExpiration: json["txExpiration"],
      fee: AmountToSell.fromJson(json["fee"]),
      from: json["from"],
      to: json["to"],
      amount: AmountToSell.fromJson(json["amount"]),
      signature: json["signature"],
      txId: json["txId"],
      assetId: json["assetId"],
      isTwo: json["isTwo"]);

  Map<String, dynamic> toJson() => {
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "txExpiration": txExpiration,
        "fee": fee.toJson(),
        "from": from,
        "to": to,
        "amount": amount.toJson(),
        "signature": signature,
        "txId": txId,
        "assetId": assetId,
        "isTwo": isTwo,
        "fromMemoKey": fromMemoKey,
        "toMemoKey": toMemoKey,
        "gatewayAssetId": gatewayAssetId,
        "memo": memo,
        "gatewayMemoKey": gatewayMemoKey
      };
}
