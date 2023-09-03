import 'package:flutter/material.dart';

class EditSettingsPage extends StatefulWidget {
  const EditSettingsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _EditSettingsPageState createState() => _EditSettingsPageState();
}

class _EditSettingsPageState extends State<EditSettingsPage> {
  String _language = "English";
  final TextEditingController _languageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _languageController.text = _language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar( title: const Text("edit settings")),
            body: ListView(
        padding:const  EdgeInsets.all(16.0),
        children: [
           const SizedBox(height: 10,),
                   ListTile(
            leading:const  Icon(Icons.language),
            title: TextField(
              controller: _languageController,
              decoration:const  InputDecoration(
                hintText: 'Language',
              ),
              onChanged: (value) {
                _language = value;
              },
            ),
          ),

          // FAQ
          ListTile(
            leading:const  Icon(Icons.question_answer),
            title:const  Text('FAQ'),
            onTap: () {
              // Add functionality to navigate to the FAQ section
            },
          ),

          // Help
          ListTile(
            leading:const  Icon(Icons.help),
            title:const  Text('Help'),
            onTap: () {
              // Add functionality to navigate to the Help section
            },
          ),

          // Save button

        ],
      ),
    );
  }
}
