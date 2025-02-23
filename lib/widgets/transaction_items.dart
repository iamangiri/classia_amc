import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({required this.transaction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5), // 1px gray border
      ),
      elevation: 2, // Reduced elevation for a cleaner look
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Transaction Icon
            CircleAvatar(
              backgroundColor: transaction.type == 'investment'
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              radius: 24,
              child: Icon(
                transaction.type == 'investment'
                    ? FontAwesomeIcons.arrowUpRightDots
                    : FontAwesomeIcons.arrowDownShortWide,
                color: transaction.type == 'investment' ? Colors.green : Colors.red,
                size: 22,
              ),
            ),
            SizedBox(width: 14),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹${transaction.amount.toStringAsFixed(2)}', // INR Symbol
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Date: ${transaction.date.toString()}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),

            // Modern Jockey Point Badge
            Container(
              padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.amber.shade800, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(FontAwesomeIcons.medal, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text(
                    '${transaction.rating} Pts',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
