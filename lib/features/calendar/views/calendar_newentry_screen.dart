// lib/features/calendar/views/calendar_newentry_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/calendar_model.dart';

class CalendarNewEntryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final CalendarEvent? eventToEdit;

  const CalendarNewEntryScreen({
    Key? key,
    required this.selectedDate,
    this.eventToEdit,
  }) : super(key: key);

  @override
  State<CalendarNewEntryScreen> createState() => _CalendarNewEntryScreenState();
}

class _CalendarNewEntryScreenState extends State<CalendarNewEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _attendeesController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  EventType _selectedEventType = EventType.meeting;
  EventPriority _selectedPriority = EventPriority.medium;
  Color _selectedColor = Colors.blue.shade200;
  bool _isAllDay = false;
  bool _hasReminder = true;
  int _reminderMinutes = 15;

  final List<Color> _eventColors = [
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.red.shade200,
    Colors.yellow.shade200,
    Colors.purple.shade200,
    Colors.orange.shade200,
    Colors.pink.shade200,
    Colors.teal.shade200,
  ];

  final List<int> _reminderOptions = [5, 10, 15, 30, 60, 120, 1440]; // minutes

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _startTime = TimeOfDay.now();
    _endTime = TimeOfDay(hour: TimeOfDay.now().hour + 1, minute: TimeOfDay.now().minute);

    if (widget.eventToEdit != null) {
      _loadEventData(widget.eventToEdit!);
    }
  }

  void _loadEventData(CalendarEvent event) {
    _titleController.text = event.title;
    _descriptionController.text = event.description;
    _locationController.text = event.location;
    _attendeesController.text = event.attendees.join(', ');
    _selectedDate = event.startTime;
    _startTime = TimeOfDay.fromDateTime(event.startTime);
    _endTime = TimeOfDay.fromDateTime(event.endTime);
    _selectedEventType = event.type;
    _selectedPriority = event.priority;
    _selectedColor = event.color;
    _isAllDay = event.isAllDay;
    _hasReminder = event.hasReminder;
    _reminderMinutes = event.reminderMinutes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _attendeesController.dispose();
    super.dispose();
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
        title: Text(
          widget.eventToEdit != null ? 'Edit Event' : 'New Event',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.yellow.shade700,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildEventTypeSelection(),
            const SizedBox(height: 16),
            _buildColorSelection(),
            const SizedBox(height: 16),
            _buildDateTimeSelection(),
            const SizedBox(height: 16),
            _buildAllDayToggle(),
            const SizedBox(height: 16),
            _buildLocationField(),
            const SizedBox(height: 16),
            _buildAttendeesField(),
            const SizedBox(height: 16),
            _buildPrioritySelection(),
            const SizedBox(height: 16),
            _buildReminderSettings(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return _buildFormSection(
      title: 'Event Title',
      child: TextFormField(
        controller: _titleController,
        decoration: InputDecoration(
          hintText: 'Enter event title',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter an event title';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    return _buildFormSection(
      title: 'Description',
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 3,
        decoration: InputDecoration(
          hintText: 'Add description (optional)',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildEventTypeSelection() {
    return _buildFormSection(
      title: 'Event Type',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: EventType.values.map((type) {
            return RadioListTile<EventType>(
              title: Text(_getEventTypeLabel(type)),
              value: type,
              groupValue: _selectedEventType,
              onChanged: (value) {
                setState(() {
                  _selectedEventType = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildColorSelection() {
    return _buildFormSection(
      title: 'Event Color',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _eventColors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? Border.all(color: Colors.black, width: 3)
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.black, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateTimeSelection() {
    return _buildFormSection(
      title: 'Date & Time',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // Date Selection
            ListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text('Date'),
              subtitle: Text(DateFormat('EEEE, MMMM dd, yyyy').format(_selectedDate)),
              trailing: const Icon(Icons.chevron_right),
              onTap: _selectDate,
              contentPadding: EdgeInsets.zero,
            ),
            if (!_isAllDay) ...[
              const Divider(),
              // Start Time
              ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text('Start Time'),
                subtitle: Text(_startTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectTime(true),
                contentPadding: EdgeInsets.zero,
              ),
              const Divider(),
              // End Time
              ListTile(
                leading: const Icon(Icons.access_time_filled),
                title: const Text('End Time'),
                subtitle: Text(_endTime.format(context)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _selectTime(false),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAllDayToggle() {
    return _buildFormSection(
      title: 'All Day Event',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SwitchListTile(
          title: const Text('All Day'),
          subtitle: const Text('Event lasts the entire day'),
          value: _isAllDay,
          onChanged: (value) {
            setState(() {
              _isAllDay = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return _buildFormSection(
      title: 'Location',
      child: TextFormField(
        controller: _locationController,
        decoration: InputDecoration(
          hintText: 'Add location (optional)',
          prefixIcon: const Icon(Icons.location_on_outlined),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildAttendeesField() {
    return _buildFormSection(
      title: 'Attendees',
      child: TextFormField(
        controller: _attendeesController,
        decoration: InputDecoration(
          hintText: 'Add attendees (comma-separated)',
          prefixIcon: const Icon(Icons.people_outline),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildPrioritySelection() {
    return _buildFormSection(
      title: 'Priority',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: EventPriority.values.map((priority) {
            return RadioListTile<EventPriority>(
              title: Text(_getPriorityLabel(priority)),
              value: priority,
              groupValue: _selectedPriority,
              onChanged: (value) {
                setState(() {
                  _selectedPriority = value!;
                });
              },
              contentPadding: EdgeInsets.zero,
              dense: true,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildReminderSettings() {
    return _buildFormSection(
      title: 'Reminder',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Set Reminder'),
              subtitle: const Text('Get notified before the event'),
              value: _hasReminder,
              onChanged: (value) {
                setState(() {
                  _hasReminder = value;
                });
              },
              contentPadding: EdgeInsets.zero,
            ),
            if (_hasReminder) ...[
              const Divider(),
              ListTile(
                title: const Text('Remind me'),
                subtitle: Text(_getReminderLabel(_reminderMinutes)),
                trailing: const Icon(Icons.chevron_right),
                onTap: _selectReminderTime,
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.yellow.shade600,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.yellow.shade600,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
          // Auto-adjust end time if it's before start time
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
            _endTime = TimeOfDay(
              hour: (_startTime.hour + 1) % 24,
              minute: _startTime.minute,
            );
          }
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectReminderTime() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reminder Time'),
          content: SizedBox(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _reminderOptions.length,
              itemBuilder: (context, index) {
                final minutes = _reminderOptions[index];
                return RadioListTile<int>(
                  title: Text(_getReminderLabel(minutes)),
                  value: minutes,
                  groupValue: _reminderMinutes,
                  onChanged: (value) {
                    setState(() {
                      _reminderMinutes = value!;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final startDateTime = _isAllDay
        ? DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day)
        : DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = _isAllDay
        ? DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59)
        : DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime.hour,
      _endTime.minute,
    );

    final event = CalendarEvent(
      id: widget.eventToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      color: _selectedColor,
      type: _selectedEventType,
      priority: _selectedPriority,
      location: _locationController.text.trim(),
      attendees: _attendeesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      isAllDay: _isAllDay,
      hasReminder: _hasReminder,
      reminderMinutes: _reminderMinutes,
    );

    Navigator.pop(context, event);
  }
}