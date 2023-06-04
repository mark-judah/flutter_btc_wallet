import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WalletErrorComponent extends StatefulWidget {
  String errorMessage;

  WalletErrorComponent(this.errorMessage, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletErrorComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.black,
            child:  Center(
              child: Text(
                  widget.errorMessage,
                  style: const TextStyle(
                      color: Colors.yellow, fontSize: 20)),
            )));
  }
}