abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class FilterTransactions extends TransactionEvent {
  final String filterType; // 'all', 'investment', 'withdrawal'

  FilterTransactions({required this.filterType});
}