import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../blocs/portfolio/portfolio_state.dart';

Widget buildPortfolioOverview(PortfolioLoaded state) {
  return Card(
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: BorderSide(color: Colors.grey.shade300, width: 1),
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
          // Account Info with Profile Images
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(state.amcImage), // AMC Image
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.accountName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: NetworkImage(state.managerImage), // Manager Image
                        ),
                        SizedBox(width: 6),
                        Text(
                          "Managed by: ${state.accountManager}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(thickness: 1, color: Colors.grey.shade300, height: 20),

          // Jockey Point with Prediction Bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(FontAwesomeIcons.horse, color: Colors.amber.shade700, size: 22),
                  SizedBox(width: 8),
                  Text(
                    "Jockey Point: ${state.joycePoint.toStringAsFixed(1)}/10",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber[800]),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "${state.predictedJockeyPoint.toStringAsFixed(1)}/10",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.trending_up, color: Colors.green, size: 22),
                ],
              ),
            ],
          ),

          SizedBox(height: 8),
          LinearProgressIndicator(
            value: state.predictedJockeyPoint / 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 6,
          ),

          SizedBox(height: 12),

          // Warning Message
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200, width: 1),
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
