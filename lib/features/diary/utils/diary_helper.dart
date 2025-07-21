// lib/features/diary/utils/diary_helper.dart
import 'package:flutter/material.dart';
import '../models/diary_model.dart';

class DiaryHelper {
  static Color getCategoryColor(DiaryCategory category) {
    switch (category) {
      case DiaryCategory.personal:
        return const Color(0xFFFFD700); // Yellow
      case DiaryCategory.work:
        return const Color(0xFF6B7280); // Gray
      case DiaryCategory.gratitude:
        return const Color(0xFFF59E0B); // Amber
      case DiaryCategory.ideas:
        return const Color(0xFF8B5CF6); // Purple
    }
  }

  static IconData getCategoryIcon(DiaryCategory category) {
    switch (category) {
      case DiaryCategory.personal:
        return Icons.person;
      case DiaryCategory.work:
        return Icons.work;
      case DiaryCategory.gratitude:
        return Icons.favorite;
      case DiaryCategory.ideas:
        return Icons.lightbulb;
    }
  }

  static String getCategoryName(DiaryCategory category) {
    switch (category) {
      case DiaryCategory.personal:
        return 'Personal';
      case DiaryCategory.work:
        return 'Work';
      case DiaryCategory.gratitude:
        return 'Gratitude';
      case DiaryCategory.ideas:
        return 'Ideas';
    }
  }

  static String getTimePeriodName(TimePeriod period) {
    switch (period) {
      case TimePeriod.today:
        return 'Today';
      case TimePeriod.thisWeek:
        return 'This Week';
      case TimePeriod.thisMonth:
        return 'This Month';
      case TimePeriod.lastMonth:
        return 'Last Month';
      case TimePeriod.allTime:
        return 'All Time';
    }
  }

  static int getEntryCount(DiaryCategory category, List<DiaryEntry> entries) {
    return entries.where((entry) => entry.category == category).length;
  }

  static bool isEntryInTimePeriod(DiaryEntry entry, TimePeriod period) {
    final now = DateTime.now();
    final entryDate = entry.createdAt;

    switch (period) {
      case TimePeriod.today:
        return DateTime(entryDate.year, entryDate.month, entryDate.day) ==
            DateTime(now.year, now.month, now.day);

      case TimePeriod.thisWeek:
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekStartDate = DateTime(weekStart.year, weekStart.month, weekStart.day);
        return entryDate.isAfter(weekStartDate) || entryDate.isAtSameMomentAs(weekStartDate);

      case TimePeriod.thisMonth:
        return entryDate.year == now.year && entryDate.month == now.month;

      case TimePeriod.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        return entryDate.year == lastMonth.year && entryDate.month == lastMonth.month;

      case TimePeriod.allTime:
        return true;
    }
  }

  static List<DiaryEntry> filterEntries(
      List<DiaryEntry> entries,
      String searchQuery,
      DiaryCategory? selectedCategory,
      TimePeriod selectedTimePeriod,
      ) {
    return entries.where((entry) {
      // Search filter
      bool matchesSearch = searchQuery.isEmpty ||
          entry.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          entry.content.toLowerCase().contains(searchQuery.toLowerCase()) ||
          entry.keywords.any((keyword) =>
              keyword.toLowerCase().contains(searchQuery.toLowerCase()));

      // Category filter
      bool matchesCategory = selectedCategory == null || entry.category == selectedCategory;

      // Time period filter
      bool matchesTimePeriod = isEntryInTimePeriod(entry, selectedTimePeriod);

      return matchesSearch && matchesCategory && matchesTimePeriod;
    }).toList();
  }

  static List<DiaryEntry> sortEntries(List<DiaryEntry> entries) {
    // Sort by pinned first, then by creation date (newest first)
    return entries..sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }
}