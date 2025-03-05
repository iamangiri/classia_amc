import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../themes/light_app_theme.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Notification Header
            _buildNotificationHeader(),

            SizedBox(height: 20),

            // Notification List
            _buildNotificationTile(
              "New Investment Opportunity",
              "A new mutual fund scheme is available for investment.",
              "2 hours ago",
              FontAwesomeIcons.chartLine,
            ),
            _buildNotificationTile(
              "Portfolio Update",
              "Your portfolio value has increased by 5% this week.",
              "1 day ago",
              FontAwesomeIcons.wallet,
            ),
            _buildNotificationTile(
              "Transaction Successful",
              "Your investment of ₹10,000 in XYZ Fund was successful.",
              "3 days ago",
              FontAwesomeIcons.checkCircle,
            ),
            _buildNotificationTile(
              "Market Alert",
              "The stock market is experiencing high volatility.",
              "5 days ago",
              FontAwesomeIcons.bell,
            ),
            _buildNotificationTile(
              "Referral Bonus",
              "You earned ₹500 for referring a friend.",
              "1 week ago",
              FontAwesomeIcons.gift,
            ),
          ],
        ),
      ),
    );
  }

  // Notification Header
  Widget _buildNotificationHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Row(
        children: [
          FaIcon(FontAwesomeIcons.bell, size: 24, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Notifications",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Notification ListTile
  Widget _buildNotificationTile(String title, String subtitle, String time, IconData icon) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: FaIcon(icon, color: AppTheme.lightTheme.primaryColor),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle),
            SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        trailing: FaIcon(FontAwesomeIcons.angleRight, size: 18, color: Colors.grey),
      ),
    );
  }
}