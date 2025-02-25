import 'package:flutter/material.dart';

import '../themes/light_app_theme.dart';

Widget buildRecentPredictions(List<Map<String, dynamic>> predictions) {
  return Padding(
    padding: EdgeInsets.all(16),
    child: Container(
      color: Colors.white, // Use theme card color
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Predictions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.lightTheme.primaryColor, // Use theme primary color
                  ),
                ),
                // Filter Dropdown
                Container(
  decoration: BoxDecoration(
    border: Border.all(
      color: AppTheme.lightTheme.primaryColor, // Border color
      width: 1.0, // Border width
    ),
    borderRadius: BorderRadius.circular(8), // Rounded corners
  ),
  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 12), // Add some padding inside the container
    child: DropdownButton<String>(
      value: '10 Days', // Default filter
      icon: Icon(Icons.filter_list, color: AppTheme.lightTheme.primaryColor),
      underline: Container(), // Remove the default underline
      items: ['10 Days', '1 Month', '3 Months'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(
              color: AppTheme.lightTheme.primaryColor, // Use theme primary color
            ),
          ),
        );
      }).toList(),
      onChanged: (String? newValue) {
        // Handle filter change
        // You can update the state to filter predictions based on the selected value
      },
    ),
  ),
),
              ],
            ),
            SizedBox(height: 10),
            // Prediction List
            ...predictions.map((prediction) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.circle, size: 8, color: AppTheme.lightTheme.primaryColor),
              title: Text(
                prediction['date'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predicted: ${prediction['predictedPoints']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    'Achieved: ${prediction['achievedPoints']}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.lightTheme.primaryColor),
            )).toList(),
          ],
        ),
      ),
    ),
  );
}