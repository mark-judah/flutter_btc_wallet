import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'intro_event.dart';
part 'intro_state.dart';

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final storage = const FlutterSecureStorage();

  IntroBloc() : super(IntroInitial()) {
    on<CheckSecureStorageEvent>(checkSecureStorageEvent);
  }

  Future<FutureOr<void>> checkSecureStorageEvent(CheckSecureStorageEvent event, Emitter<IntroState> emit) async {
    print("checkSecureStorageEvent");
    emit(IntroLoadingState());
    var walletAddress = await storage.read(key: "walletAddress");
    if(walletAddress!=null){
      print("walletAddress!=null");

      var walletName = await storage.read(key: "walletName");
      print(walletName);
      emit(NavigateToHomePageActionState(walletName!,walletAddress));
    }else{
      print("walletAddress========null");

      emit(IntroLoadedSuccessState());
    }

  }
}
