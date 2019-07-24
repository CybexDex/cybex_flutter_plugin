import 'dart:convert';

class PostRefRequestModel {
  String action;
  int expiration;
  String referrer;
  String account;
  String signature;

  PostRefRequestModel({
    this.action,
    this.expiration,
    this.referrer,
    this.account,
    this.signature,
  });

  factory PostRefRequestModel.fromJson(jsonRes) => jsonRes == null
      ? null
      : PostRefRequestModel(
          action: convertValueByType(jsonRes['action'], String,
              stack: "Root-action"),
          expiration: convertValueByType(jsonRes['expiration'], int,
              stack: "Root-expiration"),
          referrer: convertValueByType(jsonRes['referrer'], String,
              stack: "Root-referrer"),
          account: convertValueByType(jsonRes['account'], String,
              stack: "Root-account"),
          signature: convertValueByType(jsonRes['signature'], String,
              stack: "Root-signature"),
        );

  Map<String, dynamic> toJson() => {
        'action': action,
        'expiration': expiration,
        'referrer': referrer,
        'account': account,
        'signature': signature,
      };
  @override
  String toString() {
    return json.encode(this);
  }
}

dynamic convertValueByType(value, Type type, {String stack: ""}) {
  if (value == null) {
    if (type == String) {
      return "";
    } else if (type == int) {
      return 0;
    } else if (type == double) {
      return 0.0;
    } else if (type == bool) {
      return false;
    }
    return null;
  }

  if (value.runtimeType == type) {
    return value;
  }
  var valueS = value.toString();
  if (type == String) {
    return valueS;
  } else if (type == int) {
    return int.tryParse(valueS);
  } else if (type == double) {
    return double.tryParse(valueS);
  } else if (type == bool) {
    valueS = valueS.toLowerCase();
    var intValue = int.tryParse(valueS);
    if (intValue != null) {
      return intValue == 1;
    }
    return valueS == "true";
  }
}

void tryCatch(Function f) {
  try {
    f?.call();
  } catch (e, stack) {}
}
