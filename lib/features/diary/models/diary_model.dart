// lib/features/diary/models/diary_model.dart
enum DiaryCategory {
  personal,
  work,
  gratitude,
  ideas
}

enum TimePeriod {
  today,
  thisWeek,
  thisMonth,
  lastMonth,
  allTime
}

class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final DiaryCategory category;
  final List<String> keywords;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;

  DiaryEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.keywords,
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
  });

  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    DiaryCategory? category,
    List<String>? keywords,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      keywords: keywords ?? this.keywords,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final entryDate = DateTime(createdAt.year, createdAt.month, createdAt.day);

    if (entryDate == today) {
      return 'Today';
    } else if (entryDate == yesterday) {
      return 'Yesterday';
    } else {
      final difference = today.difference(entryDate).inDays;
      if (difference < 7) {
        return '$difference days ago';
      } else {
        return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
      }
    }
  }

  String get timeFormatted {
    final hour = createdAt.hour;
    final minute = createdAt.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String get preview {
    if (content.length <= 100) return content;
    return '${content.substring(0, 100)}...';
  }
}