import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ApiIntegrationsPage extends StatefulWidget {
  const ApiIntegrationsPage({Key? key}) : super(key: key);

  @override
  State<ApiIntegrationsPage> createState() => _ApiIntegrationsPageState();
}

class _ApiIntegrationsPageState extends State<ApiIntegrationsPage> {
  // Platform Settings toggles
  bool autoReply = false;
  bool readReceipts = false;
  bool crossPlatformSync = false;

  // API Permissions checkboxes
  bool readMessages = false;
  bool sendMessages = false;
  bool accessProfileInfo = false;
  bool uploadMedia = false;
  bool accessContacts = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'API Integrations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connected Platforms Section
              const Text(
                'Connected Platforms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Platform Items
              _buildPlatformItem(
                icon: FontAwesomeIcons.whatsapp,
                iconColor: Colors.green,
                iconBgColor: Colors.green[100]!,
                title: 'WhatsApp',
                status: 'Connected',
                onTap: () {
                  print('WhatsApp tapped');
                },
              ),

              _buildPlatformItem(
                icon: Icons.sms,
                iconColor: Colors.blue,
                iconBgColor: Colors.blue[100]!,
                title: 'SMS',
                status: 'Connected',
                onTap: () {
                  print('SMS tapped');
                },
              ),

              _buildPlatformItem(
                icon: Icons.email,
                iconColor: Colors.red,
                iconBgColor: Colors.red[100]!,
                title: 'Email',
                status: 'Connected',
                onTap: () {
                  print('Gmail tapped');
                },
              ),

              _buildPlatformItem(
                icon: Icons.chat_bubble,
                iconColor: Colors.pink,
                iconBgColor: Colors.amberAccent,
                title: 'Slack',
                status: 'Connected',
                onTap: () {
                  print('Instagram tapped');
                },
              ),



              _buildPlatformItem(
                icon: FontAwesomeIcons.yahoo,
                iconColor: Colors.purple,
                iconBgColor: Colors.purple[100]!,
                title: 'Yahoo',
                status: 'Connected',
                onTap: () {
                  print('Yahoo tapped');
                },
              ),

              const SizedBox(height: 20),

              // Platform Settings Section
              const Text(
                'Platform Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              _buildToggleItem(
                title: 'Auto-Reply',
                value: autoReply,
                onChanged: (value) {
                  setState(() {
                    autoReply = value;
                  });
                  print('Auto-Reply: $value');
                },
              ),

              _buildToggleItem(
                title: 'Read Receipts',
                value: readReceipts,
                onChanged: (value) {
                  setState(() {
                    readReceipts = value;
                  });
                  print('Read Receipts: $value');
                },
              ),

              _buildToggleItem(
                title: 'Cross-Platform Sync',
                value: crossPlatformSync,
                onChanged: (value) {
                  setState(() {
                    crossPlatformSync = value;
                  });
                  print('Cross-Platform Sync: $value');
                },
              ),

              const SizedBox(height: 20),

              // API Permissions Section
              const Text(
                'API Permissions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                'Control what connected platforms can access...',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),

              const SizedBox(height: 10),

              _buildCheckboxItem(
                title: 'Read Messages',
                value: readMessages,
                onChanged: (value) {
                  setState(() {
                    readMessages = value ?? false;
                  });
                  print('Read Messages: $value');
                },
              ),

              _buildCheckboxItem(
                title: 'Send Messages',
                value: sendMessages,
                onChanged: (value) {
                  setState(() {
                    sendMessages = value ?? false;
                  });
                  print('Send Messages: $value');
                },
              ),

              _buildCheckboxItem(
                title: 'Access Profile Info',
                value: accessProfileInfo,
                onChanged: (value) {
                  setState(() {
                    accessProfileInfo = value ?? false;
                  });
                  print('Access Profile Info: $value');
                },
              ),

              _buildCheckboxItem(
                title: 'Upload Media',
                value: uploadMedia,
                onChanged: (value) {
                  setState(() {
                    uploadMedia = value ?? false;
                  });
                  print('Upload Media: $value');
                },
              ),

              _buildCheckboxItem(
                title: 'Access Contacts',
                value: accessContacts,
                onChanged: (value) {
                  setState(() {
                    accessContacts = value ?? false;
                  });
                  print('Access Contacts: $value');
                },
              ),

              const SizedBox(height: 35),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _saveIntegrationSettings();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD60A),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Integration Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlatformItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String status,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          fontSize: 11,
          color: Colors.blue[600],
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.yellow[400],
        inactiveThumbColor: Colors.grey[400],
        inactiveTrackColor: Colors.grey[300],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String title,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.yellow[400],
          checkColor: Colors.white,
        ),
      );

  }

  void _saveIntegrationSettings() {
    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings Saved'),
          content: const Text('Your integration settings have been saved successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );

    // Print current settings for debugging
    print('=== Integration Settings ===');
    print('Platform Settings:');
    print('Auto-Reply: $autoReply');
    print('Read Receipts: $readReceipts');
    print('Cross-Platform Sync: $crossPlatformSync');
    print('API Permissions:');
    print('Read Messages: $readMessages');
    print('Send Messages: $sendMessages');
    print('Access Profile Info: $accessProfileInfo');
    print('Upload Media: $uploadMedia');
    print('Access Contacts: $accessContacts');
  }
}