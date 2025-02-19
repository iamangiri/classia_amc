import 'package:flutter/material.dart';

Widget buildOverview(String totalAssets, String nav) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Total Assets', style: TextStyle(fontSize: 18)),
            Text(totalAssets, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('NAV', style: TextStyle(fontSize: 18)),
            Text(nav, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    ),
  );
}