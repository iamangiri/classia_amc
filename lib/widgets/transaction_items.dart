import 'package:flutter/material.dart';
import '../models/transaction_model.dart';


class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        leading: Icon(
          transaction.type == 'investment' ? Icons.arrow_upward : Icons.arrow_downward,
          color: transaction.type == 'investment' ? Colors.green : Colors.red,
        ),
        title: Text(
          'Amount: \$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${transaction.date.toString()}',
        ),
        trailing: Chip(
          label: Text('Rating: ${transaction.rating}'),
          backgroundColor: Colors.blueAccent,
          labelStyle: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}