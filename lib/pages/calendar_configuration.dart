import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../features/calendar/models/calendar_model.dart';

enum ColorTheme { systemDefault, light, dark }
enum TimeFormat { twelveHour, twentyFourHour }
enum StartOfWeek { sunday, monday, tuesday, wednesday, thursday, friday, saturday }
enum NotificationType { alerts, banners, none }
enum DoNotDisturbHours { none, sleepHours, workHours, custom }
enum SyncFrequency { every5Minutes, every15Minutes, every30Minutes, hourly, manual }

class CalendarConfigurationScreen extends StatefulWidget {
  final CalendarState initialCalendarState;
  final Function(CalendarState) onConfigurationChanged;

  const CalendarConfigurationScreen({
    Key? key,
    required this.initialCalendarState,
    required this.onConfigurationChanged,
  }) : super(key: key);

  @override
  State<CalendarConfigurationScreen> createState() => _CalendarConfigurationScreenState();
}

class _CalendarConfigurationScreenState extends State<CalendarConfigurationScreen> {
  // Sync Options
  bool _googleCalendarSync = false;
  bool _appleCalendarSync = false;

  // Display Preferences
  ColorTheme _colorTheme = ColorTheme.systemDefault;
  CalendarView _defaultView = CalendarView.monthly;
  TimeFormat _timeFormat = TimeFormat.twentyFourHour;
  StartOfWeek _startOfWeek = StartOfWeek.monday;
  int _defaultEventDuration = 30; // in minutes

  // Notification Settings
  bool _eventReminders = false;
  NotificationType _notificationType = NotificationType.alerts;
  DoNotDisturbHours _doNotDisturbHours = DoNotDisturbHours.none;

  // Advanced Settings
  SyncFrequency _syncFrequency = SyncFrequency.every15Minutes;

  @override
  void initState() {
    super.initState();
    _loadInitialSettings();
  }

