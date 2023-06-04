import 'package:btcwallet/features/wallet/bloc/wallet_bloc.dart';
import 'package:btcwallet/features/wallet/bloc2/transactions_bloc.dart';
import 'package:btcwallet/features/wallet/ui/components/CircularProgressIndicator.dart';
import 'package:btcwallet/features/wallet/ui/components/NavigateToHomePageComponent.dart';
import 'package:btcwallet/features/wallet/ui/components/WalletBalanceLoadingComponent.dart';
import 'package:btcwallet/features/wallet/ui/components/WalletLoadedSuccessComponent.dart';
import 'package:btcwallet/features/wallet/ui/transactionDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../intro/bloc/intro_bloc.dart';
import 'components/WalletBalanceLoadedComponent.dart';
import 'components/WalletErrorComponent.dart';

class WalletHome extends StatefulWidget {
  var walletName = "";
  var walletAddress = "";

  WalletHome(this.walletName, this.walletAddress, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletHome> {
  @override
  void initState() {
    walletBloc.add(WalletHomeLoadedEvent(widget.walletName));
    transactionsBloc.add(FetchTransactionsEvent(widget.walletName));

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
                  return const CircularProgressComponent();

                case WalletLoadedSuccessState:
                  final walletLoadedSuccessState =
                      state as WalletLoadedSuccessState;
                  walletBloc.add(FetchWalletBalance(widget.walletName,
                      walletLoadedSuccessState.walletAddress));
                  return WalletLoadedSuccessComponent(
                      widget.walletName, walletBloc, walletLoadedSuccessState);

                case NavigateToHomePageActionState:
                  return NavigateToHomePageComponent(
                      widget.walletName, walletBloc, widget.walletAddress);

                case WalletBalanceLoadingState:
                  return WalletBalanceLoadingComponent(
                      widget.walletName, walletBloc, widget.walletAddress);

                case WalletBalanceLoadedState:
                  final walletBalanceLoadedState =
                      state as WalletBalanceLoadedState;
                  return WalletBalanceLoadedComponent(
                      walletBloc, walletBalanceLoadedState, widget.walletName);

                case WalletErrorState:
                  return WalletErrorComponent("An error occured, please try again later");

                default:
                  return SizedBox();
              }
            }),
        height: 375,
      ),
      /////////////////////////////////////////////////////////////////////////////////////////////
      Container(
        child: BlocConsumer<TransactionsBloc, TransactionsState>(
            bloc: transactionsBloc,
            //listen for emitted action states and perform an action
            listenWhen: (previous, current) =>
                current is TransactionsActionState,
            //build when there is no action state
            buildWhen: (previous, current) =>
                current is! TransactionsActionState,
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
                  print("TransactionsLoadedSuccessState#########33");
                  final transactionsLoadedSuccessState =
                      state as TransactionsLoadedSuccessState;
                  return Column(
                    children: [

                      Row(
                        children: [
                          Spacer(),
                          const Text(
                            "Transactions",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 20,
                                decoration: TextDecoration.none),
                          ),
                          Spacer(),
                          Material(
                              color: Colors.black,
                              child: IconButton(
                                onPressed: () {
                                  transactionsBloc.add(FetchTransactionsEvent(
                                      widget.walletName));
                                },
                                icon: const Icon(
                                  Icons.refresh,
                                  color: Colors.yellow,
                                ),
                              )),
                          Spacer(),
                        ],
                      ),
                      Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: transactionsLoadedSuccessState
                                  .jsonData.length,
                              itemBuilder: (context, index) {
                                print("listview builder");
                                if (transactionsLoadedSuccessState
                                        .jsonData[index]["category"] ==
                                    "receive") {
                                  print("listtile:receive");
                                  return Material(
                                    color: Colors.black,
                                    child: Card(
                                        color: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //set border radius more than 50% of height and width to make circle
                                        ),
                                        child: ListTile(
                                          leading: const Icon(Icons.call_received,
                                              color: Colors.black),
                                          title: Text(
                                            "Received " +
                                                transactionsLoadedSuccessState
                                                    .jsonData[index]["amount"]
                                                    .toString() +
                                                " BTC",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => TransactionDetails(transactionsLoadedSuccessState
                                                  .jsonData[index]["txid"],widget.walletName)),
                                            );
                                          },
                                        )),
                                  );
                                } else {
                                  print("listtile:send");
                                  return Material(
                                      color: Colors.black,
                                      child: Card(
                                        color: Colors.yellow,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          //set border radius more than 50% of height and width to make circle
                                        ),
                                        child: ListTile(
                                          leading: const Icon(Icons.call_made,
                                              color: Colors.black),
                                          title: Text(
                                            "Sent " +
                                                transactionsLoadedSuccessState
                                                    .jsonData[index]["amount"]
                                                    .toString() +
                                                " BTC",
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                decoration:
                                                    TextDecoration.none),
                                          ),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => TransactionDetails(transactionsLoadedSuccessState
                                                  .jsonData[index]["txid"],widget.walletName)),
                                            );
                                          },
                                        ),
                                      ));
                                }
                              }))
                    ],
                  );

                default:
                  print("default");
                  return SizedBox();
              }
            }),
        height: 285,
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
