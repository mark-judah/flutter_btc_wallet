import 'dart:convert';

import 'package:btcwallet/features/wallet/ui/walletHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../../utils/globalVariables.dart';
import '../../mnemonic/bloc/mnemonic_bloc.dart';

class WalletName extends StatefulWidget {
  var seedHex = "";

  WalletName(this.seedHex, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WalletName> {
  @override
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController walletNameController;
  late final TextEditingController walletPasswordController;

  void initState() {
    super.initState();
    walletNameController = TextEditingController(text: '');
    walletPasswordController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    walletNameController.dispose();
    walletPasswordController.dispose();
    super.dispose();
  }

  final MnemonicBloc mnemonicBloc = MnemonicBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MnemonicBloc, MnemonicState>(
        bloc: mnemonicBloc,
        listener: (context, state) {
      if (state is NavigateToWalletHomeActionState) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WalletHome(walletNameController.text,"")),
        );
      }
    },
    builder: (context, state) {
      switch (state.runtimeType) {
        case MnemonicLoadingState:
          return Container(
            color: Colors.black,
            child: const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.yellow,
              ),
            ),
          );
        default:
          return Scaffold(
            body: Container(
              color: Colors.black,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    ),
                    const Text(
                      'Final Step',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    ),
                    TextFormField(
                      controller: walletNameController,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.yellow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: 'Enter a wallet name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a wallet name';
                        }

                        return null;
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30, left: 20, right: 20),
                    ),
                    TextFormField(
                      controller: walletPasswordController,
                      style: TextStyle(color: Colors.black),

                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.yellow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        labelText: 'Secure your wallet with a password(Optional)',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 100, left: 20, right: 20),
                    ),
                    MaterialButton(
                      color: Colors.yellow,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          print(walletNameController.text);
                          print(walletPasswordController.text);

                          //move mnemonic block to wallet block
                          mnemonicBloc.add(CreateWalletEvent(walletNameController.text,walletPasswordController.text,widget.seedHex));
                        }
                      },
                      child: const Text('Create Wallet'),
                    ),
                  ],
                ),
              ),
            ),
          );
      }
    });
  }
}


