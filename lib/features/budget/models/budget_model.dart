// lib/features/budget/models/budget_model.dart

enum BudgetCategory {
  all,
  food,
  bills,
  entertainment,
  transport,
  shopping,
  health,
  education,
  other,
}

class BudgetEntry {
  final String id;
  final String title;
  final double amount;
  final BudgetCategory category;
  final DateTime date;
  final String? description;

  BudgetEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category.toString(),
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  factory BudgetEntry.fromJson(Map<String, dynamic> json) {
    return BudgetEntry(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: BudgetCategory.values.firstWhere(
            (e) => e.toString() == json['category'],
        orElse: () => BudgetCategory.other,
      ),
      date: DateTime.parse(json['date']),
      description: json['description'],
    );
  }

  BudgetEntry copyWith({
    String? id,
    String? title,
    double? amount,
    BudgetCategory? category,
    DateTime? date,
    String? description,
  }) {
    return BudgetEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}

class BudgetSummary {
  final double totalBudget;
  final double totalSpent;
  final double remaining;
  final DateTime weekStart;
  final DateTime weekEnd;
  final Map<BudgetCategory, double> categorySpending;

  BudgetSummary({
    required this.totalBudget,
    required this.totalSpent,
    required this.remaining,
    required this.weekStart,
    required this.weekEnd,
    required this.categorySpending,
  });

  double get spentPercentage => totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0;

  bool get isOverBudget => totalSpent > totalBudget;

  bool get isNearBudgetLimit => remaining < (totalBudget * 0.2);
}