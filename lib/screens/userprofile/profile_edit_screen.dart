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

  void pickFile(int index) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        switch (index) {
          case 0:
            requiredDocument = File(result.files.single.path!);
            break;
          case 1:
            optionalDocument1 = File(result.files.single.path!);
            break;
          case 2:
            optionalDocument2 = File(result.files.single.path!);
            break;
          case 3:
            amcLogo = File(result.files.single.path!);
            break;
          case 4:
            managerImage = File(result.files.single.path!);
            break;
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
            SizedBox(height: 5),
            _buildUploadSection("Upload Required Document", requiredDocument, 0),
            SizedBox(height: 5),
            _buildUploadSection("Upload Optional Document 1", optionalDocument1, 1),
            SizedBox(height: 5),
            _buildUploadSection("Upload Optional Document 2", optionalDocument2, 2),
            SizedBox(height: 5),
            _buildUploadSection("Upload AMC Logo (Optional)", amcLogo, 3),
            SizedBox(height: 5),
            _buildUploadSection("Upload Manager Image (Optional)", managerImage, 4),
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

  Widget _buildUploadSection(String title, File? file, int index) {
    return GestureDetector(
      onTap: () => pickFile(index),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade100,
        ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      file != null ? file.path.split('/').last : "Tap to upload",
                      style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.upload_file, color: AppTheme.lightTheme.primaryColor, size: 24),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
