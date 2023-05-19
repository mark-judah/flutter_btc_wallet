part of 'wallet_bloc.dart';

@immutable
abstract class WalletEvent {}

class WalletHomeLoadedEvent extends WalletEvent{
  String walletName;
  WalletHomeLoadedEvent(this.walletName);
//getnewAddress
}