import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/calendar_model.dart';

class CalendarEntryViewScreen extends StatelessWidget {
  final CalendarEvent event;

  const CalendarEntryViewScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(event.title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 40,
                  color: event.color,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Type: ${_getEventTypeLabel(event.type)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      if (event.description.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Description: ${event.description}',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Time: ${event.isAllDay ? 'All day' : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}'}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      if (event.location.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Location: ${event.location}',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                      if (event.attendees.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Attendees: ${event.attendees.join(', ')}',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        'Priority: ${_getPriorityLabel(event.priority)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                      if (event.hasReminder) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Reminder: ${_getReminderLabel(event.reminderMinutes)}',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }

  String _getEventTypeLabel(EventType type) {
    switch (type) {
      case EventType.meeting:
        return 'Meeting';
      case EventType.review:
        return 'Review';
      case EventType.call:
        return 'Call';
      case EventType.session:
        return 'Session';
      case EventType.birthday:
        return 'Birthday';
      case EventType.other:
        return 'Other';
    }
  }

  String _getPriorityLabel(EventPriority priority) {
    switch (priority) {
      case EventPriority.low:
        return 'Low Priority';
      case EventPriority.medium:
        return 'Medium Priority';
      case EventPriority.high:
        return 'High Priority';
      case EventPriority.urgent:
        return 'Urgent';
    }
  }

  String _getReminderLabel(int minutes) {
    if (minutes < 60) {
      return '$minutes minutes before';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} before';
    } else {
      final days = minutes ~/ 1440;
      return '$days ${days == 1 ? 'day' : 'days'} before';
    }
  }
}