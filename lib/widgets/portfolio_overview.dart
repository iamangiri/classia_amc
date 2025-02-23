import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../blocs/portfolio/portfolio_state.dart';

Widget buildPortfolioOverview(PortfolioLoaded state) {
  return Card(
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.grey.shade300, width: 1), // 1px border
    ),
    elevation: 6,
    shadowColor: Colors.black26,
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.grey.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Account Name
          Text(
            state.accountName,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          SizedBox(height: 6),

          // Managed by
          Text(
            "Managed by: ${state.accountManager}",
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          Divider(thickness: 1, color: Colors.grey.shade300, height: 20),

          // Jockey Point with Jockey Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.horse, color: Colors.amber.shade700, size: 24), // Better icon
                  SizedBox(width: 8),
                  Text(
                    "Jockey Point: ${state.joycePoint.toStringAsFixed(1)}/10",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                  ),
                ],
              ),
              Icon(Icons.star, color: Colors.amber[600], size: 26),
            ],
          ),

          SizedBox(height: 12),

          // Warning Message
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200, width: 1), // Added a subtle red border
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 22),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Manage your budget and items carefully during market hours.",
                    style: TextStyle(fontSize: 14, color: Colors.redAccent, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
