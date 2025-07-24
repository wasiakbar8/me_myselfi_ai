// lib/features/budget/utils/budget_helper.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/budget_model.dart';

class BudgetHelper {
  // Category colors
  static Color getCategoryColor(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.all:
        return Colors.blue;
      case BudgetCategory.food:
        return Colors.orange;
      case BudgetCategory.bills:
        return Colors.red;
      case BudgetCategory.entertainment:
        return Colors.purple;
      case BudgetCategory.transport:
        return Colors.green;
      case BudgetCategory.shopping:
        return Colors.pink;
      case BudgetCategory.health:
        return Colors.teal;
      case BudgetCategory.education:
        return Colors.indigo;
      case BudgetCategory.other:
        return Colors.grey;
    }
  }

  // Category icons
  static IconData getCategoryIcon(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.all:
        return Icons.category;
      case BudgetCategory.food:
        return Icons.restaurant;
      case BudgetCategory.bills:
        return Icons.receipt_long;
      case BudgetCategory.entertainment:
        return Icons.movie;
      case BudgetCategory.transport:
        return Icons.directions_car;
      case BudgetCategory.shopping:
        return Icons.shopping_bag;
      case BudgetCategory.health:
        return Icons.local_hospital;
      case BudgetCategory.education:
        return Icons.school;
      case BudgetCategory.other:
        return Icons.more_horiz;
    }
  }

  // Category names
  static String getCategoryName(BudgetCategory category) {
    switch (category) {
      case BudgetCategory.all:
        return 'All Categories';
      case BudgetCategory.food:
        return 'Food & Dining';
      case BudgetCategory.bills:
        return 'Bills';
      case BudgetCategory.entertainment:
        return 'Entertainment';
      case BudgetCategory.transport:
        return 'Transport';
      case BudgetCategory.shopping:
        return 'Shopping';
      case BudgetCategory.health:
        return 'Health';
      case BudgetCategory.education:
        return 'Education';
      case BudgetCategory.other:
        return 'Other';
    }
  }

  // Date formatting
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, hh:mm a').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('MMM dd').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  // Date utilities
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  static bool isYesterday(DateTime date) {
    return isSameDay(date, DateTime.now().subtract(Duration(days: 1)));
  }

  static DateTime getWeekStart(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static DateTime getWeekEnd(DateTime date) {
    return getWeekStart(date).add(Duration(days: 6));
  }

  static DateTime getMonthStart(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  static DateTime getMonthEnd(DateTime date) {
    return DateTime(date.year, date.month + 1, 0);
  }

  // Amount formatting
  static String formatAmount(double amount) {
    return NumberFormat.currency(symbol: '\$', decimalDigits: 2).format(amount);
  }

  static String formatAmountCompact(double amount) {
    if (amount >= 1000000) {
      return '\$${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return '\$${amount.toStringAsFixed(2)}';
    }
  }

  // Budget analysis
  static String getBudgetStatus(double spent, double budget) {
    if (budget <= 0) return 'No budget set';

    double percentage = (spent / budget) * 100;

    if (percentage >= 100) {
      return 'Over budget!';
    } else if (percentage >= 80) {
      return 'Near budget limit';
    } else if (percentage >= 50) {
      return 'On track';
    } else {
      return 'Under budget';
    }
  }

  static Color getBudgetStatusColor(double spent, double budget) {
    if (budget <= 0) return Colors.grey;

    double percentage = (spent / budget) * 100;

    if (percentage >= 100) {
      return Colors.red;
    } else if (percentage >= 80) {
      return Colors.orange;
    } else if (percentage >= 50) {
      return Colors.yellow[700]!;
    } else {
      return Colors.green;
    }
  }

  // AI insights generation
  static String generateSpendingInsight(List<BudgetEntry> entries, double budget) {
    if (entries.isEmpty) {
      return "No spending data available for analysis.";
    }

    // Calculate category spending
    Map<BudgetCategory, double> categorySpending = {};
    double totalSpent = 0;

    for (var entry in entries) {
      if (entry.category != BudgetCategory.all) {
        categorySpending[entry.category] =
            (categorySpending[entry.category] ?? 0) + entry.amount;
        totalSpent += entry.amount;
      }
    }

    if (categorySpending.isEmpty) {
      return "No categorized spending data available.";
    }

    // Find highest spending category
    var highestCategory = categorySpending.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    double highestPercentage = (highestCategory.value / totalSpent * 100);

    // Generate insights based on spending patterns
    List<String> insights = [];

    // High spending category warning
    if (highestPercentage > 50) {
      insights.add("⚠️ ${highestPercentage.toStringAsFixed(0)}% of your spending is on ${getCategoryName(highestCategory.key)}. Consider reducing expenses in this category.");
    }

    // Budget status
    if (budget > 0) {
      double budgetPercentage = (totalSpent / budget * 100);
      if (budgetPercentage >= 100) {
        insights.add("🚨 You've exceeded your budget by \$${(totalSpent - budget).toStringAsFixed(2)}!");
      } else if (budgetPercentage >= 80) {
        insights.add("💡 You've used ${budgetPercentage.toStringAsFixed(0)}% of your budget. Be mindful of remaining expenses.");
      } else {
        insights.add("✅ Good job! You're ${budgetPercentage.toStringAsFixed(0)}% through your budget with \$${(budget - totalSpent).toStringAsFixed(2)} remaining.");
      }
    }

    // Spending frequency
    Map<DateTime, double> dailySpending = {};
    for (var entry in entries) {
      DateTime day = DateTime(entry.date.year, entry.date.month, entry.date.day);
      dailySpending[day] = (dailySpending[day] ?? 0) + entry.amount;
    }

    if (dailySpending.length <= 2) {
      insights.add("📈 Try to spread your expenses throughout the week for better budget management.");
    }

    return insights.isNotEmpty ? insights.first : "Keep tracking your expenses for better insights!";
  }

  // Chart data helpers
  static List<double> getDailySpendingForWeek(List<BudgetEntry> entries, DateTime weekStart) {
    List<double> dailySpending = List.filled(7, 0.0);

    for (var entry in entries) {
      int dayIndex = entry.date.difference(weekStart).inDays;
      if (dayIndex >= 0 && dayIndex < 7) {
        dailySpending[dayIndex] += entry.amount;
      }
    }

    return dailySpending;
  }

  static Map<BudgetCategory, double> getCategorySpending(List<BudgetEntry> entries) {
    Map<BudgetCategory, double> categorySpending = {};

    for (var entry in entries) {
      if (entry.category != BudgetCategory.all) {
        categorySpending[entry.category] =
            (categorySpending[entry.category] ?? 0) + entry.amount;
      }
    }

    return categorySpending;
  }

  // Validation helpers
  static bool isValidAmount(String amount) {
    if (amount.isEmpty) return false;
    final parsedAmount = double.tryParse(amount);
    return parsedAmount != null && parsedAmount > 0;
  }

  static String? validateTitle(String? title) {
    if (title == null || title.trim().isEmpty) {
      return 'Please enter a title';
    }
    if (title.trim().length < 2) {
      return 'Title must be at least 2 characters';
    }
    return null;
  }

  static String? validateAmount(String? amount) {
    if (amount == null || amount.trim().isEmpty) {
      return 'Please enter an amount';
    }
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'Please enter a valid amount';
    }
    return null;
  }
}