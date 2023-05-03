import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
class Payment extends StatelessWidget{
  
  String qrCodeUrl = '';
  double? orderAmount;
  String nameGoods;
  Payment({Key? key, required this.orderAmount, required this.nameGoods}) : super(key: key);
  

  Future<String> getQrCode(String orderid) async {
    var key=['yto1rmizixuqavngrs5fysxkzrf1qxzorrhvxyvcnuysxtqyeudsmlvptxw4wgzb','o236vrmyrsxkxrw5dh6qpfzskkdugaqxg6u2drqwpm6kvrpupv5yscpzhtw5qlwv'];
    String url = "https://bpay.binanceapi.com/binancepay/openapi/v2/order";
    Signature sig = Signature();
    String chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String nonce = "";
    
    for (var i = 0; i < 32; i++) {
      nonce += chars[(chars.length * Random().nextDouble()).floor()];
    }
    String timestamp =
        (DateTime.now().millisecondsSinceEpoch).toString();
    Map<String,dynamic> json1 ={};
    Map<String,dynamic> json2 ={};
    Map<String,dynamic> json3 ={};
    json3.addAll({'goodsType':'01','goodsCategory':'0000','referenceGoodsId':'abc123','goodsName':nameGoods});
    json2.addAll({'terminalType':'APP'});
    json1.addAll({'env':json2,"merchantTradeNo":orderid,"orderAmount":orderAmount,"currency":"BUSD","goods":json3});
    String jsonString = jsonEncode(json1);
    String payload = timestamp+'\n'+nonce+'\n'+jsonString+'\n';
    print(payload);
    var signature = sig.getSignature(payload,key[1]).toUpperCase();



    Map<String,String> header = {};
    header.putIfAbsent("content-type", () => "application/json");
    header.putIfAbsent("BinancePay-Timestamp", () => timestamp);
    header.putIfAbsent("BinancePay-Nonce", () => nonce);
    header.putIfAbsent("BinancePay-Certificate-SN", () => key[0]);
    header.putIfAbsent("BinancePay-Signature", () => signature);

    final respone = await http.post(Uri.parse(url),headers: header,body: jsonString);
    return json.decode(respone.body)['data']['qrCodeUrl'];
  }

  void createOrderID(double amount, String nameG) async{

      String orderID = Random().nextInt(100000000).toString();
      qrCodeUrl = await getQrCode(orderID);
      print(qrCodeUrl??'asduagsfdausdgfuyasdgfayhsdfuyagsdufgasuydgfayusdgfyasdgf');
  }
  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build
    CachedNetworkImage img = CachedNetworkImage(
      imageUrl: qrCodeUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 70),
      height: 60,
      width: 60,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh toán'),
      ),
      body: Container(child: img, alignment: Alignment.center,),
    );
  }
  
}
class Signature {
  String getSignature(String data, String key) {
    var key2 = utf8.encode(key);
    var bytes = utf8.encode(data);
    var hmacSha512 = Hmac(sha512, key2);
    return hmacSha512.convert(bytes).toString();
  }
}

