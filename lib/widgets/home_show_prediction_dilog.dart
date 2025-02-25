import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                  'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), // Current date
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