import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../themes/light_app_theme.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Support", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSupportHeader(),
            SizedBox(height: 20),
            _buildFAQsSection(), // Added FAQs Section
            SizedBox(height: 20),
            _buildSupportOption(
              context,
              "Live Chat Support",
              "Chat with our support team in real-time.",
              FontAwesomeIcons.comments,
                  () {},
            ),
            _buildSupportOption(
              context,
              "Email Support",
              "Reach us via email for queries and support.",
              FontAwesomeIcons.envelope,
                  () {},
            ),
            _buildSupportOption(
              context,
              "Call Support",
              "Talk to our support team directly.",
              FontAwesomeIcons.phone,
                  () {},
            ),
            _buildSupportOption(
              context,
              "FAQs",
              "Find answers to commonly asked questions.",
              FontAwesomeIcons.questionCircle,
                  () {},
            ),
            SizedBox(height: 20),
            _buildHelpCenter(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportHeader() {
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
          FaIcon(FontAwesomeIcons.headset, size: 24, color: Colors.white),
          SizedBox(width: 10),
          Text(
            "How can we help you?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Frequently Asked Questions",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 10),
          _buildFAQTile("How to change profile name?", "Go to account settings and update your profile name."),
          _buildFAQTile("Will my investment amount go directly into my account?", "Yes, all transactions are processed securely."),
          _buildFAQTile("Can I add multiple accounts?", "Yes, you can link multiple accounts for better management."),
          _buildFAQTile("When does my portfolio update?", "Your portfolio updates in real-time during market hours."),
        ],
      ),
    );
  }

  Widget _buildFAQTile(String question, String answer) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ExpansionTile(
        title: Text(question, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14)),
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(answer, style: TextStyle(color: Colors.black54,fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportOption(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
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

  Widget _buildHelpCenter() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Need Further Assistance?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTheme.primaryColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Our support team is available 24/7 to assist you. Feel free to contact us anytime.",
            style: TextStyle(fontSize: 14, color: Colors.black54,),
          ),
        ],
      ),
    );
  }
}
