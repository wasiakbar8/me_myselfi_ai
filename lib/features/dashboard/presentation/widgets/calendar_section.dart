import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:me_myself_ai/features/calendar/views/calendar_newentry_screen.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../calendar/views/calendar_screen.dart';

class CalendarSection extends StatefulWidget {
  final VoidCallback? onAddEvent;

  const CalendarSection({
    super.key,
    this.onAddEvent,
  });

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime.now();
    _selectedDate = DateTime.now();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday;

    List<Widget> days = [];

    // Add empty spaces before first day
    for (int i = 0; i < (firstWeekday - 1) % 7; i++) {
      days.add(const SizedBox.shrink());
    }

    // Add actual days
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isSelected = date.day == _selectedDate.day &&
          date.month == _selectedDate.month &&
          date.year == _selectedDate.year;

      days.add(
        GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            margin: const EdgeInsets.all(4.0),
            decoration: isSelected
                ? BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            )
                : null,
            alignment: Alignment.center,
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? AppColors.darkGray : AppColors.primary,
              ),
            ),
          ),
        ),
      );
    }

    // Fill remaining cells in the last row
    while (days.length % 7 != 0) {
      days.add(const SizedBox.shrink());
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Add Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CalendarScreen()));
                },
                child: Text(
                  'Calendar',
                  style: AppTextStyles.sectionTitle,

                )

              ),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CalendarNewEntryScreen(selectedDate: _selectedDate)));
                },
                backgroundColor: AppColors.primary,
                child: const Icon(
                  Icons.add,
                  color: AppColors.darkGray,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8.0),

          // Month Title
          Center(
            child: Text(
              DateFormat.yMMMM().format(_currentMonth), // e.g., July 2025
              style: AppTextStyles.headerTitle,
            ),
          ),

          const SizedBox(height: 6.0),

          // Navigation and Weekday labels aligned in columns
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _nextMonth,
              ),
            ],
          ),

          // Weekday header aligned above calendar
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              Center(child: Text('S', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('M', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('T', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('W', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('T', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('F', style: TextStyle(fontWeight: FontWeight.bold))),
              Center(child: Text('S', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),

          const SizedBox(height: 2.0),

          // Calendar days
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: _buildCalendarDays(),
          ),

          const SizedBox(height: 10.0),

          const Text('Events', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6.0),

          const ListTile(
            leading: Icon(Icons.people, color: Colors.blue),
            title: Text('Team Meeting 10:00 AM',style: TextStyle(fontSize: 14 )),
          ),

          const ListTile(
            leading: Icon(Icons.phone, color: Colors.blue),
            title: Text('Client Call 2:30 PM', style: TextStyle(fontSize: 14 )),
          ),
        ],
      ),
    );
  }
}
