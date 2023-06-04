import 'package:btcwallet/features/wallet/bloc/wallet_bloc.dart';
import 'package:btcwallet/features/wallet/ui/sendBitcoin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

import '../../bloc2/transactions_bloc.dart';
import '../receiveBitcoin.dart';

class WalletBalanceLoadedComponent extends StatefulWidget {
  WalletBloc walletBloc;
  WalletBalanceLoadedState walletBalanceLoadedState;
  String walletName;
  WalletBalanceLoadedComponent(this.walletBloc,this.walletBalanceLoadedState,this.walletName, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletBalanceLoadedComponent> {
  @override
  void initState() {
    super.initState();
  }
  TransactionsBloc transactionsBloc = TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            const Padding(
              padding:
              EdgeInsets.only(top: 50, left: 20, right: 20),
            ),
            Row(children: [
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  widget.walletName,
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 20,
                      decoration: TextDecoration.none),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.menu,
                  color: Colors.yellow,
                ),
              ),
            ]),
            ////////////////////
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              width: 300,
              decoration: const BoxDecoration(
                  color: Colors.yellow,
                  borderRadius:
                  BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Row(children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, top: 10),
                      child: Text(
                        "Bitcoin Balance",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        widget.walletBloc.add(WalletHomeLoadedEvent(widget.walletName));

                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.black,
                      ),
                    ),
                  ]),

                  SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          widget.walletBalanceLoadedState.balance + " BTC",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                      )),

                  SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:
                        const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          widget.walletBalanceLoadedState.balance + " USD",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              decoration: TextDecoration.none),
                        ),
                      )),


                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 20),
                      child: Row(children: [
                        Flexible(
                          child:Text(
                            widget.walletBalanceLoadedState.walletAddress,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                decoration: TextDecoration.none),
                          ),),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(
                                text: widget.walletBalanceLoadedState
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
                          icon: const Icon(
                            Icons.copy,
                            color: Colors.black,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                      child: MaterialButton(
                        color: Colors.yellow,
                        onPressed: () {},
                        child: Row(
                          children: const [
                            Icon(
                              Icons.qr_code_scanner,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Text("Scan")
                          ],
                        ),
                      )),
                  Expanded(
                      child: MaterialButton(
                        color: Colors.yellow,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SendBitcoin(widget.walletBalanceLoadedState.balance,widget.walletBalanceLoadedState.walletAddress,widget.walletName)),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.call_made,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Text("Send")
                          ],
                        ),
                      )),
                  Expanded(
                      child: MaterialButton(
                        color: Colors.yellow,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ReceiveBitcoin(widget.walletBalanceLoadedState.walletAddress)),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.call_received,
                              color: Colors.black,
                            ),
                            Spacer(),
                            Text("Receive")
                          ],
                        ),
                      )),
                ],
              ),
            ),
            ///////////////////
          ],
        ),
      ),
    );
  }
}