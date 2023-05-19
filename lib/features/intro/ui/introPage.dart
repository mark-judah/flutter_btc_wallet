import 'dart:async';

import 'package:btcwallet/states/walletState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../mnemonic/ui/mnemonicWordList.dart';
import 'package:provider/provider.dart';

import '../../wallet/ui/walletHome.dart';
import '../bloc/intro_bloc.dart';

void main() {
  runApp(const MaterialApp(
    home: IntroPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<IntroPage> {
  @override
  void initState() {
    introBloc.add(CheckSecureStorageEvent());
    super.initState();
  }

  final IntroBloc introBloc = IntroBloc();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IntroBloc, IntroState>(
        bloc: introBloc,
        //listen for emitted action states and perform an action
        listenWhen: (previous, current) => current is IntroActionState,
        //build when there is no action state
        buildWhen: (previous, current) => current is! IntroActionState,
        listener: (context, state) {
          if (state is NavigateToHomePageActionState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletHome(state.walletName,state.walletAddress)),
            );
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case IntroLoadingState:
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.yellow,
                  ),
                ),
              );
            case IntroLoadedSuccessState:
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WordList()),
                            );
                          },
                          child: const Text('Create a new wallet'),
                        ),
                        MaterialButton(
                          color: Colors.yellow,
                          textColor: Colors.black,
                          onPressed: () {},
                          child: const Text('Already Have a wallet'),
                        )
                      ],
                    ),
                  ]),
                ),
              );

            default:
              return SizedBox();
          }
        });
  }
}
