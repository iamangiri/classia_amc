class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String type; // 'investment' or 'withdrawal'
  final int rating; // 1 to 10

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.type,
    required this.rating,
  });
}