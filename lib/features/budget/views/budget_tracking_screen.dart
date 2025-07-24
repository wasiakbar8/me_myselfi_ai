// lib/features/budget/views/budget_tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';
import '../models/budget_model.dart';
import '../utils/budget_helper.dart';
import 'budget_newentry_screen.dart';

class BudgetTrackingScreen extends StatefulWidget {
  const BudgetTrackingScreen({Key? key}) : super(key: key);

  @override
  State<BudgetTrackingScreen> createState() => _BudgetTrackingScreenState();
}

class _BudgetTrackingScreenState extends State<BudgetTrackingScreen> {
  DateTime _currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  BudgetCategory _selectedCategory = BudgetCategory.all;
  String _selectedPeriod = 'This Week';

  // Sample data - replace with your actual data source
  final List<BudgetEntry> _budgetEntries = [
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

  double get totalBudget => 1250.00;

  double get totalSpent {
    return _getFilteredEntries().fold(0.0, (sum, entry) => sum + entry.amount);
  }

  double get remaining => totalBudget - totalSpent;

  List<BudgetEntry> _getFilteredEntries() {
    DateTime weekEnd = _currentWeekStart.add(Duration(days: 6));
    return _budgetEntries.where((entry) {
      bool inDateRange = entry.date.isAfter(_currentWeekStart.subtract(Duration(days: 1))) &&
          entry.date.isBefore(weekEnd.add(Duration(days: 1)));

      if (_selectedCategory == BudgetCategory.all) {
        return inDateRange;
      }
      return inDateRange && entry.category == _selectedCategory;
    }).toList();
  }

  void _navigateToNewEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BudgetNewEntryScreen(),
      ),
    );

    if (result != null && result is BudgetEntry) {
      setState(() {
        _budgetEntries.add(result);
      });
    }
  }

  void _changeWeek(bool isNext) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: isNext ? 7 : -7));
    });
  }

  String _getAIInsight() {
    Map<BudgetCategory, double> categorySpending = {};

    for (var entry in _getFilteredEntries()) {
      categorySpending[entry.category] = (categorySpending[entry.category] ?? 0) + entry.amount;
    }

    if (categorySpending.isEmpty) return "No spending data available for this week.";

    var highestCategory = categorySpending.entries.reduce((a, b) => a.value > b.value ? a : b);
    double percentage = (highestCategory.value / totalSpent * 100);

    if (percentage > 50) {
      return "⚠️ You're spending ${percentage.toStringAsFixed(0)}% on ${BudgetHelper.getCategoryName(highestCategory.key)}. Consider reducing expenses in this category.";
    } else if (remaining < totalBudget * 0.2) {
      return "💡 You're close to your budget limit. Try to be more mindful of your spending.";
    } else {
      return "✅ Good spending habits! You're well within your budget for this week.";
    }
  }


  Widget _buildBudgetSummary() {
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
                'Budget Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 16),
                    onPressed: () => _changeWeek(false),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => _changeWeek(true),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            '${BudgetHelper.formatDate(_currentWeekStart)} - ${BudgetHelper.formatDate(_currentWeekStart.add(Duration(days: 6)))}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem('Total Budget', '\$${totalBudget.toStringAsFixed(2)}', Colors.blue),
              ),
              Expanded(
                child: _buildSummaryItem('Total Spent', '\$${totalSpent.toStringAsFixed(2)}', Colors.red),
              ),
              Expanded(
                child: _buildSummaryItem('Remaining', '\$${remaining.toStringAsFixed(2)}', Colors.green),
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
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
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
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFFFF8DC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
      ),
      child: Row(
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
    );
  }

  Widget _buildSpendingProgress() {
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
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                items: BudgetCategory.values.map<DropdownMenuItem<BudgetCategory>>(
                      (BudgetCategory category) {
                    return DropdownMenuItem<BudgetCategory>(
                      value: category,
                      child: Text(BudgetHelper.getCategoryName(category)),
                    );
                  },
                ).toList(),
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
                        return Text('\$${value.toInt()}', style: TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(days[value.toInt()], style: TextStyle(fontSize: 10));
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
    for (int i = 0; i < 7; i++) {
      DateTime day = _currentWeekStart.add(Duration(days: i));
      double dayTotal = _getFilteredEntries()
          .where((entry) => BudgetHelper.isSameDay(entry.date, day))
          .fold(0.0, (sum, entry) => sum + entry.amount);
      spots.add(FlSpot(i.toDouble(), dayTotal));
    }
    return spots;
  }

  Widget _buildExpenseCategories() {
    Map<BudgetCategory, double> categoryTotals = {};
    for (var entry in _getFilteredEntries()) {
      if (entry.category != BudgetCategory.all) {
        categoryTotals[entry.category] = (categoryTotals[entry.category] ?? 0) + entry.amount;
      }
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
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: categoryTotals.length,
            itemBuilder: (context, index) {
              var category = categoryTotals.keys.elementAt(index);
              var amount = categoryTotals[category]!;
              var progress = amount / totalSpent;

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
                      'of \$400',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        BudgetHelper.getCategoryColor(category),
                      ),
                    ),
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
    var recentEntries = _budgetEntries.take(5).toList();

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
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
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
      appBar: CustomAppBar(
        title: 'Budget Tracking',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },
      ),
      drawer: HamburgerDrawer(onItemSelected: (index) {}),
      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBudgetSummary(),
                  _buildAIInsight(),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF8DC),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getAIInsight(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _buildSpendingProgress(),
                  SizedBox(height: 20),
                  _buildExpenseCategories(),
                  SizedBox(height: 20),
                  _buildRecentTransactions(),
                  SizedBox(height: 100), // Space for FAB
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