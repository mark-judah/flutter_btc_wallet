part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsState {}

//this state takes an action
abstract class TransactionsActionState extends TransactionsState{}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoadingState extends TransactionsState{
  //show loading circle

}

class TransactionsLoadedSuccessState extends TransactionsState {
  List<dynamic> jsonData;
  TransactionsLoadedSuccessState(this.jsonData);

}

class TransactionsNullState extends TransactionsState{

}

class TransactionsErrorState extends TransactionsState{

}

class InsufficientFundsErrorState extends TransactionsState{

}
class SendRawTransactionSuccessState extends TransactionsState{

}

class TransactionDetailsLoadingState extends TransactionsState{

}

class TransactionDetailsLoadedSuccessState extends TransactionsState{
  var transactionDetails={};
  TransactionDetailsLoadedSuccessState(this.transactionDetails);

}

