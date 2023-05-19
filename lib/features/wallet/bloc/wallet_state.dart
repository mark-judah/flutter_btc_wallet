part of 'wallet_bloc.dart';

@immutable
abstract class WalletState {}

//this state takes an action
abstract class WalletActionState extends WalletState{}

class WalletInitial extends WalletState {}

class WalletLoadingState extends WalletState{
  //show loading circle

}

class WalletLoadedSuccessState extends WalletState {
  String walletAddress="";
  String walletName="";

  WalletLoadedSuccessState(this.walletAddress,this.walletName);
}

class WalletErrorState extends WalletState{

}