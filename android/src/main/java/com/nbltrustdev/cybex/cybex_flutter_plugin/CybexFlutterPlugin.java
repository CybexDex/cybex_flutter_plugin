package com.nbltrustdev.cybex.cybex_flutter_plugin;

import android.util.Log;

import com.cybex.provider.crypto.Ripemd160Object;
import com.cybex.provider.graphene.chain.PrivateKey;
import com.cybex.provider.graphene.chain.SignedTransaction;
import com.cybex.provider.graphene.chain.Types;
import com.cybex.provider.websocket.WalletApi;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import java.util.List;

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
    } else if (call.method.equals("getUserKey")) {
      List<String> arguments = call.arguments();
      result.success(WalletApi.getInstance().getUserKey(arguments.get(0), arguments.get(1)));
    } else if (call.method.equals("limitOrderCreate")) {
      List<String> arguments = call.arguments();
      String json = arguments.get(0);
      Log.e("json", json);
      String chainId = arguments.get(1);
      Gson gson = new Gson();
      JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
      PrivateKey privateKey = PrivateKey.from_seed("cybex-test" + "active" + "cybextest123456");
      Types.public_key_type publicActiveKeyType = new Types.public_key_type(privateKey.get_public_key(true), true);
      Log.e("ss", publicActiveKeyType.toString());
      WalletApi.getInstance().getUserKey("cybex-test", "cybextest123456");
      String limitOrder = WalletApi.getInstance().getLimitOrderSignedTransaction(
              jsonObject.get("refBlockNum").getAsLong(),
              jsonObject.get("refBlockPrefix").getAsLong(),
              jsonObject.get("txExpiration").getAsLong(),
              chainId,
              jsonObject.get("seller").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("amountToSell").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("minToReceive").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("amountToSell").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("minToReceive").getAsJsonObject().get("amount").getAsLong(),
              1,
              publicActiveKeyType.toString()
              );
      result.success(limitOrder);

    } else if (call.method.equals("transactionId")) {
      List<String> arguments = call.arguments();
      String json = arguments.get(0);
      String transactionId = WalletApi.getInstance().getTransactionId(json);
      result.success(transactionId);
    } else if (call.method.equals("transfer")) {
      List<String> arguments = call.arguments();
      String json = arguments.get(0);
      String chainId = arguments.get(1);
      Gson gson = new Gson();
      JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
      PrivateKey privateKey = PrivateKey.from_seed("cybex-test" + "active" + "cybextest123456");
      Types.public_key_type publicActiveKeyType = new Types.public_key_type(privateKey.get_public_key(true), true);
      String transfer = WalletApi.getInstance().getTransferSignedTransaction(
              jsonObject.get("refBlockNum").getAsLong(),
              jsonObject.get("refBlockPrefix").getAsLong(),
              jsonObject.get("txExpiration").getAsLong(),
              chainId,
              jsonObject.get("from").getAsString(),
              jsonObject.get("to").getAsString(),
              jsonObject.get("amount").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("amount").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("fee").getAsJsonObject().get("amount").getAsLong(),
              "",
              "",
              "",
              publicActiveKeyType.toString(),
              0
              );
      result.success(transfer);

    }
    else {
      result.notImplemented();
    }
  }
}
