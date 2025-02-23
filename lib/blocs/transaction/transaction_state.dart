import '../../models/transaction_model.dart';

abstract class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final String filterType;

  TransactionLoaded({required this.transactions, this.filterType = 'all'});
}