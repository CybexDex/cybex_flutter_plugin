import Flutter
import UIKit
import cybex_ios_core_cpp

public class SwiftCybexFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "cybex_flutter_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftCybexFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result(BitShareCoordinator.getUserKeys("xxx", password: "xx"))
//    result("iOS " + UIDevice.current.systemVersion)
  }
}
