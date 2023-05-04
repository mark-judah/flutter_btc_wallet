import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:btcwallet/pinsecurity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmPhrase extends StatefulWidget {
  var finalMnemonicPhrase = [];

  ConfirmPhrase(this.finalMnemonicPhrase, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ConfirmPhrase> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Text(
              'Confirm secret phrase',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Expanded(
              child: SizedBox(
                height: 300.0,
                child: GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: (1 / .4),
                    ),
                    children: [
                      for (var i = 0;
                          i < widget.finalMnemonicPhrase.length;
                          i++) ...[
                        Padding(
                            padding: EdgeInsets.all(2),
                            child: Container(
                              height: 30,
                              child: Text(
                                "${i + 1}: " +
                                    widget.finalMnemonicPhrase.elementAt(i),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.yellow,
                                ),
                              ),
                            ))
                      ],
                    ]),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 240),
          ),

          MaterialButton(
            color: Colors.yellow,
            textColor: Colors.black,
            onPressed: () {
              AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Warning',
                  desc: 'Ensure that you have saved the secret phrase before proceeding,'
                      ' if you loose your phrase you loose access to your funds.',
                  dialogBackgroundColor: Colors.yellow,
                  btnCancelColor: Colors.black,
                  btnOkColor: Colors.black,

                  btnCancelOnPress: () {

                  },
              btnOkOnPress: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (
                      context) => PinSecurity(widget.finalMnemonicPhrase)),
                );
              },
              ).show();
            },
            child: const Text('Done'),
          )
        ]),
      ),
    );
  }
}
