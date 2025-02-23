import '../../models/transaction_model.dart';

abstract class TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final String filterType;

  TransactionLoaded({required this.transactions, this.filterType = 'all'});

  // Helper methods to calculate totals
  double get totalDeposit {
    return transactions
        .where((t) => t.type == 'investment')
        .fold(0, (sum, t) => sum + t.amount);
  }

  double get totalWithdrawal {
    return transactions
        .where((t) => t.type == 'withdrawal')
        .fold(0, (sum, t) => sum + t.amount);
  }
}