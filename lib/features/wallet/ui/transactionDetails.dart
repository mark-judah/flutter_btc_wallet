import 'package:btcwallet/features/wallet/ui/components/TransactionDetailsLoadedComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc2/transactions_bloc.dart';
import 'components/CircularProgressIndicator.dart';

class TransactionDetails extends StatefulWidget {
  String txid = "";
  String walletName = "";

  TransactionDetails(this.txid, this.walletName, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TransactionDetails> {
  @override
  void initState() {
    transactionsBloc
        .add(FetchTransactionDetailsEvent(widget.txid, widget.walletName));
    super.initState();
  }

  final TransactionsBloc transactionsBloc = TransactionsBloc();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: BlocConsumer<TransactionsBloc, TransactionsState>(
                bloc: transactionsBloc,
                //listen for emitted action states and perform an action
                listenWhen: (previous, current) =>
                    current is TransactionsActionState,
                //build when there is no action state
                buildWhen: (previous, current) =>
                    current is! TransactionsActionState,
                listener: (context, state) {},
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case TransactionDetailsLoadingState:
                      return const CircularProgressComponent();

                    case TransactionDetailsLoadedSuccessState:
                      final transactionDetailsLoadedSuccessState =
                      state as TransactionDetailsLoadedSuccessState;
                      return  TransactionDetailsLoadedComponent(transactionDetailsLoadedSuccessState);

                    default:
                      return SizedBox();
                  }
                }))
      ],
    );
  }
}
