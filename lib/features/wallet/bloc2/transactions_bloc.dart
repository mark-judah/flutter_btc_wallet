import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc() : super(TransactionsInitial()) {
    on<FetchTransactionsEvent>(fetchTransactionsEvent);
  }



  FutureOr<void> fetchTransactionsEvent(FetchTransactionsEvent event, Emitter<TransactionsState> emit) {
    print("fetchTransactionsEvent");

    emit(TransactionsLoadingState());
    emit(TransactionsNullState());
  }
}
