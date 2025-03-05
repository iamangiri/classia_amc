import 'package:classia_amc/screens/invester_screen.dart';
import 'package:classia_amc/screens/portfolio_screen.dart';
import 'package:classia_amc/screens/userprofile/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../themes/light_app_theme.dart';
import 'splash_screen.dart';
import 'userprofile/aboutus_screen.dart';
import 'userprofile/customer_support_screen.dart';
import 'userprofile/profile_edit_screen.dart';
import 'userprofile/setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: TextStyle(color: Colors.white)),
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
            // Profile Header
            _buildProfileHeader(context),

            SizedBox(height: 20),

          _buildOptionTile(context, "Edit Profile", FontAwesomeIcons.userEdit, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileScreen()));
          }),

            // Account Options
            _buildOptionTile(context, "My Portfolio", FontAwesomeIcons.chartLine, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PortfolioScreen()));
            }),
            _buildOptionTile(context, "Transaction History", FontAwesomeIcons.clockRotateLeft, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => InvestorScreen()));
            }),
            _buildOptionTile(context, "Security Settings", FontAwesomeIcons.shieldHalved, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
            }),
            _buildOptionTile(context, "Notifications", FontAwesomeIcons.bell, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationScreen()));
            }),
            _buildOptionTile(context, "Customer Support", FontAwesomeIcons.headset, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CustomerSupportScreen()));
            }),
            _buildOptionTile(context, "About Us", FontAwesomeIcons.infoCircle, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsScreen()));
            }),
            _buildOptionTile(context, "Logout", FontAwesomeIcons.signOutAlt, () {
              _showLogoutDialog(context);
            }),
          ],
        ),
      ),
    );
  }

// Profile Header with Edit Button
  Widget _buildProfileHeader(BuildContext context) {
    return Container(

      width: double.infinity, // Full-width
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40), // Rounded bottom-left
          bottomRight: Radius.circular(40), // Rounded bottom-right
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              // Profile Picture with Placeholder for Missing Image
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/profile_pic.png'), // Replace with user image
                child: Image.asset('assets/profile_pic.png', fit: BoxFit.cover) == null
                    ? Text(
                  "JD", // User initials as fallback
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.lightTheme.primaryColor),
                )
                    : null,
              ),

              // Modern Curved Edit Button
              Positioned(
                bottom: 4,
                right: 4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25), // Rounded Button
                  child: Material(
                    color: Colors.white, // Background color
                    elevation: 4, // Shadow effect
                    child: InkWell(
                      onTap: () {
                        // Navigate to Edit Profile Screen
                      },
                      borderRadius: BorderRadius.circular(25),
                      child: Padding(
                        padding: EdgeInsets.all(8), // Padding for better tap area
                        child: FaIcon(
                          FontAwesomeIcons.pen,
                          size: 14,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // User Name
          Text(
            "Aman Giri",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 4),

          // Email
          Text(
            "aman@classia.com",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }



  // ListTile Option
  Widget _buildOptionTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: FaIcon(icon, color: AppTheme.lightTheme.primaryColor),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing: FaIcon(FontAwesomeIcons.angleRight, size: 18, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Logout Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle Logout Logic
              Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
