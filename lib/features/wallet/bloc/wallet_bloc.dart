import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../utils/globalVariables.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final storage = const FlutterSecureStorage();

  WalletBloc() : super(WalletInitial()) {
    on<WalletHomeLoadedEvent>(walletHomeLoadedEvent);
    on<FetchWalletBalance>(fetchWalletBalance);

  }

  Future<FutureOr<void>> walletHomeLoadedEvent(WalletHomeLoadedEvent event, Emitter<WalletState> emit) async {
   emit(WalletLoadingState());
   String? walletAddress = await storage.read(key: "walletAddress");
   if(walletAddress==null) {
     var urlPrefix = GlobalVariables.urlPrefix;
     final url = Uri.parse('$urlPrefix/new-address');
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

     var address = jsonDecode(response.body);
     print(address["walletAddress"]);
     await storage.write(key: "walletAddress", value: address["walletAddress"]);
     await storage.write(key: "walletName", value: event.walletName);

     emit(WalletLoadedSuccessState(address["walletAddress"],""));
   }else{
     String? walletName = await storage.read(key: "walletName");
     emit(WalletLoadedSuccessState(walletAddress,walletName!));
   }

  }

  Future<FutureOr<void>> fetchWalletBalance(FetchWalletBalance event, Emitter<WalletState> emit) async {
    emit(WalletBalanceLoadingState());
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/get-balances');
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

    var body = jsonDecode(response.body);
    var balance=body["getBalances"]["result"]["mine"]["trusted"].toString();
    print(balance);

    emit(WalletBalanceLoadedState(balance,event.walletAddress));
  }
}
