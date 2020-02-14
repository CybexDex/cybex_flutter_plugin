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
      List<Object> arguments = call.arguments();
      String json = (String) arguments.get(0);
      Log.e("json", json);
      String chainId = (String) arguments.get(1);
      boolean isBuy = (boolean) arguments.get(3);
      Gson gson = new Gson();
      JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
      String limitOrder = WalletApi.getInstance().getLimitOrderSignedTransaction(
              jsonObject.get("refBlockNum").getAsLong(),
              jsonObject.get("refBlockPrefix").getAsLong(),
              jsonObject.get("txExpiration").getAsLong(),
              jsonObject.get("expiration").getAsLong(),
              chainId,
              jsonObject.get("seller").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("amountToSell").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("minToReceive").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("amountToSell").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("minToReceive").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("fill_or_kill").getAsInt(),
              isBuy
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
      String blockId = arguments.get(2);
      Gson gson = new Gson();
      JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
      String transfer = WalletApi.getInstance().getTransferSignedTransaction(
              jsonObject.get("refBlockNum").getAsLong(),
              jsonObject.get("txExpiration").getAsLong(),
              blockId,
              chainId,
              jsonObject.get("from").getAsString(),
              jsonObject.get("to").getAsString(),
              jsonObject.get("amount").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("fee").getAsJsonObject().get("assetId").getAsString(),
              jsonObject.get("amount").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("fee").getAsJsonObject().get("amount").getAsLong(),
              jsonObject.get("memo") != null ? jsonObject.get("memo").getAsString() : null,
              jsonObject.get("toMemoKey") != null ? jsonObject.get("toMemoKey").getAsString() : null,
              jsonObject.get("fromMemoKey") != null ? jsonObject.get("fromMemoKey").getAsString() : null,
              jsonObject.get("assetId") != null ?  jsonObject.get("assetId").getAsString() : null,
              jsonObject.get("isTwo").getAsBoolean(),
              jsonObject.get("gatewayAssetId") != null ? jsonObject.get("gatewayAssetId").getAsString() : null,
              jsonObject.get("gatewayMemoKey") != null ? jsonObject.get("gatewayMemoKey").getAsString() : null
              );
      result.success(transfer);
    } else if (call.method.equals("resetDefaultKey")) {
      List<String> arguments = call.arguments();
      String pubKey = arguments.get(0);
      boolean isReset = WalletApi.getInstance().resetDefaultPublicKey(pubKey);
      result.success(isReset);
    } else if (call.method.equals("cancelDefaultKey")) {
      boolean isCancel = WalletApi.getInstance().cancelDefaultPublicKey();
      result.success(isCancel);
    } else if (call.method.equals("amendOrder")) {
      List<String> arguments = call.arguments();
      String json = arguments.get(0);
      Gson gson = new Gson();
      JsonObject jsonObject = gson.fromJson(json, JsonObject.class);
      String amend = WalletApi.getInstance().getAmendSignature(
              jsonObject.get("refBuyOrderTxId").getAsString(),
              jsonObject.get("cutLossPx").getAsString(),
              jsonObject.get("takeProfitPx").getAsString(),
              jsonObject.get("execNowPx").getAsString(),
              jsonObject.get("expiration").getAsString(),
              jsonObject.get("seller").getAsString());
      result.success(amend);
    } else if (call.method.equals("signMessage")) {
      List<String> arguments = call.arguments();
      String param = arguments.get(0);
      String signMessage = WalletApi.getInstance().signMessage(param);
      result.success(signMessage);
    } else if (call.method.equals("signStream")) {
      List<String> arguments = call.arguments();
      String param = arguments.get(0);
      String signStream = WalletApi.getInstance().signMessageStream(param);
      result.success(signStream);

    } else if (call.method.equals("setDefaultPrivateKey")) {
      List<String> arguments = call.arguments();
      String privKey = arguments.get(0);
      WalletApi.getInstance().setDefaultPrivateKey(privKey);
      result.success(true);
    }
    else {
      result.notImplemented();
    }
  }
}
