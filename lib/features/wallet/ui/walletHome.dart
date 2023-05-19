import 'package:btcwallet/features/wallet/bloc/wallet_bloc.dart';
import 'package:btcwallet/features/wallet/bloc2/transactions_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_svg/svg.dart';

import '../../intro/bloc/intro_bloc.dart';

class WalletHome extends StatefulWidget {
  var walletName = "";
  var walletAddress="";
  WalletHome(this.walletName, this.walletAddress, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletHome> {
  @override
  void initState() {
    walletBloc.add(WalletHomeLoadedEvent(widget.walletName));
    transactionsBloc.add(FetchTransactionsEvent());

    super.initState();
  }

  final WalletBloc walletBloc = WalletBloc();
  final TransactionsBloc transactionsBloc = TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: BlocConsumer<WalletBloc, WalletState>(
            bloc: walletBloc,
            //listen for emitted action states and perform an action
            listenWhen: (previous, current) => current is WalletActionState,
            //build when there is no action state
            buildWhen: (previous, current) => current is! WalletActionState,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case WalletLoadingState:
                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      ),
                    ),
                  );
                case WalletLoadedSuccessState:
                  final walletLoadedSuccessState =
                      state as WalletLoadedSuccessState;
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "0.00000000 BTC",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            decoration: TextDecoration.none),
                                      ),
                                    )),
                                const SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "0.00 USD",
                                        style: TextStyle(
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
                                      Text(
                                        walletLoadedSuccessState.walletAddress,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            decoration: TextDecoration.none),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: walletLoadedSuccessState
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
                                  onPressed: () {},
                                  child: Row(
                                    children: const [
                                      Icon(
                                        Icons.call_made,
                                        color: Colors.black,
                                      ),
                                      Spacer(),
                                      Text("Receive")
                                    ],
                                  ),
                                )),
                                Expanded(
                                    child: MaterialButton(
                                  color: Colors.yellow,
                                  onPressed: () {},
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

                case NavigateToHomePageActionState:
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
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                    ),
                                  ),
                                ]),
                                const SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "0.00000000 BTC",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            decoration: TextDecoration.none),
                                      ),
                                    )),
                                const SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding:
                                      EdgeInsets.only(left: 20, top: 10),
                                      child: Text(
                                        "0.00 USD",
                                        style: TextStyle(
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
                                      Text(
                                        widget.walletAddress,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            decoration: TextDecoration.none),
                                      ),
                                      IconButton(
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
                                      onPressed: () {},
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.call_made,
                                            color: Colors.black,
                                          ),
                                          Spacer(),
                                          Text("Receive")
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: MaterialButton(
                                      color: Colors.yellow,
                                      onPressed: () {},
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

                case WalletErrorState:
                  return Scaffold(
                      body: Container(
                          color: Colors.black,
                          child: const Center(
                            child: Text("An error occured, try again later",
                                style: TextStyle(
                                    color: Colors.yellow, fontSize: 20)),
                          )));

                default:
                  return SizedBox();
              }
            }),
        height: 450,
      ),
      /////////////////////////////////////////////////////////////////////////////////////////////
      Container(
        child: BlocConsumer<TransactionsBloc, TransactionsState>(
            bloc: transactionsBloc,
            //listen for emitted action states and perform an action
            listenWhen: (previous, current) => current is TransactionsActionState,
            //build when there is no action state
            buildWhen: (previous, current) => current is! TransactionsActionState,
            listener: (context, state) {},
            builder: (context, state) {
              print("transactionbloc####");
              print(state);
              switch (state.runtimeType) {
                case TransactionsLoadingState:
                  print(state.runtimeType);

                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.yellow,
                      ),
                    ),
                  );

                case TransactionsNullState:
                  print("svg###########3");
                  return Column(
                    children: [
                      const Text(
                        "No Transactions yet",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Center(
                        child: SvgPicture.asset(
                          "assets/images/no_data.svg",
                          width: 120,
                          height: 120,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  );

                case TransactionsLoadedSuccessState:
                  return Column(
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                      ),
                      Text(
                        "Transactions",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 20,
                            decoration: TextDecoration.none),
                      ),
                    ],
                  );

                default:
                  print("default");
                 return SizedBox();
              }
            }),
        height: 210,
      ),

      BottomNavigationBar(
        backgroundColor: Colors.yellow,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:
                Icon(Icons.account_balance_wallet_rounded, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.black,
            ),
            label: '',
          ),
        ],
      ),
    ]);
  }
}
