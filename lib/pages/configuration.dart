import 'package:flutter/material.dart';

import '../features/calendar/models/calendar_model.dart';
import 'calendar_configuration.dart';

class Configuration extends StatefulWidget {
  const Configuration({Key? key}) : super(key: key);

  @override
  State<Configuration> createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
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
          'Configuration',
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
              _buildSettingItem(
                icon: Icons.calendar_month_outlined,
                title: 'Calendar Configuration',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarConfigurationScreen(
                        initialCalendarState: CalendarState(
                          selectedDate: DateTime.now(), // or any relevant date
                          currentView:
                              CalendarView.today, // or today, weekly, etc.
                          events:
                              [], // can be a list of CalendarEvent if you have any
                          isLoading: false,
                        ),
                        onConfigurationChanged: (CalendarState) {},
                      ),
                    ),
                  );
                },
              ),

              _buildSettingItem(
                icon: Icons.inbox,
                title: 'Unified Inbox Configuration',
                onTap: () {
                  // Add navigation logic here
                  print('Voice Preferences tapped');
                },
              ),

              _buildSettingItem(
                icon: Icons.lock_outline,
                title: 'Vault Configuration',
                onTap: () {
                  // Add navigation logic here
                  print('Privacy and Security tapped');
                },
              ),

              _buildSettingItem(
                icon: Icons.smart_toy,
                title: 'AI Assistant Configuration',
                onTap: () {
                  // Add navigation logic here
                  print('API Integration tapped');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.grey[700], size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
