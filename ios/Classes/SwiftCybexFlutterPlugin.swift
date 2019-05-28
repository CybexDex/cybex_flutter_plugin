import Flutter
import UIKit
import cybex_ios_core_cpp
import SwiftyJSON

enum MethodName:String {
    case limitOrderCreate
    case transfer
    case signMessage
    case transactionId
    case getUserKey
    case resetDefaultKey
    case cancelDefaultKey
}

public class SwiftCybexFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cybex_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftCybexFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case MethodName.limitOrderCreate.rawValue:
        if let arguments = call.arguments as? Array<Any>, let jsonStr = arguments[0] as? String, let chainId = arguments[1] as? String {
            let json = JSON(parseJSON: jsonStr)
            let res = getLimitOrderOperation(json: json, chainId: chainId)
            result(res)
        } else {
            result("null")
        }
    case MethodName.transfer.rawValue:
        break
    case MethodName.signMessage.rawValue:
        break
    case MethodName.transactionId.rawValue:
        break
    case MethodName.getUserKey.rawValue:
        if let arguments = call.arguments as? Array<Any>, let username = arguments[0] as? String, let password = arguments[1] as? String {
            let res = BitShareCoordinator.getUserKeys(username, password: password)
            result(res)
        } else {
            result("null")
        }

    case MethodName.resetDefaultKey.rawValue:
        break
    case MethodName.cancelDefaultKey.rawValue:
        break
    default:
        break
    }
    result("null")
  }

    func getLimitOrderOperation(json: JSON, chainId: String) -> String {
        return BitShareCoordinator.getLimitOrder(json["refBlockNum"].int32Value, block_id: json["refBlockPrefix"].stringValue, expiration: json["txExpiration"].doubleValue, chain_id: chainId, user_id: json["seller"].int32Value, order_expiration: json["expiration"].doubleValue, asset_id: json["amountToSell"]["assetId"].int32Value, amount: json["amountToSell"]["assetId"].int64Value, receive_asset_id: json["minToReceive"]["assetId"].int32Value, receive_amount: json["minToReceive"]["assetId"].int64Value, fee_id: json["fee"]["assetId"].int32Value, fee_amount: json["fee"]["assetId"].int64Value, fillOrKill: true)
    }
}
