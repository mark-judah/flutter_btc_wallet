import 'package:btcwallet/features/wallet/ui/walletHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc2/transactions_bloc.dart';
import 'components/CircularProgressIndicator.dart';
import 'components/WalletErrorComponent.dart';

class SendBitcoin extends StatefulWidget {
  String walletBalance = "";
  String walletAddress = "";
  String walletName = "";

  SendBitcoin(this.walletBalance, this.walletAddress, this.walletName,
      {Key? key})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<SendBitcoin> {
  @override
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController receipientAddressController;
  late final TextEditingController amountController;

  void initState() {
    receipientAddressController = TextEditingController(text: '');
    amountController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    receipientAddressController.dispose();
    amountController.dispose();
    super.dispose();
  }

  final TransactionsBloc transactionsBloc = TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
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
              print(state);
              switch (state.runtimeType) {
                case TransactionDetailsLoadingState:
                  return CircularProgressComponent();

                case SendRawTransactionSuccessState:
                  return WalletHome(widget.walletName,widget.walletAddress);

                case TransactionsErrorState:
                  return WalletErrorComponent(
                      "An error occured, please try again later");

                default:
                  return Scaffold(
                      body: Container(
                    color: Colors.black,
                    child: Column(
                      children: [
                        const Padding(
                          padding:
                              EdgeInsets.only(top: 40, left: 20, right: 20),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Send Bitcoin",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 20,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30, left: 20, right: 20),
                                child: TextFormField(
                                  controller: receipientAddressController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.yellow,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    labelText: 'Recipient Address',
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.qr_code_scanner),
                                      color: Colors.black,
                                      onPressed: () {},
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an address';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30, left: 20, right: 20),
                                child: TextFormField(
                                  controller: amountController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.yellow,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    labelText: 'BTC Amount',
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an anount';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 30, bottom: 30, left: 20, right: 20),
                                child: Text(
                                  'Wallet Balance: ' + widget.walletBalance,
                                  style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 15,
                                      decoration: TextDecoration.none),
                                ),
                              ),
                              MaterialButton(
                                color: Colors.yellow,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    print(receipientAddressController.text);
                                    print(amountController.text);

                                    transactionsBloc
                                        .add(CreateRawTransactionsEvent(
                                      widget.walletName,
                                      widget.walletBalance,
                                      double.parse(amountController.text),
                                      widget.walletAddress,
                                      receipientAddressController.text,
                                    ));
                                  }
                                },
                                child: const Text('Send BTC'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
              }
            }));
  }
}
