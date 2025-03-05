import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../themes/light_app_theme.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.white)),
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
            _buildSettingsHeader(),

            SizedBox(height: 20),

            _buildSettingsOption(
              context,
              "Language",
              "Choose your preferred language.",
              FontAwesomeIcons.language,
                  () {},
            ),
            _buildSettingsOption(
              context,
              "Dark Mode",
              "Toggle between light and dark themes.",
              FontAwesomeIcons.moon,
                  () {},
            ),
            _buildSettingsOption(
              context,
              "App Permissions",
              "Manage camera, storage, and location access.",
              FontAwesomeIcons.lock,
                  () {},
            ),
            _buildSettingsOption(
              context,
              "Data & Privacy",
              "Manage data collection and privacy settings.",
              FontAwesomeIcons.shieldHalved,
                  () {},
            ),
            _buildSettingsOption(
              context,
              "Terms & Conditions",
              "Review our legal terms and agreements.",
              FontAwesomeIcons.fileContract,
                  () {},
            ),
            _buildSettingsOption(
              context,
              "Clear Cache",
              "Remove temporary files to free up space.",
              FontAwesomeIcons.trash,
                  () {},
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsHeader() {
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
          FaIcon(FontAwesomeIcons.cog, size: 24, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "Customize Your Settings",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
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
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: FaIcon(FontAwesomeIcons.angleRight, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
