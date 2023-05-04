import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletHome extends StatefulWidget {
  var wallet_seed = "";

  WalletHome(this.wallet_seed, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletHome> {
  @override
  void initState() {
    createWallet(widget.wallet_seed);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container()
    );
  }

  void createWallet(String wallet_seed) {
    // final url = Uri.parse('$urlPrefix/create-wallet');
    // print("url##: " + url.toString());
    //
    // final headers = {"Content-type": "application/json"};
    // final json = jsonEncode({
    //   "entropy": "256",
    // });
    // final response = await http.post(url, headers: headers, body: json);
    // if (kDebugMode) {
    //   print("url##: " + url.toString());
    //   print("jsonData##: " + json.toString());
    //   print('Status code: ${response.statusCode}');
    //   print('Body: ${response.body}');
    // }
    //
    // var mnemonic=response.body;
  }
}