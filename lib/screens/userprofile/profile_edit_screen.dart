import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';

import '../../themes/light_app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? requiredDocument;
  File? optionalDocument1;
  File? optionalDocument2;
  File? amcLogo;
  File? managerImage;

  void pickFile(bool isRequired, int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        if (isRequired) {
          requiredDocument = File(result.files.single.path!);
        } else if (index == 1) {
          optionalDocument1 = File(result.files.single.path!);
        } else if (index == 2) {
          optionalDocument2 = File(result.files.single.path!);
        } else if (index == 3) {
          amcLogo = File(result.files.single.path!);
        } else {
          managerImage = File(result.files.single.path!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.lightTheme.primaryColor,
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 20),
            _buildDisabledTextField("AMC Name", "AMC Asset Management"),
            _buildTextField("Account Manager", "Enter manager name"),
            _buildTextField("Email", "Enter email"),
            _buildTextField("Phone Number", "Enter phone number"),
            _buildTextField("Manager Experience (Years)", "Enter years of experience"),
            _buildTextField("About Manager", "Enter manager's details"),
            SizedBox(height: 20),
            _buildUploadSection("Upload Required Document", requiredDocument, true, 0),
            _buildUploadSection("Upload Optional Document 1", optionalDocument1, false, 1),
            _buildUploadSection("Upload Optional Document 2", optionalDocument2, false, 2),
            _buildUploadSection("Upload AMC Logo (Optional)", amcLogo, false, 3),
            _buildUploadSection("Upload Manager Image (Optional)", managerImage, false, 4),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text("Save Changes", style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildDisabledTextField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        controller: TextEditingController(text: value),
        enabled: false,
      ),
    );
  }

  Widget _buildUploadSection(String title, File? file, bool isRequired, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(file != null ? file.path.split('/').last : "No file selected", style: TextStyle(fontSize: 14)),
                ),
                IconButton(
                  icon: Icon(Icons.upload_file, color: AppTheme.lightTheme.primaryColor),
                  onPressed: () => pickFile(isRequired, index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}