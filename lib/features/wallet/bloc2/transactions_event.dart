part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsEvent {}

class FetchTransactionsEvent extends TransactionsEvent{
  String walletName;
  FetchTransactionsEvent(this.walletName);
}

class CreateRawTransactionsEvent extends TransactionsEvent{
  String walletName;
  String balance;
  double sendAmount;
  String myWalletAddress;
  String recipientWalletAddress;

  CreateRawTransactionsEvent(this.walletName,this.balance, this.sendAmount,this.myWalletAddress,this.recipientWalletAddress);

}
class FetchTransactionDetailsEvent extends TransactionsEvent {
  String txid;
  String walletName;

  FetchTransactionDetailsEvent(this.txid,this.walletName);

}