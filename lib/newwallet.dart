import 'package:btcwallet/confirmphrase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:provider/provider.dart';
import 'package:btcwallet/states/walletState.dart';

class NewWallet extends StatefulWidget {
  List mnemonicList;
  var pressed = [];
  var finalMnemonicPhrase = [];

  NewWallet(this.mnemonicList, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<NewWallet> {
  @override
  void initState() {
    widget.pressed = List<bool>.filled(24, true, growable: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<walletState>(
            create: (_) => walletState(),
          ),
        ],
        builder: (context, child) {
          // var wallet = Provider.of<walletState>(context);
          // var mnemonicList=wallet.mnemonicVals;
          print(widget.mnemonicList);
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
                            i < widget.mnemonicList.length;
                            i++) ...[
                          Padding(
                              padding: EdgeInsets.all(2),
                              child: Container(
                                height: 30,
                                child: TextButton(
                                  onPressed: () {
                                    var item = widget.mnemonicList[i];
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
                                    widget.mnemonicList.elementAt(i),
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
                Text(widget.finalMnemonicPhrase.length.toString(),
                    style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.yellow,
                        decoration: TextDecoration.none)),
                MaterialButton(
                  color: Colors.yellow,
                  textColor: Colors.black,
                  onPressed: () {
                    if (widget.finalMnemonicPhrase.length < 12) {
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ConfirmPhrase(widget.finalMnemonicPhrase)),
                      );
                    }
                  },
                  child: const Text('Continue'),
                )
              ],
            ),
          );
        });
  }
}
