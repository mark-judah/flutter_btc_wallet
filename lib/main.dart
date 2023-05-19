import 'package:btcwallet/features/intro/ui/introPage.dart';
import 'package:flutter/material.dart';

import 'features/wallet/ui/walletHome.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const MaterialApp(
        debugShowCheckedModeBanner: false,
         home: IntroPage()
      // home:WalletHome("My Wallet")
    );
  }
}
