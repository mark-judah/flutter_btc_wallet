import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiveBitcoin extends StatefulWidget {
  String walletAddress = "";

  ReceiveBitcoin(this.walletAddress, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ReceiveBitcoin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
          color: Colors.black,
          child:  Column(
            children: [
              const Padding(
                padding:
                EdgeInsets.only(top: 40, left: 20, right: 20),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Receive Bitcoin",
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
              ),
              const Padding(
                padding:
                EdgeInsets.only(top: 30),
              ),
              QrImage(
                data: widget.walletAddress,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.yellow,
              ),
              const Padding(
                padding:
                EdgeInsets.only(top: 20),
              ),
              Text(
                widget.walletAddress,
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),

              const Padding(
                padding:
                EdgeInsets.only(top: 30),
              ),

              Row(
                children: [
                  Spacer(),
                  Expanded(
                      child: MaterialButton(
                        color: Colors.yellow,
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text: widget
                                  .walletAddress))
                              .then((_) {
                            Flushbar(
                              flushbarPosition:
                              FlushbarPosition.TOP,
                              backgroundColor: Colors.yellow,
                              duration:
                              const Duration(seconds: 3),
                              messageText: const Text(
                                "Copied to clipboard!",
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.black,
                                    fontFamily:
                                    "ShadowsIntoLightTwo"),
                              ),
                            ).show(context);
                          });
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.copy,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Text("Copy")
                          ],
                        ),
                      )),



                  Expanded(
                      child: MaterialButton(
                        color: Colors.yellow,
                        onPressed: () {

                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.share,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Text("Share")
                          ],
                        ),
                      )),
                  Spacer()
                ],
              )
            ],
          ),
        );


  }
}