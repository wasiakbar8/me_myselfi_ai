// lib/features/diary/views/diary_screen.dart
import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../dashboard/presentation/widgets/chat_bot.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';
import '../models/diary_model.dart';
import '../utils/diary_helper.dart';
import 'diary_newentry_screen.dart';
import 'diary_entry_view_screen.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final TextEditingController _searchController = TextEditingController();
  DiaryCategory? _selectedCategory;
  TimePeriod _selectedTimePeriod = TimePeriod.allTime;
  List<DiaryEntry> _filteredEntries = [];

  // Sample diary entries
  final List<DiaryEntry> _allEntries = [
    DiaryEntry(
      id: '1',
      title: 'Morning Reflections',
      content: 'Today I woke up feeling surprisingly energized despite only getting 6 hours of sleep. The morning meditation session really helped center my thoughts and set a positive tone for the day. I\'m grateful for these quiet moments before the world demands my attention.',
      category: DiaryCategory.personal,
      keywords: ['meditation', 'morning', 'energy'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: false,
    ),
    DiaryEntry(
      id: '2',
      title: 'Work Project Breakthrough',
      content: 'Finally had that breakthrough on the Henderson project! After weeks of hitting roadblocks, the solution came to me while I was making coffee. Sometimes the best ideas come when you\'re not actively trying to solve the problem.',
      category: DiaryCategory.work,
      keywords: ['breakthrough', 'project', 'coffee'],
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      isPinned: true,
    ),
    DiaryEntry(
      id: '3',
      title: 'Grateful for Small Things',
      content: 'Today I\'m particularly grateful for the warm cup of tea I had this morning, the smile from a stranger on the street, and the fact that all traffic lights were green on my way home. It\'s amazing how these little things can brighten an entire day.',
      category: DiaryCategory.gratitude,
      keywords: ['tea', 'smile', 'traffic'],
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isPinned: false,
    ),
    DiaryEntry(
      id: '4',
      title: 'App Idea: Voice Notes Organizer',
      content: 'What if there was an app that could automatically transcribe and categorize voice notes based on context and keywords? It could use AI to understand the sentiment and topic, making it easier to find specific thoughts later.',
      category: DiaryCategory.ideas,
      keywords: ['app', 'voice notes', 'AI', 'transcription'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
      isPinned: false,
    ),
    DiaryEntry(
      id: '5',
      title: 'Team Meeting Success',
      content: 'The quarterly review meeting went exceptionally well today. The team was engaged, we hit all our targets, and everyone seemed motivated for the next quarter. Leadership noticed our department\'s improved communication.',
      category: DiaryCategory.work,
      keywords: ['meeting', 'quarterly', 'team', 'success'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
      isPinned: false,
    ),
    DiaryEntry(
      id: '6',
      title: 'Weekend Plans',
      content: 'Planning a weekend getaway to the mountains. Need to disconnect from technology and reconnect with nature. Will pack hiking boots, camera, and journal for capturing thoughts along the trails.',
      category: DiaryCategory.personal,
      keywords: ['weekend', 'mountains', 'hiking', 'nature'],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
      isPinned: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _filterEntries();
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = DiaryHelper.filterEntries(
        _allEntries,
        _searchController.text,
        _selectedCategory,
        _selectedTimePeriod,
      );
      _filteredEntries = DiaryHelper.sortEntries(_filteredEntries);
    });
  }

  void _selectCategory(DiaryCategory? category) {
    setState(() {
      _selectedCategory = category;
    });
    _filterEntries();
  }

  void _selectTimePeriod(TimePeriod period) {
    setState(() {
      _selectedTimePeriod = period;
    });
    _filterEntries();
  }

  void _addNewEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DiaryNewEntryScreen(),
      ),
    );

    if (result != null && result is DiaryEntry) {
      setState(() {
        _allEntries.insert(0, result);
      });
      _filterEntries();
    }
  }

  void _editEntry(DiaryEntry entry) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryNewEntryScreen(entryToEdit: entry),
      ),
    );

    if (result != null && result is DiaryEntry) {
      setState(() {
        final index = _allEntries.indexWhere((e) => e.id == entry.id);
        if (index != -1) {
          _allEntries[index] = result;
        }
      });
      _filterEntries();
    }
  }

  void _togglePin(DiaryEntry entry) {
    setState(() {
      final index = _allEntries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _allEntries[index] = entry.copyWith(isPinned: !entry.isPinned);
      }
    });
    _filterEntries();
  }

  void _deleteEntry(DiaryEntry entry) {
    setState(() {
      _allEntries.removeWhere((e) => e.id == entry.id);
    });
    _filterEntries();
  }

  void _showEntryOptions(DiaryEntry entry) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: const Text('Open'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryEntryViewScreen(
                      entry: entry,
                      onEdit: () => _editEntry(entry),
                      onPin: () => _togglePin(entry),
                      onDelete: () => _deleteEntry(entry),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(entry.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              title: Text(entry.isPinned ? 'Unpin Entry' : 'Pin Entry'),
              onTap: () {
                Navigator.pop(context);
                _togglePin(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _editEntry(entry);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(entry);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(DiaryEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Are you sure you want to delete this entry? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEntry(entry);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(DiaryCategory category) {
    final isSelected = _selectedCategory == category;
    final entryCount = DiaryHelper.getEntryCount(category, _allEntries);

    return GestureDetector(
      key: ValueKey('category_filter_${category.name}'),
      onTap: () => _selectCategory(isSelected ? null : category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x80FFED29) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFED29) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              DiaryHelper.getCategoryIcon(category),
              size: 16,
              color: isSelected ? Colors.black87 : DiaryHelper.getCategoryColor(category),
            ),
            const SizedBox(width: 6),
            Text(
              DiaryHelper.getCategoryName(category),
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black26 : DiaryHelper.getCategoryColor(category),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                entryCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildEntryTile(DiaryEntry entry) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiaryEntryViewScreen(
              entry: entry,
              onEdit: () => _editEntry(entry),
              onPin: () => _togglePin(entry),
              onDelete: () => _deleteEntry(entry),
            ),
          ),
        );
      },
      child: Container(
        key: ValueKey('entry_tile_${entry.id}'),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: DiaryHelper.getCategoryColor(entry.category),
                  radius: 18,
                  child: Icon(
                    DiaryHelper.getCategoryIcon(entry.category),
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _showEntryOptions(entry),
                  child: const Icon(
                    Icons.more_vert,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              entry.preview,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (entry.isPinned)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD700).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.push_pin,
                      size: 12,
                      color: Colors.black54,
                    ),
                  ),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 2,
                    children: entry.keywords.take(3).map((keyword) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: DiaryHelper.getCategoryColor(entry.category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          keyword,
                          style: TextStyle(
                            fontSize: 10,
                            color: DiaryHelper.getCategoryColor(entry.category),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${entry.formattedDate} • ${entry.timeFormatted}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Diary',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },
      ),
      drawer: HamburgerDrawer(),
      body: Stack(
        children: [ Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Center(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => _filterEntries(),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Search Entries...',
                            hintStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                            prefixIconConstraints: BoxConstraints(minWidth: 24, minHeight: 24),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  // New Entry Button
                  GestureDetector(
                    onTap: _addNewEntry,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add, color: Colors.black87, size: 20),
                          SizedBox(width: 6),
                          Text(
                            'New Entry',
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Categories
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: DiaryCategory.values
                          .map((category) => _buildCategoryFilter(category))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Time Period and Entries Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Time Period',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12,),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButton<TimePeriod>(
                      value: _selectedTimePeriod,
                      onChanged: (TimePeriod? period) {
                        if (period != null) _selectTimePeriod(period);
                      },
                      underline: const SizedBox(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      items: TimePeriod.values.map((period) {
                        return DropdownMenuItem<TimePeriod>(
                          value: period,
                          child: Text(DiaryHelper.getTimePeriodName(period)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Entries List
            Expanded(
              child: _filteredEntries.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.book,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No entries found',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                key: const ValueKey('entries_list'),
                itemCount: _filteredEntries.length,
                itemBuilder: (context, index) {
                  return _buildEntryTile(_filteredEntries[index]);
                },
              ),
            ),
          ],

        ),
          const ChatBotWidget(),
        ],
      ),

    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}