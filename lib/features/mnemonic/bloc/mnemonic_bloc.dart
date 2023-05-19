import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../../utils/globalVariables.dart';
import 'package:http/http.dart' as http;

part 'mnemonic_event.dart';

part 'mnemonic_state.dart';

class MnemonicBloc extends Bloc<MnemonicEvent, MnemonicState> {
  MnemonicBloc() : super(MnemonicInitial()) {
    //on event x, pass a state
    on<FetchMnemonicsEvent>(fetchMnemonicsEvent);
    //on NavigateToConfirmSelectedMnemonicPage event, run a function
    on<NavigateToConfirmSelectedMnemonicPageEvent>(
        navigateToConfirmSelectedMnemonicPage);
    on<CreateWalletSeedEvent>(createWalletSeedEvent);
    on<CreateWalletEvent>(createWallet);
    on<SetWalletSeedEvent>(setWalletSeedEvent);
  }

  Future<FutureOr<void>> fetchMnemonicsEvent(
      FetchMnemonicsEvent event, Emitter<MnemonicState> emit) async {
    print("fetchMnemonicsEvent");
    //emit a state
    emit(MnemonicLoadingState());
    var urlPrefix = GlobalVariables.urlPrefix;

    final url = Uri.parse('$urlPrefix/create-mnemonic');

    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "entropy": "256",
    });
    final response = await http.post(url, headers: headers, body: json);
    var mnemonic = response.body;
    var cleanString = mnemonic.replaceAll('"', '');
    var mnemonicList = cleanString.split(' ');
    if (kDebugMode) {
      print(mnemonicList);
      print('Status code: ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      emit(MnemonicLoadedSuccessState(mnemonicList));
    } else {
      emit(MnemonicErrorState());
    }
  }

  FutureOr<void> navigateToConfirmSelectedMnemonicPage(
      NavigateToConfirmSelectedMnemonicPageEvent event,
      Emitter<MnemonicState> emit) {
    print('navigate to confirmed selected mnemonic page');
    //emit a state
    emit(NavigateToConfirmSelectedMnemonicPageActionState(
        event.finalMnemonicPhrase));
  }

  Future<FutureOr<void>> createWalletSeedEvent(
      CreateWalletSeedEvent event, Emitter<MnemonicState> emit) async {
    emit(MnemonicLoadingState());

    print(event.finalMnemonicPhrase);
    var urlPrefix = GlobalVariables.urlPrefix;
    final url = Uri.parse('$urlPrefix/create-wallet-seed');
    print("url##: " + url.toString());
    var string = event.finalMnemonicPhrase.join(' ');
    print("finalstring" + string);
    final headers = {"Content-type": "application/json"};
    final json = jsonEncode({
      "mnemonic": string,
    });
    final response = await http.post(url, headers: headers, body: json);
    if (kDebugMode) {
      print("url##: " + url.toString());
      print("jsonData##: " + json.toString());
      print('Status code: ${response.statusCode}');
      print('Body: ${response.body}');
    }
    var seed = response.body;
    if (response.statusCode == 200) {
      emit(CreateWalletName(seed));
    } else {
      emit(MnemonicErrorState());
    }
  }

  Future<FutureOr<void>> createWallet(
      CreateWalletEvent event, Emitter<MnemonicState> emit) async {
    var urlPrefix = GlobalVariables.urlPrefix;

    emit(MnemonicLoadingState());
    final url = Uri.parse('$urlPrefix/create-wallet');
    print("url##: " + url.toString());

    final headers = {"Content-type": "application/json"};
    if (event.walletPassword == "") {
      final json =
          jsonEncode({"walletName": event.walletName, "seed": event.seedHex});
      final response = await http.post(url, headers: headers, body: json);
      if (kDebugMode) {
        print("url##: " + url.toString());
        print("jsonData##: " + json.toString());
        print('Status code: ${response.statusCode}');
        print('Body: ${response.body}');
      }
      if (response.statusCode == 200) {
        add(SetWalletSeedEvent(event.walletName,event.seedHex));
      }
    } else {
      final json = jsonEncode({
        "walletName": event.walletName,
        "walletPassword": event.walletPassword,
        "seed": event.seedHex
      });
      final response = await http.post(url, headers: headers, body: json);
      if (kDebugMode) {
        print("url##: " + url.toString());
        print("jsonData##: " + json.toString());
        print('Status code: ${response.statusCode}');
        print('Body: ${response.body}');
      }
      if (response.statusCode == 200) {
        //setWalletSeed(event, emit);
        add(SetWalletSeedEvent(event.walletName,event.seedHex));
      }
    }
  }


  Future<FutureOr<void>> setWalletSeedEvent(SetWalletSeedEvent event, Emitter<MnemonicState> emit) async {
      print("set wallet seed");
      var urlPrefix = GlobalVariables.urlPrefix;
      final url = Uri.parse('$urlPrefix/set-wallet-seed');
      print("url##: " + url.toString());
      final headers = {"Content-type": "application/json"};
      final json = jsonEncode({
        "walletName": event.walletName,
        "seed": event.seedHex    });
      final response = await http.post(url, headers: headers, body: json);
      if (kDebugMode) {
        print("url##: " + url.toString());
        print("jsonData##: " + json.toString());
        print('Status code: ${response.statusCode}');
        print('Body: ${response.body}');
      }
      if (response.statusCode == 200) {
          emit(NavigateToWalletHomeActionState());

      }
  }
}
