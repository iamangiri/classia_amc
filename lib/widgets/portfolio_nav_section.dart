import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildNAVSection(double currentNAV, double unitValue) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      _buildCard("Current NAV", currentNAV, Colors.green, FontAwesomeIcons.chartLine),
      _buildCard("Unit Value", unitValue, Colors.blue, FontAwesomeIcons.wallet),
    ],
  );
}

Widget _buildCard(String title, double value, Color valueColor, IconData icon) {
  return Expanded(
    child: Card(
      margin: EdgeInsets.all(12),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: valueColor), // Icon added
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(FontAwesomeIcons.indianRupeeSign, size: 16, color: valueColor), // INR Icon
                SizedBox(width: 4),
                Text(value.toStringAsFixed(2),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
