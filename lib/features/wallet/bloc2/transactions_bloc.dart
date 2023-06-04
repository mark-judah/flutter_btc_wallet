import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../utils/globalVariables.dart';
import 'package:http/http.dart' as http;

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(TransactionsInitial()) {
    on<FetchTransactionsEvent>(fetchTransactionsEvent);
    on<CreateRawTransactionsEvent>(createRawTransactionsEvent);
    on<FetchTransactionDetailsEvent>(fetchTransactionDetailsEvent);
  }

  Future<FutureOr<void>> fetchTransactionsEvent(FetchTransactionsEvent event,
      Emitter<TransactionsState> emit) async {
    emit(TransactionsLoadingState());
    print("fetchTransactionsEvent");
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/list-transactions');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "walletName": event.walletName,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = jsonDecode(response.body);

    if (jsonData == []) {
      emit(TransactionsNullState());
    } else {
      print(jsonData);
      //sort the list to show only the relevant transactions to the user, show the main
      //transaction to the user and show the change transaction and the transaction payment deduction
      //inside the main transaction details page.

      var sortedList = sortedTransactionsList(
          jsonData['data']['result'].reversed.toList());

      emit(TransactionsLoadedSuccessState(sortedList));
    }
  }

  Future<FutureOr<void>> createRawTransactionsEvent(
      CreateRawTransactionsEvent event, Emitter<TransactionsState> emit) async {
    var balance = double.parse(event.balance);
    var sendAmount = event.sendAmount;
    var minersFees = 0.00000185;
    var transactionCost = 0.04 * sendAmount;
    var roundedtransactionCost =
    double.parse(transactionCost.toStringAsFixed(8));
    var totalCost = sendAmount + minersFees + roundedtransactionCost;
    //todo: totalCost should always be less than the wallet balance

    print("totalInputsCost: " + totalCost.toString());

    var recepientAddress = event.recipientWalletAddress;
    var transactionCostAddress = "tb1q4x37a8m8zy9maq36ftlayltlgku0zzuhkq6atg";
    //outputs should not be repeated for privacy reasons, create a new address for change
    var transactionChangeAddress = await getNewAddress(event.walletName);

    var inputs = [];
    var outputs = [];

    double inputAmounts = 0.0;

    if (balance < totalCost) {
      emit(InsufficientFundsErrorState());
    } else {
      var unspentTransactions =
      await getUnspentTransactions(event.walletName)
      as List;

      //sort transactions by highest amount, to lower the input size,hence lowering the mining fee
      var sortedUnspentTransactions = [];
      var amounts = <double>[];

      print('unspentTransactions.length:' +
          unspentTransactions.length.toString());

      for (int i = 0; i < unspentTransactions.length; i++) {
        var amount = unspentTransactions[i]['amount'];
        amounts.add(amount);
      }
      amounts.sort();
      var reversedAmounts = new List.from(amounts.reversed);
      print(amounts);

      for (int i = 0; i < reversedAmounts.length; i++) {
        for (int j = 0; j < unspentTransactions.length; j++) {
          if (unspentTransactions[j]['amount'] == reversedAmounts[i]) {
            sortedUnspentTransactions.add(unspentTransactions[i]);
            break;
          }
        }
      }

      print(sortedUnspentTransactions.length);
      print(sortedUnspentTransactions);

      for (int i = 0; i < sortedUnspentTransactions.length; i++) {
        if (inputAmounts < totalCost) {
          inputAmounts = inputAmounts + unspentTransactions[i]['amount'];
          inputs.add({
            "txid": "${unspentTransactions[i]['txid']}",
            "vout": unspentTransactions[i]['vout'],
            "sequence": 1
          });
        } else {
          break;
        }
      }
    }
    print("totalInputs: " + inputs.toString());

    var transactionChange = inputAmounts - totalCost;
    var roundedTransactionChange =
    double.parse(transactionChange.toStringAsFixed(8));

    print("totalChange: " + roundedTransactionChange.toString());

    outputs.add({"${recepientAddress}": event.sendAmount});
    outputs.add({"${transactionCostAddress}": roundedtransactionCost});
    outputs.add({"${transactionChangeAddress}": roundedTransactionChange});

    var totaloutput = event.sendAmount + roundedTransactionChange +
        roundedtransactionCost;

    print("totalsendAmount: " + event.sendAmount.toString());
    print("totaloutput: " + totaloutput.toString());


    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/create-raw-transaction');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({"inputs": inputs, "outputs": outputs});
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = await jsonDecode(response.body);
    print("hex: " + jsonData['data']['result'].toString());

    signRawTransaction(jsonData['data']['result'], event.walletName);
  }

  Future<List> getUnspentTransactions(String walletName) async {
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/list-unspent-transactions');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "walletName": walletName,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = jsonDecode(response.body);
    return jsonData['data']['result'];
  }

  Future<void> signRawTransaction(transactionHexString,
      String walletName) async {
    emit(TransactionDetailsLoadingState());
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/sign-raw-transaction');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "walletName": walletName,
      "transactionHexString": transactionHexString,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = await jsonDecode(response.body);

    print("rawT: " + jsonData.toString());
    String signedTransactionHex = jsonData['data']['result']['hex'];
    sendRawTransaction(signedTransactionHex);
  }

  Future<void> sendRawTransaction(String signedTransactionHex) async {
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/send-raw-transaction');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "signedTransactionHexString": signedTransactionHex,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = jsonDecode(response.body);
    if (jsonData['data']['result'] != "") {
      emit(SendRawTransactionSuccessState());
    } else {
      emit(TransactionsErrorState());
    }
  }

  Future<FutureOr<void>> fetchTransactionDetailsEvent(
      FetchTransactionDetailsEvent event,
      Emitter<TransactionsState> emit) async {
    emit(TransactionDetailsLoadingState());
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/get-transaction');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "walletName": event.walletName,
      "txid": event.txid,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var jsonData = jsonDecode(response.body);
    emit(TransactionDetailsLoadedSuccessState(jsonData));
  }

  Future<String> getNewAddress(String walletName) async {
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/new-address');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "walletName": walletName,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }

    if (response.statusCode == 500) {
      print("!!!!!!!!!!!!!!!!!!!!!ERROR:$url " +
          jsonDecode(response.body)["data"]["error"]["message"].toString());
    }
    var address = jsonDecode(response.body);
    print(address["walletAddress"]);

    return address["walletAddress"];
  }

  List sortedTransactionsList(transactions) {
    var Txids = [];
    var sortedTransactions = [];

    for (int i = 0; i < transactions.length; i++) {
      var txid = transactions[i]['txid'];
      Txids.add(txid);
    }

    var distinctTxids = Txids.toSet().toList();

    for (int j = 0; j < distinctTxids.length; j++) {
      for (int i = 0; i < transactions.length; i++) {
        if (distinctTxids[j] == transactions[i]['txid']) {
          //the first transaction [i] is the main transaction for transactions with the same txid
          sortedTransactions.add(transactions[i]);
          break;
        }
      }
    }

    return sortedTransactions;
  }
}