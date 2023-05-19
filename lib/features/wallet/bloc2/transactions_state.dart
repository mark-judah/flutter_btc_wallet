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

}

class TransactionsNullState extends TransactionsState{

}

class TransactionsErrorState extends TransactionsState{

}