import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc2/transactions_bloc.dart';

class TransactionDetailsLoadedComponent extends StatefulWidget {
  TransactionDetailsLoadedSuccessState transactionDetailsLoadedSuccessState;

  TransactionDetailsLoadedComponent(this.transactionDetailsLoadedSuccessState,
      {Key? key})
      : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TransactionDetailsLoadedComponent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var amount = widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['amount']
        .toString();

    var blockHash='';
    print("blockhash:"+widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['blockhash'].toString());

    if(widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['blockhash']!=null){
      blockHash = widget.transactionDetailsLoadedSuccessState
          .transactionDetails['data']['result']['blockhash']
          .replaceRange(7, 64, '...');
    }

    print("blocktime:"+widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['blocktime'].toString());

    DateTime date=DateTime(0);
    if(widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['blocktime']!=null) {
      var time = widget.transactionDetailsLoadedSuccessState
          .transactionDetails['data']['result']['blocktime'];
      date = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    }
    var confirmations = widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['confirmations']
        .toString();

    var txid=widget.transactionDetailsLoadedSuccessState
        .transactionDetails['data']['result']['txid']
        .toString();

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Transaction Details",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
          ),
          Text(
            amount + " BTC",
            style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.none),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          ),
          Text(
            amount + " USD",
            style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                decoration: TextDecoration.none),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          ),
          const Divider(
            color: Colors.yellow,
            thickness: 1,
            indent: 10,
            endIndent: 10,
          ),
          Row(children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                "Transaction Hash",
                style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 15,
                    decoration: TextDecoration.none),
              ),
            ),
            const Spacer(),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  blockHash,
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 15,
                      decoration: TextDecoration.none),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                )),
            Material(
              color: Colors.black,
              child: IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text: widget.transactionDetailsLoadedSuccessState
                                  .transactionDetails['data']['result']
                              ['blockhash']))
                      .then((_) {
                    Flushbar(
                      flushbarPosition: FlushbarPosition.TOP,
                      backgroundColor: Colors.yellow,
                      duration: const Duration(seconds: 3),
                      messageText: const Text(
                        "Copied to clipboard!",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                            fontFamily: "ShadowsIntoLightTwo"),
                      ),
                    ).show(context);
                  });
                },
                icon: const Icon(
                  Icons.copy,
                  color: Colors.yellow,
                ),
              ),
            ),
          ]),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Confirmations",
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  )),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    confirmations,
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  )),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          ),
          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Date",
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  )),
              Spacer(),
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    date.toString(),
                    style: const TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.none),
                  )),
            ],
          ),
          MaterialButton(
            color: Colors.yellow,
            onPressed: () {
              launchurl(txid);
            },
            child: const Text('View on block Block explorer '),
          ),

        ],
      ),
    );
  }

  Future<void> launchurl(String txid) async {
    var urlString='https://blockstream.info/testnet/tx/$txid';
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
    throw Exception('Could not launch $url');
    }
  }
}
