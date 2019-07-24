import Flutter
import UIKit
import cybex_ios_core_cpp
import SwiftyJSON

enum MethodName:String {
    case limitOrderCreate
    case transfer
    case signMessage
    case signStream
    case transactionId
    case getUserKey
    case resetDefaultKey
    case cancelDefaultKey
    case amendOrder
    case setDefaultPrivateKey
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
        if let arguments = call.arguments as? Array<Any>, let jsonStr = arguments[0] as? String, let chainId = arguments[1] as? String, let blockId = arguments[2] as? String, let isBuy = arguments[3] as? Bool {
            let json = JSON(parseJSON: jsonStr)
            let res = getLimitOrderOperation(json: json, chainId: chainId, blockId: blockId, isBuy: isBuy)
            result(res)
        } else {
            result("null")
        }
    case MethodName.transfer.rawValue:
        if let arguments = call.arguments as? Array<Any>, let jsonStr = arguments[0] as? String, let chainId = arguments[1] as? String, let blockId = arguments[2] as? String {
            let json = JSON(parseJSON: jsonStr)
            let res = getTransferOperation(json: json, chainId: chainId, blockId: blockId)
            result(res)
        } else {
            result("null")
        }
    case MethodName.signMessage.rawValue:
        if let arguments = call.arguments as? Array<Any>, let str = arguments[0] as? String {
            let res = BitShareCoordinator.sign(str)
            result(res)
        }
        else {
            result("null")
        }
    case MethodName.signStream.rawValue:
        if let arguments = call.arguments as? Array<Any>, let str = arguments[0] as? String {
            let res = BitShareCoordinator.sign(fromHex: str)
            result(res)
        }
        else {
            result("null")
        }
    case MethodName.transactionId.rawValue:
        if let arguments = call.arguments as? Array<Any>, let str = arguments[0] as? String {
            let res = BitShareCoordinator.transactionId(fromSigned: str)
            result(res)
        }
        else {
            result("null")
        }
        break
    case MethodName.getUserKey.rawValue:
        if let arguments = call.arguments as? Array<Any>, let username = arguments[0] as? String, let password = arguments[1] as? String {
            let res = BitShareCoordinator.getUserKeys(username, password: password)
            result(res)
        } else {
            result("null")
        }

    case MethodName.resetDefaultKey.rawValue:
        if let arguments = call.arguments as? Array<Any>, let str = arguments[0] as? String {        BitShareCoordinator.resetDefaultPublicKey(str)
            result(true)
        }
        else {
            result(false)
        }
    case MethodName.cancelDefaultKey.rawValue:
        BitShareCoordinator.cancelUserKey()
        result(true)
    case MethodName.setDefaultPrivateKey.rawValue:
        if let arguments = call.arguments as? Array<Any>, let str = arguments[0] as? String {
            BitShareCoordinator.setDefaultPrivateKey(str)
            result(true)
        } else {
            result(false)
        }
    case MethodName.amendOrder.rawValue:
        if let arguments = call.arguments as? Array<Any>, let ss = arguments[0] as? String {
            let res = NXSig.amendOrder(with: ss)
            result(res)
        } else {
            result("null")
        }

    default:
        result("null")
    }
  }

    func getLimitOrderOperation(json: JSON, chainId: String, blockId:String, isBuy:Bool) -> String {
        let res = BitShareCoordinator.getLimitOrder(bySide: isBuy, block_num:json["refBlockNum"].int32Value, block_id: blockId, expiration: json["txExpiration"].doubleValue, chain_id: chainId, user_id: json["seller"].int32Value, order_expiration: json["expiration"].doubleValue, asset_id: json["amountToSell"]["assetId"].int32Value, amount: json["amountToSell"]["amount"].int64Value, receive_asset_id: json["minToReceive"]["assetId"].int32Value, receive_amount: json["minToReceive"]["amount"].int64Value, fee_id: json["fee"]["assetId"].int32Value, fee_amount: json["fee"]["amount"].int64Value, fillOrKill: true)
        return res
    }

    func getTransferOperation(json: JSON, chainId: String, blockId:String) -> String {
        let res = BitShareCoordinator.getTransaction(json["refBlockNum"].int32Value, block_id: blockId, expiration: json["txExpiration"].doubleValue, chain_id: chainId, from_user_id: json["from"].int32Value, to_user_id: json["to"].int32Value, asset_id: json["amount"]["assetId"].int32Value, receive_asset_id: json["amount"]["assetId"].int32Value, amount: json["amount"]["amount"].int64Value, fee_id: json["fee"]["assetId"].int32Value, fee_amount: json["fee"]["amount"].int64Value, memo: "", from_memo_key: "", to_memo_key: "")
        return res
    }
}
