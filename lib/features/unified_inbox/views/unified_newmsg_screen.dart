// lib/features/unified_inbox/views/unified_newmsg_screen.dart
import 'package:flutter/material.dart';
import '../models/unified_inbox_model.dart';
import '../utils/unified_source_helper.dart';
import 'unified_chat_screen.dart';

class UnifiedNewMsgScreen extends StatefulWidget {
  const UnifiedNewMsgScreen({Key? key}) : super(key: key);

  @override
  State<UnifiedNewMsgScreen> createState() => _UnifiedNewMsgScreenState();
}

class _UnifiedNewMsgScreenState extends State<UnifiedNewMsgScreen> {
  final TextEditingController _searchController = TextEditingController();
  MessageSource? _selectedSource;
  String _searchText = '';

  final List<MessageSource> _sources = [
    MessageSource.sms,
    MessageSource.email,
    MessageSource.whatsapp,
    MessageSource.slack,
  ];

  void _selectSource(MessageSource source) {
    setState(() {
      _selectedSource = source;
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  void _navigateToChat() {
    if (_selectedSource == null || _searchText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a source and enter a contact'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create a new message model for the chat
    final newMessage = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderName: _searchText.trim(),
      preview: '',
      time: 'Now',
      source: _selectedSource!,
      // isRead: true,
      chatMessages: [], // Empty initially - will be populated in chat screen
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnifiedChatScreen(message: newMessage),
      ),
    );
  }

  Widget _buildSourceOption(MessageSource source) {
    final isSelected = _selectedSource == source;
    final sourceName = MessageSourceHelper.getSourceName(source);

    return GestureDetector(
      onTap: () => _selectSource(source),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0x80FFED29) : Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFED29) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          sourceName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceed = _selectedSource != null && _searchText.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'New message',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const Text(
              'Send via',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _sources.map((source) => _buildSourceOption(source)).toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'To',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search or enter a number',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              height: 52,
              margin: const EdgeInsets.only(bottom: 20),
              child: ElevatedButton(
                onPressed: canProceed ? _navigateToChat : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFED29),
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey[300],
                  disabledForegroundColor: Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Home indicator
            Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}