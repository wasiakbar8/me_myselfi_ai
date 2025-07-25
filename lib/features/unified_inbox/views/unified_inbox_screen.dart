import 'package:flutter/material.dart';
import 'package:me_myself_ai/features/unified_inbox/views/unified_newmsg_screen.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../dashboard/presentation/widgets/chat_bot.dart' as chat_bot;
import '../../dashboard/presentation/widgets/hamburger.dart';
import '../models/unified_inbox_model.dart';
import '../utils/unified_source_helper.dart';
import 'unified_chat_screen.dart';

class UnifiedInboxScreen extends StatefulWidget {
  final MessageSource? initialSource; // Add parameter to receive initial filter

  const UnifiedInboxScreen({Key? key, this.initialSource}) : super(key: key);

  @override
  State<UnifiedInboxScreen> createState() => _UnifiedInboxScreenState();
}

class _UnifiedInboxScreenState extends State<UnifiedInboxScreen> {
  final TextEditingController _searchController = TextEditingController();
  MessageSource? _selectedSource;
  List<MessageModel> _filteredMessages = [];

  // Sample messages data
  final List<MessageModel> _allMessages = [
    MessageModel(
      id: '1',
      senderName: 'Sarah Johnson',
      preview: 'Hi there! I wanted to check in about our project timeline. Are we still on track for the delivery next week?',
      time: '10:32 AM',
      source: MessageSource.whatsapp,
      isUnread: true,
      chatMessages: [
        ChatMessage(
          id: '1',
          content: 'Hi there! I wanted to check in about our project timeline. Are we still on track for the delivery next week?',
          isMe: false,
          time: 'Yesterday, 4:32 PM',
        ),
        ChatMessage(
          id: '2',
          content: 'Yes, everything is going according to plan. I\'ve completed the design phase and the development team is making good progress.',
          isMe: true,
          time: 'Yesterday, 5:15 PM',
        ),
        ChatMessage(
          id: '3',
          content: 'That\'s great to hear! Could we schedule a quick meeting to go over the details before presenting to the client?',
          isMe: false,
          time: 'Yesterday, 5:30 PM',
        ),
        ChatMessage(
          id: '4',
          content: 'Absolutely. How does tomorrow at 2pm sound? I\'ll have all the materials ready by then.',
          isMe: true,
          time: 'Yesterday, 5:45 PM',
        ),
        ChatMessage(
          id: '5',
          content: 'Perfect! I\'ll send a calendar invite. Also, do you have the latest version of the presentation?',
          isMe: false,
          time: 'Yesterday, 6:02 PM',
        ),
        ChatMessage(
          id: '6',
          content: 'I\'ll send it over right after this conversation. Just putting the finishing touches on it.',
          isMe: true,
          time: 'Yesterday, 6:10 PM',
        ),
      ],
    ),
    MessageModel(
      id: '2',
      senderName: 'Acme Corp',
      preview: 'Q 2 Performance Report - Please review the attached documents for the quarterly analysis.',
      time: '9:15 AM',
      source: MessageSource.email,
      isUnread: true,
      chatMessages: [],
    ),
    MessageModel(
      id: '3',
      senderName: 'Project Team',
      preview: 'A lax: I\'ve pushed the latest updates to the repository. Please review when you get a chance.',
      time: '8:47 AM',
      source: MessageSource.slack,
      isUnread: true,
      chatMessages: [],
    ),
    MessageModel(
      id: '4',
      senderName: 'Michael Chen',
      preview: 'Your package has been delivered. The access code is 1234.',
      time: 'Yesterday',
      source: MessageSource.sms,
      isUnread: true,
      chatMessages: [],
    ),
    MessageModel(
      id: '5',
      senderName: 'TechConf 2024',
      preview: 'Your speaker proposal for "AI in Productivity Tools" has been accepted!',
      time: 'Yesterday',
      source: MessageSource.email,
      isUnread: true,
      chatMessages: [],
    ),
    MessageModel(
      id: '6',
      senderName: 'Lisa Wong',
      preview: 'Can you send me the final version of the presentation slides?',
      time: 'Yesterday',
      source: MessageSource.whatsapp,
      isUnread: true,
      chatMessages: [],
    ),
    MessageModel(
      id: '7',
      senderName: 'Bank Alert',
      preview: 'Your account ending in 4821 has been charged 125.99 for your monthly subscription.',
      time: '2 days ago',
      source: MessageSource.sms,
      isUnread: true,
      chatMessages: [],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSource = widget.initialSource; // Set initial source from arguments
    _filteredMessages = _allMessages;
    _filterMessages(); // Apply initial filter
  }

  void _filterMessages() {
    setState(() {
      _filteredMessages = _allMessages.where((message) {
        bool matchesSearch = _searchController.text.isEmpty ||
            message.senderName.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            message.preview.toLowerCase().contains(_searchController.text.toLowerCase());

        bool matchesSource = _selectedSource == null || message.source == _selectedSource;

        return matchesSearch && matchesSource;
      }).toList();
    });
  }

  void _selectSource(MessageSource? source) {
    setState(() {
      _selectedSource = source;
    });
    _filterMessages();
  }

  Widget _buildSourceFilter(MessageSource source) {
    final isSelected = _selectedSource == source;
    final messageCount = MessageSourceHelper.getMessageCount(source, _allMessages);

    return GestureDetector(
      key: ValueKey('source_filter_${source.name}'),
      onTap: () => _selectSource(isSelected ? null : source),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MessageSourceHelper.getSourceColor(source) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MessageSourceHelper.getSourceColor(source) : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              MessageSourceHelper.getSourceIcon(source),
              size: 16,
              color: isSelected ? Colors.white : MessageSourceHelper.getSourceColor(source),
            ),
            const SizedBox(width: 6),
            Text(
              MessageSourceHelper.getSourceName(source),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withOpacity(0.3) : MessageSourceHelper.getSourceColor(source),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                messageCount.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white,
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

  Widget _buildMessageTile(MessageModel message) {
    return Container(
      key: ValueKey('message_tile_${message.id}'),
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: MessageSourceHelper.getSourceColor(message.source),
          radius: 24,
          child: Icon(
            MessageSourceHelper.getSourceIcon(message.source),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          message.senderName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            message.preview,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message.time,
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            if (message.isUnread)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD700),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UnifiedChatScreen(message: message),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Unified Inbox',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },
      ),
      drawer: HamburgerDrawer(),
      body: Stack(
        children: [
          Column(
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
                            onChanged: (_) => _filterMessages(),
                            decoration: const InputDecoration(
                              isDense: true,
                              hintText: 'Search messages...',
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
                    // New Msg Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UnifiedNewMsgScreen()),
                        );
                      },
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
                              'New Msg',
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
              // Message Sources
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Message Sources',
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
                        children: MessageSource.values
                            .map((source) => _buildSourceFilter(source))
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Messages Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Icon(
                      Icons.filter_list,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Messages List
              Expanded(
                child: _filteredMessages.isEmpty
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No messages found',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                )
                    : ListView.builder(
                  key: const ValueKey('messages_list'),
                  itemCount: _filteredMessages.length,
                  itemBuilder: (context, index) {
                    return _buildMessageTile(_filteredMessages[index]);
                  },
                ),
              ),
            ],
          ),
          const chat_bot.ChatBotWidget(),
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