  void _loadInitialSettings() {
    // Load from initial calendar state or shared preferences
    _defaultView = widget.initialCalendarState.currentView;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Calendar Configuration',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSyncOptionsSection(),
            _buildDisplayPreferencesSection(),
            _buildNotificationSettingsSection(),
            _buildPrivacyPermissionsSection(),
            _buildAdvancedSection(),
            const SizedBox(height: 20),
            _buildDoneButton(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncOptionsSection() {
    return _buildSection(
      title: 'Calendar Sync Options',
      children: [
        _buildSyncOption(
          icon: FontAwesomeIcons.google,
          title: 'Google Calendar',
          subtitle: 'Sync your events from Google Calendar',
          value: _googleCalendarSync,
          onChanged: (value) {
            setState(() {
              _googleCalendarSync = value;
            });
          },
        ),
        _buildSyncOption(
          icon: Icons.apple,
          title: 'Apple Calendar',
          subtitle: 'Sync your events from Apple Calendar',
          value: _appleCalendarSync,
          onChanged: (value) {
            setState(() {
              _appleCalendarSync = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildDisplayPreferencesSection() {
    return _buildSection(
      title: 'Display Preferences',
      children: [
        _buildPreferenceRow(
          title: 'Color Theme',
          value: _getColorThemeText(_colorTheme),
          onTap: () => _showColorThemeDialog(),
        ),
        _buildPreferenceRow(
          title: 'Default View',
          value: _getDefaultViewText(_defaultView),
          onTap: () => _showDefaultViewDialog(),
        ),
        _buildPreferenceRow(
          title: 'Time Format',
          value: _getTimeFormatText(_timeFormat),
          onTap: () => _showTimeFormatDialog(),
        ),
        _buildPreferenceRow(
          title: 'Start of the Week',
          value: _getStartOfWeekText(_startOfWeek),
          onTap: () => _showStartOfWeekDialog(),
        ),
        _buildPreferenceRow(
          title: 'Default Event Duration',
          value: '$_defaultEventDuration minutes',
          onTap: () => _showEventDurationDialog(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettingsSection() {
    return _buildSection(
      title: 'Notification Settings',
      children: [
        _buildToggleRow(
          title: 'Event Reminders',
          value: _eventReminders,
          onChanged: (value) {
            setState(() {
              _eventReminders = value;
            });
          },
        ),
        _buildPreferenceRow(
          title: 'Notification Type',
          value: _getNotificationTypeText(_notificationType),
          onTap: () => _showNotificationTypeDialog(),
        ),
        _buildPreferenceRow(
          title: 'Do Not Disturb Hours',
          value: _getDoNotDisturbText(_doNotDisturbHours),
          onTap: () => _showDoNotDisturbDialog(),
        ),
      ],
    );
  }

  Widget _buildPrivacyPermissionsSection() {
    return _buildSection(
      title: 'Privacy & Permissions',
      children: [
        _buildArrowRow(
          title: 'View Granted Permissions',
          onTap: () => _showPermissionsDialog(),
        ),
        _buildArrowRow(
          title: 'Revoke Access',
          onTap: () => _showRevokeAccessDialog(),
        ),
        _buildArrowRow(
          title: 'Data Synced',
          onTap: () => _showDataSyncedDialog(),
        ),
      ],
    );
  }

  Widget _buildAdvancedSection() {
    return _buildSection(
      title: 'Advanced',
      children: [
        _buildPreferenceRow(
          title: 'Sync Frequency',
          value: _getSyncFrequencyText(_syncFrequency),
          onTap: () => _showSyncFrequencyDialog(),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildSyncOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: Colors.grey.shade600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD60A),
            activeTrackColor: const Color(0xFFFFD60A).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceRow({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFD60A),
            activeTrackColor: const Color(0xFFFFD60A).withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildArrowRow({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoneButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveConfiguration,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFFD60A),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Done',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Dialog methods
  void _showColorThemeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Color Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ColorTheme.values.map((theme) {
            return RadioListTile<ColorTheme>(
              title: Text(_getColorThemeText(theme)),
              value: theme,
              groupValue: _colorTheme,
              onChanged: (value) {
                setState(() {
                  _colorTheme = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDefaultViewDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default View'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: CalendarView.values.map((view) {
            return RadioListTile<CalendarView>(
              title: Text(_getDefaultViewText(view)),
              value: view,
              groupValue: _defaultView,
              onChanged: (value) {
                setState(() {
                  _defaultView = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showTimeFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Time Format'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TimeFormat.values.map((format) {
            return RadioListTile<TimeFormat>(
              title: Text(_getTimeFormatText(format)),
              value: format,
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() {
                  _timeFormat = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showStartOfWeekDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start of the Week'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: StartOfWeek.values.map((day) {
            return RadioListTile<StartOfWeek>(
              title: Text(_getStartOfWeekText(day)),
              value: day,
              groupValue: _startOfWeek,
              onChanged: (value) {
                setState(() {
                  _startOfWeek = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showEventDurationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Event Duration'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [15, 30, 45, 60, 90, 120].map((duration) {
            return RadioListTile<int>(
              title: Text('$duration minutes'),
              value: duration,
              groupValue: _defaultEventDuration,
              onChanged: (value) {
                setState(() {
                  _defaultEventDuration = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showNotificationTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notification Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: NotificationType.values.map((type) {
            return RadioListTile<NotificationType>(
              title: Text(_getNotificationTypeText(type)),
              value: type,
              groupValue: _notificationType,
              onChanged: (value) {
                setState(() {
                  _notificationType = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDoNotDisturbDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do Not Disturb Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: DoNotDisturbHours.values.map((hours) {
            return RadioListTile<DoNotDisturbHours>(
              title: Text(_getDoNotDisturbText(hours)),
              value: hours,
              groupValue: _doNotDisturbHours,
              onChanged: (value) {
                setState(() {
                  _doNotDisturbHours = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSyncFrequencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Frequency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SyncFrequency.values.map((frequency) {
            return RadioListTile<SyncFrequency>(
              title: Text(_getSyncFrequencyText(frequency)),
              value: frequency,
              groupValue: _syncFrequency,
              onChanged: (value) {
                setState(() {
                  _syncFrequency = value!;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPermissionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Granted Permissions'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Calendar Access'),
            Text('• Notification Access'),
            Text('• Storage Access'),
            Text('• Network Access'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showRevokeAccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Revoke Access'),
        content: const Text('Are you sure you want to revoke all permissions? This will disable calendar synchronization.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _googleCalendarSync = false;
                _appleCalendarSync = false;
              });
              Navigator.pop(context);
            },
            child: const Text('Revoke', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDataSyncedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Synced'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last sync: 2 minutes ago'),
            SizedBox(height: 8),
            Text('• Events: 127'),
            Text('• Calendars: 3'),
            Text('• Reminders: 45'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper methods for text conversion
  String _getColorThemeText(ColorTheme theme) {
    switch (theme) {
      case ColorTheme.systemDefault:
        return 'System Default';
      case ColorTheme.light:
        return 'Light';
      case ColorTheme.dark:
        return 'Dark';
    }
  }

  String _getDefaultViewText(CalendarView view) {
    switch (view) {
      case CalendarView.today:
        return 'Today';
      case CalendarView.weekly:
        return 'Week';
      case CalendarView.monthly:
        return 'Month';
      case CalendarView.yearly:
        return 'Year';
    }
  }

  String _getTimeFormatText(TimeFormat format) {
    switch (format) {
      case TimeFormat.twelveHour:
        return '12-hour';
      case TimeFormat.twentyFourHour:
        return '24-hour';
    }
  }

  String _getStartOfWeekText(StartOfWeek day) {
    switch (day) {
      case StartOfWeek.sunday:
        return 'Sunday';
      case StartOfWeek.monday:
        return 'Monday';
      case StartOfWeek.tuesday:
        return 'Tuesday';
      case StartOfWeek.wednesday:
        return 'Wednesday';
      case StartOfWeek.thursday:
        return 'Thursday';
      case StartOfWeek.friday:
        return 'Friday';
      case StartOfWeek.saturday:
        return 'Saturday';
    }
  }

  String _getNotificationTypeText(NotificationType type) {
    switch (type) {
      case NotificationType.alerts:
        return 'Alerts';
      case NotificationType.banners:
        return 'Banners';
      case NotificationType.none:
        return 'None';
    }
  }

  String _getDoNotDisturbText(DoNotDisturbHours hours) {
    switch (hours) {
      case DoNotDisturbHours.none:
        return 'None';
      case DoNotDisturbHours.sleepHours:
        return 'Sleep Hours (10 PM - 7 AM)';
      case DoNotDisturbHours.workHours:
        return 'Work Hours (9 AM - 6 PM)';
      case DoNotDisturbHours.custom:
        return 'Custom';
    }
  }

  String _getSyncFrequencyText(SyncFrequency frequency) {
    switch (frequency) {
      case SyncFrequency.every5Minutes:
        return 'Every 5 minutes';
      case SyncFrequency.every15Minutes:
        return 'Every 15 minutes';
      case SyncFrequency.every30Minutes:
        return 'Every 30 minutes';
      case SyncFrequency.hourly:
        return 'Hourly';
      case SyncFrequency.manual:
        return 'Manual';
    }
  }

  void _saveConfiguration() {
    // Create updated calendar state with new configuration
    final updatedCalendarState = widget.initialCalendarState.copyWith(
      currentView: _defaultView,
    );

    // Call callback with updated state
    widget.onConfigurationChanged(updatedCalendarState);

    // You can also save to SharedPreferences here
    _saveToPreferences();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Configuration saved successfully!'),
        backgroundColor: Color(0xFFFFD60A),
      ),
    );

    // Pop the screen
    Navigator.pop(context);
  }

  void _saveToPreferences() {
    // Implement SharedPreferences saving here
    // This would typically save all the configuration options
    // for persistent storage across app sessions
  }
}