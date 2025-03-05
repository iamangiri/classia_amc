import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

void showAddPredictionDialog(BuildContext context) {
  final TextEditingController _predictedPointsController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Add Prediction'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _predictedPointsController,
              decoration: InputDecoration(
                labelText: 'Predicted Points',
                hintText: 'Enter predicted points',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final predictedPoints = _predictedPointsController.text;
              if (predictedPoints.isNotEmpty) {
                // Add the new prediction to the list
                final newPrediction = {
                  'date': formatDate(DateTime.now(), [dd, ' ', M, ' ', yyyy]), // "04 Mar 2025"
                  'predictedPoints': predictedPoints,
                  'achievedPoints': '0', // Default achieved points
                };

                // Update the state (you can use a Bloc or StatefulWidget for this)
                // For now, we'll just print the new prediction
                print('New Prediction: $newPrediction');

                Navigator.of(context).pop(); // Close the dialog
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}