package com.nbltrustdev.cybex.cybex_flutter_plugin;

import com.cybex.provider.graphene.chain.PrivateKey;
import com.cybex.provider.graphene.chain.SignedTransaction;
import com.cybex.provider.graphene.chain.Types;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** CybexFlutterPlugin */
public class CybexFlutterPlugin implements MethodCallHandler {
  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "cybex_flutter_plugin");
    channel.setMethodCallHandler(new CybexFlutterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      PrivateKey privateKey = PrivateKey.from_seed("cybex-test" + "active" + "cybextest123456");
      Types.public_key_type publicActiveKeyType = new Types.public_key_type(privateKey.get_public_key(true), true);

      result.success("Android " + publicActiveKeyType.toString());
    } else {
      result.notImplemented();
    }
  }
}
