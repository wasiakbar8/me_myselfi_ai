import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/budget_model.dart';
import '../utils/budget_helper.dart';
import 'budget_newentry_screen.dart';
import 'budget_settings_screen.dart';

class BudgetTrackingScreen extends StatefulWidget {
  const BudgetTrackingScreen({Key? key}) : super(key: key);

  @override
  State<BudgetTrackingScreen> createState() => _BudgetTrackingScreenState();
}

class _BudgetTrackingScreenState extends State<BudgetTrackingScreen> {
  DateTime _currentPeriodStart = DateTime.now().subtract(
    Duration(days: DateTime.now().weekday - 1),
  );
  BudgetCategory _selectedCategory = BudgetCategory.all;
  late SharedPreferences _prefs;
  bool _isLoading = true;
  bool _isFirstTime = true;

  BudgetSettings _budgetSettings = BudgetSettings(
    weeklyBudget: 0.0,
    monthlyBudget: 0.0,
    activePeriod: BudgetPeriod.weekly,
    categoryLimits: {},
  );

  List<BudgetEntry> _budgetEntries = [
    BudgetEntry(
      id: '1',
      title: 'Lunch at Restaurant',
      amount: 45.50,
      category: BudgetCategory.food,
      date: DateTime.now().subtract(Duration(days: 1)),
      description: 'Lunch with colleagues',
    ),
    BudgetEntry(
      id: '2',
      title: 'Grocery Shopping',
      amount: 89.25,
      category: BudgetCategory.food,
      date: DateTime.now().subtract(Duration(days: 2)),
      description: 'Weekly groceries',
    ),
    BudgetEntry(
      id: '3',
      title: 'Movie Tickets',
      amount: 28.00,
      category: BudgetCategory.entertainment,
      date: DateTime.now().subtract(Duration(days: 3)),
      description: 'Cinema night',
    ),
    BudgetEntry(
      id: '4',
      title: 'Electricity Bill',
      amount: 125.00,
      category: BudgetCategory.bills,
      date: DateTime.now().subtract(Duration(days: 4)),
      description: 'Monthly electricity',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    try {
      print('Initializing SharedPreferences...');
      _prefs = await SharedPreferences.getInstance().timeout(Duration(seconds: 5));
      print('SharedPreferences initialized');
      await _loadBudgetSettings();
    } catch (e) {
      print('Error initializing preferences: $e');
      setState(() {
        _isLoading = false;
        _isFirstTime = true;
      });
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToBudgetSettings();
        });
      }
    }
  }

  Future<void> _loadBudgetSettings() async {
    try {
      print('Loading budget settings...');
      _isFirstTime = _prefs.getBool('isFirstTime') ?? true;

      if (!_isFirstTime) {
        final weeklyBudget = _prefs.getDouble('weeklyBudget') ?? 0.0;
        final monthlyBudget = _prefs.getDouble('monthlyBudget') ?? 0.0;
        final periodString = _prefs.getString('activePeriod') ?? 'weekly';
        final categoryLimitsJson = _prefs.getString('categoryLimits') ?? '{}';

        Map<BudgetCategory, double> categoryLimits = {};
        try {
          final decoded = jsonDecode(categoryLimitsJson) as Map<String, dynamic>;
          categoryLimits = decoded.map(
                (key, value) {
              try {
                return MapEntry(
                  BudgetCategory.values.firstWhere(
                        (e) => e.toString() == key,
                    orElse: () => BudgetCategory.all,
                  ),
                  value is num ? value.toDouble() : 0.0,
                );
              } catch (e) {
                print('Error parsing category $key: $e');
                return MapEntry(BudgetCategory.all, 0.0);
              }
            },
          )..removeWhere((key, value) => key == BudgetCategory.all);
        } catch (e) {
          print('Error decoding categoryLimits: $e');
        }

        _budgetSettings = BudgetSettings(
          weeklyBudget: weeklyBudget,
          monthlyBudget: monthlyBudget,
          activePeriod: periodString == 'weekly' ? BudgetPeriod.weekly : BudgetPeriod.monthly,
          categoryLimits: categoryLimits,
        );
      }

      setState(() {
        _isLoading = false;
      });

      if (_isFirstTime && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToBudgetSettings();
        });
      }
      print('Budget settings loaded: $_budgetSettings');
    } catch (e) {
      print('Error loading budget settings: $e');
      setState(() {
        _isLoading = false;
        _isFirstTime = true;
      });
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _navigateToBudgetSettings();
        });
      }
    }
  }

  Future<void> _saveBudgetSettings(BudgetSettings settings) async {
    try {
      print('Saving budget settings: $settings');
      setState(() {
        _budgetSettings = settings;
        _isFirstTime = false;
      });
      await _prefs.setBool('isFirstTime', false);
      await _prefs.setDouble('weeklyBudget', settings.weeklyBudget);
      await _prefs.setDouble('monthlyBudget', settings.monthlyBudget);
      await _prefs.setString('activePeriod', settings.activePeriod == BudgetPeriod.weekly ? 'weekly' : 'monthly');
      await _prefs.setString(
        'categoryLimits',
        jsonEncode(
          settings.categoryLimits.map((key, value) => MapEntry(key.toString(), value)),
        ),
      );
      print('Budget settings saved');
    } catch (e) {
      print('Error saving budget settings: $e');
    }
  }

  double get totalBudget {
    return _budgetSettings.activePeriod == BudgetPeriod.weekly
        ? _budgetSettings.weeklyBudget
        : _budgetSettings.monthlyBudget;
  }

  double get totalSpent {
    return _getFilteredEntries().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  double get remaining => totalBudget - totalSpent;

  DateTime get _currentPeriodEnd {
    if (_budgetSettings.activePeriod == BudgetPeriod.weekly) {
      return _currentPeriodStart.add(Duration(days: 6));
    } else {
      return DateTime(
        _currentPeriodStart.year,
        _currentPeriodStart.month + 1,
        0,
      );
    }
  }

  String get _periodLabel {
    return _budgetSettings.activePeriod == BudgetPeriod.weekly
        ? 'This Week'
        : 'This Month';
  }

  List<BudgetEntry> _getFilteredEntries() {
    DateTime periodEnd = _currentPeriodEnd;
    return _budgetEntries.where((entry) {
      bool inDateRange =
          entry.date.isAfter(_currentPeriodStart.subtract(Duration(days: 1))) &&
              entry.date.isBefore(periodEnd.add(Duration(days: 1)));
      if (_selectedCategory == BudgetCategory.all) {
        return inDateRange;
      }
      return inDateRange && entry.category == _selectedCategory;
    }).toList();
  }

  void _navigateToNewEntry() async {
    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      _navigateToBudgetSettings();
      return;
    }
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BudgetNewEntryScreen()),
    );

    if (result != null && result is BudgetEntry) {
      setState(() {
        _budgetEntries.add(result);
      });
    }
  }

  void _navigateToBudgetSettings() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetSettingsScreen(
          currentSettings: _budgetSettings,
        ),
      ),
    );

    if (result != null && result is BudgetSettings) {
      await _saveBudgetSettings(result);
    }
  }

  void _changePeriod(bool isNext) {
    setState(() {
      if (_budgetSettings.activePeriod == BudgetPeriod.weekly) {
        _currentPeriodStart = _currentPeriodStart.add(Duration(days: isNext ? 7 : -7));
      } else {
        _currentPeriodStart = DateTime(
          _currentPeriodStart.year,
          _currentPeriodStart.month + (isNext ? 1 : -1),
          1,
        );
      }
    });
  }

  String _getAIInsight() {
    Map<BudgetCategory, double> categorySpending = {};
    for (var entry in _getFilteredEntries()) {
      categorySpending[entry.category] = (categorySpending[entry.category] ?? 0) + entry.amount;
    }

    if (categorySpending.isEmpty) {
      return "No spending data available for this period.";
    }

    if (totalSpent == 0) {
      return "No expenses recorded for this period.";
    }

    var highestCategory = categorySpending.entries.reduce(
          (a, b) => a.value > b.value ? a : b,
    );
    double percentage = (highestCategory.value / totalSpent * 100);

    if (percentage > 50) {
      return "⚠️ You're spending ${percentage.toStringAsFixed(0)}% on ${BudgetHelper.getCategoryName(highestCategory.key)}. Consider reducing expenses in this category.";
    } else if (remaining < totalBudget * 0.2) {
      return "💡 You're close to your budget limit. Try to be more mindful of your spending.";
    } else {
      return "✅ Good spending habits! You're well within your budget for this period.";
    }
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 10, 16, 10),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.black87),
            onPressed: () {},
          ),
          Expanded(
            child: Text(
              'Budget Tracking',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black87),
            onPressed: _navigateToBudgetSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetSummary() {
    if (_isLoading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading budget data...', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }

    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.account_balance_wallet,
              size: 48,
              color: Color(0xFFFFD700),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Budget Tracking!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Set up your budget to start tracking your expenses and manage your finances better.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToBudgetSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFD700),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text('Setup Budget'),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 3,
            children: [
              Text(
                'Budget Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Color(0xFFFFD700).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _periodLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFB8860B),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, size: 16),
                      onPressed: () => _changePeriod(false),
                    ),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, size: 16),
                      onPressed: () => _changePeriod(true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${BudgetHelper.formatDate(_currentPeriodStart)} - ${BudgetHelper.formatDate(_currentPeriodEnd)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Total Budget',
                  '\$${totalBudget.toStringAsFixed(2)}',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Total Spent',
                  '\$${totalSpent.toStringAsFixed(2)}',
                  Colors.red,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Remaining',
                  '\$${remaining.toStringAsFixed(2)}',
                  remaining >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAIInsight() {
    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Color(0xFFFFD700), size: 20),
              SizedBox(width: 12),
              Text(
                'AI Insight',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _getAIInsight(),
            style: TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingProgress() {
    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      return SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Progress',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              DropdownButton<BudgetCategory>(
                value: _selectedCategory,
                onChanged: (BudgetCategory? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedCategory = newValue;
                    });
                  }
                },
                items: BudgetCategory.values
                    .map<DropdownMenuItem<BudgetCategory>>((category) {
                  return DropdownMenuItem<BudgetCategory>(
                    value: category,
                    child: Text(BudgetHelper.getCategoryName(category)),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value.toInt()}',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (_budgetSettings.activePeriod == BudgetPeriod.weekly) {
                          const days = [
                            'Mon',
                            'Tue',
                            'Wed',
                            'Thu',
                            'Fri',
                            'Sat',
                            'Sun',
                          ];
                          if (value.toInt() >= 0 && value.toInt() < days.length) {
                            return Text(
                              days[value.toInt()],
                              style: TextStyle(fontSize: 10),
                            );
                          }
                        } else {
                          return Text(
                            'W${value.toInt() + 1}',
                            style: TextStyle(fontSize: 10),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: Color(0xFFFFD700),
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFFFFD700).withOpacity(0.2),
                    ),
                    dotData: FlDotData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _getChartData() {
    List<FlSpot> spots = [];

    if (_budgetSettings.activePeriod == BudgetPeriod.weekly) {
      for (int i = 0; i < 7; i++) {
        DateTime day = _currentPeriodStart.add(Duration(days: i));
        double dayTotal = _getFilteredEntries()
            .where((entry) => BudgetHelper.isSameDay(entry.date, day))
            .fold(0.0, (sum, entry) => sum + entry.amount);
        spots.add(FlSpot(i.toDouble(), dayTotal));
      }
    } else {
      int weeksInMonth = 4;
      for (int i = 0; i < weeksInMonth; i++) {
        DateTime weekStart = _currentPeriodStart.add(Duration(days: i * 7));
        DateTime weekEnd = weekStart.add(Duration(days: 6));
        double weekTotal = _getFilteredEntries()
            .where(
              (entry) =>
          entry.date.isAfter(weekStart.subtract(Duration(days: 1))) &&
              entry.date.isBefore(weekEnd.add(Duration(days: 1))),
        )
            .fold(0.0, (sum, entry) => sum + entry.amount);
        spots.add(FlSpot(i.toDouble(), weekTotal));
      }
    }

    return spots;
  }

  Widget _buildExpenseCategories() {
    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      return SizedBox.shrink();
    }

    Map<BudgetCategory, double> categoryTotals = {};
    for (var entry in _getFilteredEntries()) {
      if (entry.category != BudgetCategory.all) {
        categoryTotals[entry.category] = (categoryTotals[entry.category] ?? 0) + entry.amount;
      }
    }

    if (categoryTotals.isEmpty) {
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(Icons.category_outlined, size: 48, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No expenses yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Add your first expense to see category breakdown',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expense Categories',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Icon(Icons.tune, color: Colors.grey[600]),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: categoryTotals.length,
            itemBuilder: (context, index) {
              var category = categoryTotals.keys.elementAt(index);
              var amount = categoryTotals[category]!;
              var categoryLimit = _budgetSettings.categoryLimits[category] ?? totalBudget * 0.3;
              var progress = categoryLimit > 0 ? amount / categoryLimit : 0.0;

              return Container(
                width: 140,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          BudgetHelper.getCategoryIcon(category),
                          color: BudgetHelper.getCategoryColor(category),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            BudgetHelper.getCategoryName(category),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'of \$${categoryLimit.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        progress > 1.0
                            ? Colors.red
                            : BudgetHelper.getCategoryColor(category),
                      ),
                    ),
                    if (progress > 0.8) ...[
                      SizedBox(height: 4),
                      Text(
                        progress > 1.0 ? 'Over limit!' : 'Near limit',
                        style: TextStyle(
                          fontSize: 9,
                          color: progress > 1.0 ? Colors.red : Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    if (_isFirstTime || (_budgetSettings.weeklyBudget == 0 && _budgetSettings.monthlyBudget == 0)) {
      return SizedBox.shrink();
    }

    var recentEntries = _budgetEntries
        .where((entry) => _getFilteredEntries().contains(entry))
        .take(5)
        .toList();

    if (recentEntries.isEmpty) {
      return Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            Text(
              'Your recent expenses will appear here',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...recentEntries.map((entry) => _buildTransactionItem(entry)).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BudgetEntry entry) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: BudgetHelper.getCategoryColor(entry.category).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              BudgetHelper.getCategoryIcon(entry.category),
              color: BudgetHelper.getCategoryColor(entry.category),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  BudgetHelper.formatDateTime(entry.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '-\$${entry.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildCustomAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBudgetSummary(),
                  _buildAIInsight(),
                  SizedBox(height: 16),
                  _buildSpendingProgress(),
                  SizedBox(height: 20),
                  _buildExpenseCategories(),
                  SizedBox(height: 20),
                  _buildRecentTransactions(),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToNewEntry,
        backgroundColor: Color(0xFFFFD700),
        child: Icon(Icons.add, color: Colors.black87),
      ),
    );
  }
}