// lib/features/calendar/models/calendar_model.dart

import 'package:flutter/material.dart';

enum EventPriority { low, medium, high, urgent }

enum EventType { meeting, review, call, session, birthday, other }

class CalendarEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;
  final EventType type;
  final EventPriority priority;
  final String location;
  final List<String> attendees;
  final bool isAllDay;
  final bool hasReminder;
  final int reminderMinutes;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startTime,
    required this.endTime,
    required this.color,
    this.type = EventType.other,
    this.priority = EventPriority.medium,
    this.location = '',
    this.attendees = const [],
    this.isAllDay = false,
    this.hasReminder = false,
    this.reminderMinutes = 15,
  });

  CalendarEvent copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Color? color,
    EventType? type,
    EventPriority? priority,
    String? location,
    List<String>? attendees,
    bool? isAllDay,
    bool? hasReminder,
    int? reminderMinutes,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      color: color ?? this.color,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      location: location ?? this.location,
      attendees: attendees ?? this.attendees,
      isAllDay: isAllDay ?? this.isAllDay,
      hasReminder: hasReminder ?? this.hasReminder,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'color': color.value,
      'type': type.toString(),
      'priority': priority.toString(),
      'location': location,
      'attendees': attendees,
      'isAllDay': isAllDay,
      'hasReminder': hasReminder,
      'reminderMinutes': reminderMinutes,
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      color: Color(json['color']),
      type: EventType.values.firstWhere(
            (e) => e.toString() == json['type'],
        orElse: () => EventType.other,
      ),
      priority: EventPriority.values.firstWhere(
            (e) => e.toString() == json['priority'],
        orElse: () => EventPriority.medium,
      ),
      location: json['location'] ?? '',
      attendees: List<String>.from(json['attendees'] ?? []),
      isAllDay: json['isAllDay'] ?? false,
      hasReminder: json['hasReminder'] ?? false,
      reminderMinutes: json['reminderMinutes'] ?? 15,
    );
  }
}

enum CalendarView { today, weekly, monthly, yearly }

class CalendarState {
  final DateTime selectedDate;
  final CalendarView currentView;
  final List<CalendarEvent> events;
  final bool isLoading;

  CalendarState({
    required this.selectedDate,
    this.currentView = CalendarView.monthly,
    this.events = const [],
    this.isLoading = false,
  });

  CalendarState copyWith({
    DateTime? selectedDate,
    CalendarView? currentView,
    List<CalendarEvent>? events,
    bool? isLoading,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      currentView: currentView ?? this.currentView,
      events: events ?? this.events,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return events.where((event) {
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return eventDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  List<CalendarEvent> getEventsForMonth(int year, int month) {
    return events.where((event) {
      return event.startTime.year == year && event.startTime.month == month;
    }).toList();
  }

  List<CalendarEvent> getEventsForWeek(DateTime weekStart) {
    final weekEnd = weekStart.add(const Duration(days: 6));
    return events.where((event) {
      final eventDate = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      return eventDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          eventDate.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();
  }
}