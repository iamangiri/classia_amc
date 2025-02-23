import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/transaction_model.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  List<Transaction> _allTransactions = []; // Store the original list of transactions

  TransactionBloc() : super(TransactionLoading()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<FilterTransactions>(_onFilterTransactions);
  }

  void _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    // Simulate loading transactions from an API
    await Future.delayed(Duration(seconds: 2));
    _allTransactions = [
      Transaction(
        id: '1',
        date: DateTime.now(),
        amount: 1000,
        type: 'investment',
        rating: 8,
      ),
      Transaction(
        id: '2',
        date: DateTime.now().subtract(Duration(days: 1)),
        amount: 500,
        type: 'withdrawal',
        rating: 5,
      ),
      Transaction(
        id: '3',
        date: DateTime.now().subtract(Duration(days: 2)),
        amount: 1500,
        type: 'investment',
        rating: 9,
      ),
      Transaction(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 3)),
        amount: 200,
        type: 'withdrawal',
        rating: 4,
      ),
      Transaction(
        id: '5',
        date: DateTime.now().subtract(Duration(days: 4)),
        amount: 3000,
        type: 'investment',
        rating: 10,
      ),
      // Add more transactions as needed
    ];
    emit(TransactionLoaded(transactions: _allTransactions));
  }

  void _onFilterTransactions(FilterTransactions event, Emitter<TransactionState> emit) {
    final state = this.state as TransactionLoaded;
    List<Transaction> filteredTransactions = _allTransactions; // Use the original list

    if (event.filterType == 'investment' || event.filterType == 'withdrawal') {
      filteredTransactions = _allTransactions.where((t) => t.type == event.filterType).toList();
    } else if (event.filterType == '1d') {
      filteredTransactions = _allTransactions
          .where((t) => t.date.isAfter(DateTime.now().subtract(Duration(days: 1))))
          .toList();
    } else if (event.filterType == '1w') {
      filteredTransactions = _allTransactions
          .where((t) => t.date.isAfter(DateTime.now().subtract(Duration(days: 7))))
          .toList();
    } else if (event.filterType == '1m') {
      filteredTransactions = _allTransactions
          .where((t) => t.date.isAfter(DateTime.now().subtract(Duration(days: 30))))
          .toList();
    }

    emit(TransactionLoaded(transactions: filteredTransactions, filterType: event.filterType));
  }
}