import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/light_app_theme.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 20),
              _buildMissionSection(),
              SizedBox(height: 20),
              _buildFeaturesSection(),
              SizedBox(height: 20),
              _buildAMCDivision(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to Classia J T",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "We are redefining trading with a simple, fun, and gamified experience. Our goal is to make investing effortless, so you only need to watch the horses run and invest accordingly!",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Our Mission",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Jockey Trading simplifies investing by offering a race-track-style visualization where users can invest in stocks as easily as watching horses run! Withdrawals and deposits are seamless, ensuring a stress-free trading experience.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "User App Features",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 10),
        _buildFeatureTile("📈 Real-time Market Data", "Track your investments live with jockey-style visualization."),
        _buildFeatureTile("💰 Easy Investing & Withdrawing", "Invest in top-performing assets and withdraw funds seamlessly."),
        _buildFeatureTile("🏇 Gamified Experience", "Trading has never been this fun! Watch horses run and invest smartly."),
      ],
    );
  }

  Widget _buildFeatureTile(String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildAMCDivision() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "AMC Platform",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        SizedBox(height: 10),
        Text(
          "Classia J T isn't just for users—it also empowers Asset Management Companies (AMC) to manage investments and generate profits for users. The AMC platform allows companies to oversee investments, optimize returns, and provide users with the best investment strategies.",
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}