import 'dart:convert';
import 'common.dart';

class Order with ChainID {
    int refBlockNum;
    int refBlockPrefix;
    int txExpiration;
    AmountToSell fee;
    String seller;
    AmountToSell amountToSell;
    AmountToSell minToReceive;
    int expiration;
    int fillOrKill;
    String signature;

    Order({
        this.refBlockNum,
        this.refBlockPrefix,
        this.txExpiration,
        this.fee,
        this.seller,
        this.amountToSell,
        this.minToReceive,
        this.expiration,
        this.fillOrKill,
        this.signature,
    });

    factory Order.fromRawJson(String str) => Order.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Order.fromJson(Map<String, dynamic> json) => new Order(
        refBlockNum: json["refBlockNum"],
        refBlockPrefix: json["refBlockPrefix"],
        txExpiration: json["txExpiration"],
        fee: AmountToSell.fromJson(json["fee"]),
        seller: json["seller"],
        amountToSell: AmountToSell.fromJson(json["amountToSell"]),
        minToReceive: AmountToSell.fromJson(json["minToReceive"]),
        expiration: json["expiration"],
        fillOrKill: json["fill_or_kill"],
        signature: json["signature"],
    );

    Map<String, dynamic> toJson() => {
        "refBlockNum": refBlockNum,
        "refBlockPrefix": refBlockPrefix,
        "txExpiration": txExpiration,
        "fee": fee.toJson(),
        "seller": seller,
        "amountToSell": amountToSell.toJson(),
        "minToReceive": minToReceive.toJson(),
        "expiration": expiration,
        "fill_or_kill": fillOrKill,
        "signature": signature,
    };
}

class AmountToSell {
    String assetId;
    int amount;

    AmountToSell({
        this.assetId,
        this.amount,
    });

    factory AmountToSell.fromRawJson(String str) => AmountToSell.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory AmountToSell.fromJson(Map<String, dynamic> json) => new AmountToSell(
        assetId: json["assetId"],
        amount: json["amount"],
    );

    Map<String, dynamic> toJson() => {
        "assetId": assetId,
        "amount": amount,
    };
}