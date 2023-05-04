import 'dart:async';

import 'package:btcwallet/states/walletState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'newwallet.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MaterialApp(
    home: IntroPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class IntroPage extends StatefulWidget {
  const   IntroPage({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
        ChangeNotifierProvider<walletState>(create: (_) => walletState()),
    ],
    builder: (context, child) {
      return Scaffold(
        body: Container(
          color: Colors.black,
          child: Column(children: [
            const Padding(
              padding: EdgeInsets.only(top: 50),
            ),
            Center(
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                width: 200,
                height: 200,
                color: Colors.yellow,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            const Text(
              'Blah Wallet',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 240),
            ),
            Column(
              children: [
                MaterialButton(
                  color: Colors.yellow,
                  textColor: Colors.black,
                  onPressed: () {
                    print("generateMnemonic");
                    walletState().generateMnemonic(context);
                  },
                  child: const Text('Create a new wallet'),
                ),
                MaterialButton(
                  color: Colors.yellow,
                  textColor: Colors.black,
                  onPressed: () {

                  },
                  child: const Text('Already Have a wallet'),
                )
              ],
            ),
          ]),
        ),
      );
    });
  }
}

