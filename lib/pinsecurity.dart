import 'dart:convert';

import 'package:btcwallet/wallethome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'globalvariables.dart';

class PinSecurity extends StatefulWidget {
  var finalMnemonicPhrase = [];

  PinSecurity(this.finalMnemonicPhrase, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<PinSecurity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Text(
                'Secure your wallet with a pin(Optional)',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
            ),
            //pincode interface

            const Padding(
              padding: EdgeInsets.only(top: 240),
            ),

            MaterialButton(
              color: Colors.yellow,
              textColor: Colors.black,
              onPressed: () {},
              child: const Text('Done'),
            ),

            MaterialButton(
              color: Colors.yellow,
              textColor: Colors.black,
              onPressed: () {
                createPinlessWalletSeed(widget.finalMnemonicPhrase);
              },
              child: const Text('Skip'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> createPinlessWalletSeed(List finalMnemonicPhrase) async {
    print(finalMnemonicPhrase);
    var urlPrefix=GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/create-wallet-seed');
    print("url##: " + url.toString());
    var string=finalMnemonicPhrase.join(' ');
    print("finalstring"+string);
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "mnemonic": string,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
    var seed=response.body;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (
          context) => WalletHome(seed)),
    );

  }
}
