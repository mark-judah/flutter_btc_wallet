import 'package:btcwallet/features/mnemonic/ui/confirmSelectedMnemonic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/mnemonic_bloc.dart';

class WordList extends StatefulWidget {
  var pressed = [];
  var finalMnemonicPhrase = [];

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WordList> {
  @override
  void initState() {
    widget.pressed = List<bool>.filled(24, true, growable: false);

    mnemonicBloc.add(FetchMnemonicsEvent());
    super.initState();
  }

  final MnemonicBloc mnemonicBloc =
      MnemonicBloc(); //-> This creates an instance of the class MnemonicBloc
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MnemonicBloc, MnemonicState>(
      bloc: mnemonicBloc,
      //listen for emitted action states and perform an action
      listenWhen: (previous, current) => current is MnemonicActionState,
      //build when there is no action state
      buildWhen: (previous, current) => current is! MnemonicActionState,
      listener: (context, state) {
        if (state is NavigateToConfirmSelectedMnemonicPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ConfirmPhrase(state.finalMnemonicPhrase)),
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
          case MnemonicLoadedSuccessState:
            final mnemonicLoadedSuccessState =
                state as MnemonicLoadedSuccessState;
            print(mnemonicLoadedSuccessState.mnemonicList[23]);
            return Container(
              color: Colors.black,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: Text(
                      'Select words for your secret phrase',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(25),
                    child: Text(
                      'If you ever lose access to your wallet, '
                      'you can use this phrase to restore it on'
                      ' any other device or wallet software that '
                      'supports the same standard. It is important '
                      'to keep this phrase private and secure, as'
                      ' anyone who knows it can gain access to your funds.'
                      ' We highly recommend writing it down and storing it '
                      'in a safe and secure place, separate from your device.'
                      'You must choose a minimum of 12 words.',
                      style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 15,
                          decoration: TextDecoration.none),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 300.0,
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: (1 / .4),
                        ),
                        children: [
                          for (var i = 0;
                              i <
                                  mnemonicLoadedSuccessState
                                      .mnemonicList.length;
                              i++) ...[
                            Padding(
                                padding: EdgeInsets.all(2),
                                child: Container(
                                  height: 30,
                                  child: TextButton(
                                    onPressed: () {
                                      var item = mnemonicLoadedSuccessState.mnemonicList[i];
                                      print(item);
                                      setState(() {
                                        widget.pressed[i] = !widget.pressed[i];
                                        if (widget.finalMnemonicPhrase
                                            .contains(item)) {
                                          widget.finalMnemonicPhrase.remove(item);
                                        } else {
                                          widget.finalMnemonicPhrase.add(item);
                                        }
                                      });
                                      print("finalPhrase" +
                                          widget.finalMnemonicPhrase.toString());

                                    },
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.white),
                                    child: Text(
                                      mnemonicLoadedSuccessState.mnemonicList
                                          .elementAt(i),
                                      style: widget.pressed[i]
                                          ? TextStyle(color: Colors.black)
                                          : TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ))
                          ],
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  if(widget.finalMnemonicPhrase!=[])...[
                    Text(widget.finalMnemonicPhrase.length.toString(),
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.yellow,
                            decoration: TextDecoration.none))
                  ],
                  MaterialButton(
                    color: Colors.yellow,
                    textColor: Colors.black,
                    onPressed: () {

                      if (widget.finalMnemonicPhrase.length <
                          12) {
                        Flushbar(
                          flushbarPosition: FlushbarPosition.TOP,
                          backgroundColor: Colors.yellow,
                          duration: const Duration(seconds: 3),
                          titleText: const Text(
                            "Oops, The phrase is too short!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                color: Colors.black,
                                fontFamily: "ShadowsIntoLightTwo"),
                          ),
                          messageText: const Text(
                            "You must choose a minimum of 12 words.",
                            style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                                fontFamily: "ShadowsIntoLightTwo"),
                          ),
                        ).show(context);
                      } else {
                        mnemonicBloc
                            .add(NavigateToConfirmSelectedMnemonicPageEvent(widget.finalMnemonicPhrase));
                      }
                    },
                    child: const Text('Continue'),
                  )
                ],
              ),
            );
          case MnemonicErrorState:
            return Scaffold(
                body: Container(
                    color: Colors.black,
                    child: const Center(
                      child: Text("An error occured, try again later",
                          style: TextStyle(color: Colors.yellow, fontSize: 20)),
                    )));

          default:
            return SizedBox();
        }
      },
    );
  }
}
