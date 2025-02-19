import 'package:flutter/material.dart';

Widget buildRecentActivities(List<String> activities) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recent Activities', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...activities.map((activity) => ListTile(
              leading: Icon(Icons.circle, size: 8),
              title: Text(activity),
            )).toList(),
          ],
        ),
      ),
    ),
  );
}