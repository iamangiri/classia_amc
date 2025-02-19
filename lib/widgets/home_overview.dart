import 'package:flutter/material.dart';

Widget buildOverview(String totalAssets, String nav, String lotValue) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    child: Row(
      children: [
        // Total Assets Card
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Assets',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 6),
                  Text(
                    totalAssets,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue[800]),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12), // Spacing between cards
        // NAV Card
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'NAV',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 6),
                  Text(
                    nav,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 12), // Spacing between cards
        // Lot Value Card
        Expanded(
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Lot Value',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 6),
                  Text(
                    lotValue,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
