import 'dart:convert';
import 'dart:typed_data';
import 'package:cybex_flutter_plugin/cybex_flutter_plugin.dart';
import 'package:cybex_flutter_plugin_example/post_ref_model.dart';

void test() async {
  PostRefRequestModel requestModel = PostRefRequestModel();
  await CybexFlutterPlugin.getUserKeyWith("xiao87", "xiaoyongyong");
  requestModel.account = "xiao87";
  requestModel.action = "bbbtest";
  requestModel.referrer = "cybex-test";
  requestModel.expiration =
      DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch ~/ 1000;

  List<int> result = [];
  List<int> a = utf8.encode(requestModel.account);
  result.add(a.length);
  result.addAll(a);
  List<int> action = utf8.encode(requestModel.action);
  result.add(action.length);
  result.addAll(action);
  List<int> b = utf8.encode(requestModel.referrer);
  result.add(b.length);
  result.addAll(b);
  for (int i = 0; i < 8; i++) {
    result.add(requestModel.expiration >> (8 * i) & 0xff);
  }
  print(requestModel.expiration);
//  do {
//    int b = (requestModel.expiration & 0x7f);
//    requestModel.expiration >>= 7;
//    if (requestModel.expiration > 0) {
//      b |= (1 << 7);
//    }
//    result.add(b);
//    print(b);
//  } while (requestModel.expiration > 0);

  print(result);

  String c = formatBytesAsHexString(Uint8List.fromList(result));
  String sig = await CybexFlutterPlugin.signStreamOperation(c);
  print(sig);
  print(c);

  List<int> d = utf8.encode(c);
  print(d);
}

String formatBytesAsHexString(Uint8List bytes) {
  var result = new StringBuffer();
  for (var i = 0; i < bytes.lengthInBytes; i++) {
    var part = bytes[i];
    result.write('${part < 16 ? '0' : ''}${part.toRadixString(16)}');
  }
  return result.toString();
}
