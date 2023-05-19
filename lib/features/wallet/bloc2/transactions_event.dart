part of 'transactions_bloc.dart';

@immutable
abstract class TransactionsEvent {}

class FetchTransactionsEvent extends TransactionsEvent{}