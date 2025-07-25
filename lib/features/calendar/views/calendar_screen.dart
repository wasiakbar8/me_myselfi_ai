import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';
import '../models/calendar_model.dart';
import 'calendar_newentry_screen.dart';
import 'calendar_entry_view_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarState _calendarState = CalendarState(
    selectedDate: DateTime.now(),
    currentView: CalendarView.today,
    events: _getSampleEvents(),
  );

  PageController _pageController = PageController(initialPage: 1200);
  int _currentPageIndex = 1200;
  CalendarEvent? _tappedEvent;

  static List<CalendarEvent> _getSampleEvents() {
    final now = DateTime.now();
    return [
      CalendarEvent(
        id: '1',
        title: 'Design Team Weekly',
        startTime: DateTime(now.year, now.month, now.day, 10, 0),
        endTime: DateTime(now.year, now.month, now.day, 11, 0),
        color: Colors.green.shade200,
        type: EventType.meeting,
        attendees: ['John', 'Sarah', 'Mike'],
        location: 'Zoom',
      ),
      CalendarEvent(
        id: '2',
        title: 'Project Review',
        startTime: DateTime(now.year, now.month, now.day, 15, 0),
        endTime: DateTime(now.year, now.month, now.day, 16, 30),
        color: Colors.red.shade200,
        type: EventType.review,
        attendees: ['Team Lead', 'PM', 'Dev'],
        location: 'Conference Room B',
      ),
      CalendarEvent(
        id: '3',
        title: 'Client Call: Acme Corp',
        startTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 15, 0),
        color: Colors.yellow.shade200,
        type: EventType.call,
        attendees: ['Client'],
        location: 'Phone',
      ),
      CalendarEvent(
        id: '4',
        title: 'Team Standup Meeting',
        startTime: DateTime(now.year, now.month, now.day + 2, 11, 0),
        endTime: DateTime(now.year, now.month, now.day + 2, 11, 30),
        color: Colors.blue.shade200,
        type: EventType.meeting,
      ),
      CalendarEvent(
        id: '5',
        title: 'Design Review with Sarah',
        startTime: DateTime(now.year, now.month, now.day + 3, 14, 0),
        endTime: DateTime(now.year, now.month, now.day + 3, 15, 0),
        color: Colors.green.shade200,
        type: EventType.review,
      ),
      CalendarEvent(
        id: '6',
        title: 'Gym Session',
        startTime: DateTime(now.year, now.month, now.day + 4, 18, 30),
        endTime: DateTime(now.year, now.month, now.day + 4, 20, 0),
        color: Colors.orange.shade200,
        type: EventType.session,
      ),
      CalendarEvent(
        id: '7',
        title: 'Car Wash (Birthday)',
        startTime: DateTime(now.year, now.month, now.day + 5),
        endTime: DateTime(now.year, now.month, now.day + 5),
        color: Colors.red.shade200,
        type: EventType.birthday,
        isAllDay: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      drawer: HamburgerDrawer(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(

            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            floating: true,
            snap: true,
            expandedHeight: 0,

            title: const Text(
              'Calendar',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [_buildViewSelector(), _buildCalendarHeader()],
            ),
          ),
          SliverFillRemaining(child: _buildCalendarContent()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewEntry,
        backgroundColor: Color(0xFFFFD60A),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildViewTab('Today', CalendarView.today),
          _buildViewTab('Weekly', CalendarView.weekly),
          _buildViewTab('Monthly', CalendarView.monthly),
          _buildViewTab('Yearly', CalendarView.yearly),
        ],
      ),
    );
  }

  Widget _buildViewTab(String title, CalendarView view) {
    final isSelected = _calendarState.currentView == view;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _calendarState = _calendarState.copyWith(currentView: view);
          });
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.yellow.shade400 : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarHeader() {
    if (_calendarState.currentView == CalendarView.yearly) {
      return const SizedBox.shrink();
    }

    String headerText;
    switch (_calendarState.currentView) {
      case CalendarView.today:
        headerText = DateFormat(
          'EEEE, MMMM dd, yyyy',
        ).format(_calendarState.selectedDate);
        break;
      case CalendarView.weekly:
        headerText = 'Weekly Calendar';
        break;
      case CalendarView.monthly:
        headerText = DateFormat(
          'MMMM yyyy',
        ).format(_calendarState.selectedDate);
        break;
      case CalendarView.yearly:
        headerText = DateFormat('yyyy').format(_calendarState.selectedDate);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousPeriod,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            headerText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          IconButton(
            onPressed: _nextPeriod,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarContent() {
    switch (_calendarState.currentView) {
      case CalendarView.today:
        return _buildTodayView();
      case CalendarView.weekly:
        return _buildWeeklyView();
      case CalendarView.monthly:
        return _buildMonthlyView();
      case CalendarView.yearly:
        return _buildYearlyView();
    }
  }

  Widget _buildTodayView() {
    final todayEvents = _calendarState.getEventsForDate(
      _calendarState.selectedDate,
    );
    final firstDayOfMonth = DateTime(
      _calendarState.selectedDate.year,
      _calendarState.selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _calendarState.selectedDate.year,
      _calendarState.selectedDate.month + 1,
      0,
    );
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
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
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade400,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('MMM').format(_calendarState.selectedDate),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('dd').format(_calendarState.selectedDate),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(_calendarState.selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '${todayEvents.length} events',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 280,
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
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42,
              itemBuilder: (context, index) {
                final date = startDate.add(Duration(days: index));
                final isCurrentMonth =
                    date.month == _calendarState.selectedDate.month;
                final isToday = _isToday(date);
                final isSelected = _isSameDay(
                  date,
                  _calendarState.selectedDate,
                );
                final dayEvents = _calendarState.getEventsForDate(date);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _calendarState = _calendarState.copyWith(
                        selectedDate: date,
                      );
                      _tappedEvent = dayEvents.isNotEmpty ? dayEvents[0] : null;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.yellow.shade400
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isToday ? Colors.red : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: !isCurrentMonth
                                    ? Colors.grey.shade400
                                    : isToday
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        if (dayEvents.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: dayEvents.take(3).map((event) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: event.color,
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildEventsList(todayEvents, "Today's Events"),
          const SizedBox(height: 100), // Extra space for floating action button
        ],
      ),
    );
  }

  Widget _buildWeeklyView() {
    final weekStart = _getWeekStart(_calendarState.selectedDate);
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekEvents = _calendarState.getEventsForWeek(weekStart);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Week of ${DateFormat('MMM dd').format(weekStart)} – ${DateFormat('MMM dd, yyyy').format(weekEnd)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          _buildWeekHeader(),
          Container(
            height: 300,
            margin: const EdgeInsets.all(16),
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
            child: _buildWeeklyTimeGrid(),
          ),
          _buildEventsList(weekEvents, "Weekly Events"),
          const SizedBox(height: 100), // Extra space for floating action button
        ],
      ),
    );
  }

  Widget _buildWeekHeader() {
    final weekStart = _getWeekStart(_calendarState.selectedDate);
    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(7, (index) {
          final date = weekStart.add(Duration(days: index));
          final isToday = _isToday(date);

          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(
                    weekDays[index],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isToday
                          ? Colors.yellow.shade400
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isToday ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildWeeklyTimeGrid() {
    final weekStart = _getWeekStart(_calendarState.selectedDate);
    final hours = List.generate(24, (index) => index);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            height: 40,
            child: Row(
              children: [
                SizedBox(width: 60),
                ...List.generate(7, (dayIndex) {
                  final date = weekStart.add(Duration(days: dayIndex));
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        DateFormat('dd').format(date),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
          ...hours.map((hour) {
            return Container(
              height: 50,
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ...List.generate(7, (dayIndex) {
                    final date = weekStart.add(Duration(days: dayIndex));
                    final dayEvents = _calendarState
                        .getEventsForDate(date)
                        .where((event) => event.startTime.hour == hour)
                        .toList();

                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                            bottom: BorderSide(
                              color: Colors.grey.shade200,
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: dayEvents.isNotEmpty
                            ? Container(
                                margin: const EdgeInsets.all(1),
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: dayEvents.first.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  dayEvents.first.title,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMonthlyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildMonthHeader(),
          _buildMonthGrid(),
          const SizedBox(height: 16),
          Container(
            constraints: BoxConstraints(minHeight: 200),
            child: _buildEventsList(
              _calendarState.getEventsForMonth(
                _calendarState.selectedDate.year,
                _calendarState.selectedDate.month,
              ),
              "${DateFormat('MMMM').format(_calendarState.selectedDate)} Events",
            ),
          ),
          const SizedBox(height: 100), // Extra space for floating action button
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                day,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthGrid() {
    final firstDayOfMonth = DateTime(
      _calendarState.selectedDate.year,
      _calendarState.selectedDate.month,
      1,
    );
    final lastDayOfMonth = DateTime(
      _calendarState.selectedDate.year,
      _calendarState.selectedDate.month + 1,
      0,
    );
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return Container(
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final isCurrentMonth =
              date.month == _calendarState.selectedDate.month;
          final isToday = _isToday(date);
          final isSelected = _isSameDay(date, _calendarState.selectedDate);
          final dayEvents = _calendarState.getEventsForDate(date);

          return GestureDetector(
            onTap: () {
              setState(() {
                _calendarState = _calendarState.copyWith(selectedDate: date);
              });
            },
            child: Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.yellow.shade400 : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isToday ? Colors.red : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isToday
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !isCurrentMonth
                              ? Colors.grey.shade400
                              : isToday
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  if (dayEvents.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: dayEvents.take(3).map((event) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: event.color,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildYearlyView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _calendarState = _calendarState.copyWith(
                        selectedDate: DateTime(
                          _calendarState.selectedDate.year - 1,
                          _calendarState.selectedDate.month,
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_left),
                ),
                Text(
                  _calendarState.selectedDate.year.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _calendarState = _calendarState.copyWith(
                        selectedDate: DateTime(
                          _calendarState.selectedDate.year + 1,
                          _calendarState.selectedDate.month,
                        ),
                      );
                    });
                  },
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              final month = index + 1;
              final monthDate = DateTime(
                _calendarState.selectedDate.year,
                month,
              );
              final monthEvents = _calendarState.getEventsForMonth(
                _calendarState.selectedDate.year,
                month,
              );

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _calendarState = _calendarState.copyWith(
                      selectedDate: monthDate,
                      currentView: CalendarView.monthly,
                    );
                  });
                },
                child: Container(
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
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          DateFormat('MMMM').format(monthDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(child: _buildMiniMonthGrid(monthDate)),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          '${monthEvents.length} events',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 100), // Extra space for floating action button
        ],
      ),
    );
  }

  Widget _buildMiniMonthGrid(DateTime monthDate) {
    final firstDayOfMonth = DateTime(monthDate.year, monthDate.month, 1);
    final startDate = firstDayOfMonth.subtract(
      Duration(days: firstDayOfMonth.weekday % 7),
    );

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 35,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == monthDate.month;
        final dayEvents = _calendarState.getEventsForDate(date);

        return Container(
          margin: const EdgeInsets.all(0.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: 8,
                  color: !isCurrentMonth
                      ? Colors.grey.shade400
                      : Colors.black87,
                ),
              ),
              if (dayEvents.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 1),
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: dayEvents.first.color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsList(List<CalendarEvent> events, String title) {
    if (events.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              'No events scheduled',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    List<CalendarEvent> prioritizedEvents = List.from(events);
    if (_tappedEvent != null && prioritizedEvents.contains(_tappedEvent)) {
      prioritizedEvents.remove(_tappedEvent);
      prioritizedEvents.insert(0, _tappedEvent!);
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 0),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: prioritizedEvents.length,
            itemBuilder: (context, index) {
              final event = prioritizedEvents[index];
              return GestureDetector(
                onTap: () {
                  _showEventDetails(event);
                },
                child: _buildEventCard(event),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(CalendarEvent event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 4,
            height: 60,
            decoration: BoxDecoration(
              color: event.color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _getEventIcon(event.type),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'edit') {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CalendarNewEntryScreen(
                                selectedDate: event.startTime,
                                eventToEdit: event,
                              ),
                            ),
                          );

                          if (result != null && result is CalendarEvent) {
                            setState(() {
                              final updatedEvents = List<CalendarEvent>.from(
                                _calendarState.events,
                              );
                              final index = updatedEvents.indexWhere(
                                (e) => e.id == event.id,
                              );
                              if (index != -1) {
                                updatedEvents[index] = result;
                              }
                              _calendarState = _calendarState.copyWith(
                                events: updatedEvents,
                              );
                            });
                          }
                        } else if (value == 'delete') {
                          _deleteEvent(event);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 16),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 16, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: const Icon(Icons.more_horiz, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.isAllDay
                          ? 'All day'
                          : '${DateFormat('h:mm a').format(event.startTime)} - ${DateFormat('h:mm a').format(event.endTime)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                if (event.attendees.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${event.attendees.length} attendees',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
                if (event.location.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        event.location.toLowerCase().contains('phone')
                            ? Icons.phone
                            : Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        event.location,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getEventIcon(EventType eventType) {
    IconData iconData;
    Color iconColor;

    switch (eventType) {
      case EventType.meeting:
        iconData = Icons.people_outline;
        iconColor = Colors.blue;
        break;
      case EventType.review:
        iconData = Icons.rate_review_outlined;
        iconColor = Colors.green;
        break;
      case EventType.call:
        iconData = Icons.phone_outlined;
        iconColor = Colors.orange;
        break;
      case EventType.session:
        iconData = Icons.fitness_center_outlined;
        iconColor = Colors.purple;
        break;
      case EventType.birthday:
        iconData = Icons.cake_outlined;
        iconColor = Colors.red;
        break;
      case EventType.other:
        iconData = Icons.event_outlined;
        iconColor = Colors.grey;
        break;
    }

    return Icon(iconData, size: 16, color: iconColor);
  }

  DateTime _getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday % 7));
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _previousPeriod() {
    setState(() {
      DateTime newDate;
      switch (_calendarState.currentView) {
        case CalendarView.today:
          newDate = _calendarState.selectedDate.subtract(
            const Duration(days: 1),
          );
          break;
        case CalendarView.weekly:
          newDate = _calendarState.selectedDate.subtract(
            const Duration(days: 7),
          );
          break;
        case CalendarView.monthly:
          newDate = DateTime(
            _calendarState.selectedDate.year,
            _calendarState.selectedDate.month - 1,
          );
          break;
        case CalendarView.yearly:
          newDate = DateTime(
            _calendarState.selectedDate.year - 1,
            _calendarState.selectedDate.month,
          );
          break;
      }
      _calendarState = _calendarState.copyWith(selectedDate: newDate);
    });
  }

  void _nextPeriod() {
    setState(() {
      DateTime newDate;
      switch (_calendarState.currentView) {
        case CalendarView.today:
          newDate = _calendarState.selectedDate.add(const Duration(days: 1));
          break;
        case CalendarView.weekly:
          newDate = _calendarState.selectedDate.add(const Duration(days: 7));
          break;
        case CalendarView.monthly:
          newDate = DateTime(
            _calendarState.selectedDate.year,
            _calendarState.selectedDate.month + 1,
          );
          break;
        case CalendarView.yearly:
          newDate = DateTime(
            _calendarState.selectedDate.year + 1,
            _calendarState.selectedDate.month,
          );
          break;
      }
      _calendarState = _calendarState.copyWith(selectedDate: newDate);
    });
  }

  void _navigateToNewEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CalendarNewEntryScreen(selectedDate: _calendarState.selectedDate),
      ),
    );

    if (result != null && result is CalendarEvent) {
      setState(() {
        final updatedEvents = List<CalendarEvent>.from(_calendarState.events);
        updatedEvents.add(result);
        _calendarState = _calendarState.copyWith(events: updatedEvents);
      });
    }
  }

  void _deleteEvent(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final updatedEvents = List<CalendarEvent>.from(
                  _calendarState.events,
                );
                updatedEvents.removeWhere((e) => e.id == event.id);
                _calendarState = _calendarState.copyWith(events: updatedEvents);
              });
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEventDetails(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => CalendarEntryViewScreen(event: event),
    ).then((_) {
      setState(() {
        _tappedEvent = event;
      });
    });
  }
}
