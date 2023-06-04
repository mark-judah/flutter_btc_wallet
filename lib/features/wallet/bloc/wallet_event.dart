part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent {}

class WalletHomeLoadedEvent extends WalletEvent{
  String walletName;
  WalletHomeLoadedEvent(this.walletName);
//getnewAddress
}

class FetchWalletBalance extends WalletEvent{
  String walletName;
  String walletAddress;

  FetchWalletBalance(this.walletName, this.walletAddress);

}