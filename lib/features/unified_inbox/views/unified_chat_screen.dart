// lib/features/unified_inbox/views/unified_chat_screen.dart
import 'package:flutter/material.dart';
import '../models/unified_inbox_model.dart';
import '../utils/unified_source_helper.dart';

class UnifiedChatScreen extends StatefulWidget {
  final MessageModel message;

  const UnifiedChatScreen({Key? key, required this.message}) : super(key: key);

  @override
  State<UnifiedChatScreen> createState() => _UnifiedChatScreenState();
}

class _UnifiedChatScreenState extends State<UnifiedChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late List<ChatMessage> _chatMessages;
  late MessageModel _currentMessage;

  @override
  void initState() {
    super.initState();
    _currentMessage = widget.message;
    _chatMessages = List.from(widget.message.chatMessages);

    // Add the initial message if chat messages are empty and preview is not empty
    if (_chatMessages.isEmpty && widget.message.preview.isNotEmpty) {
      _chatMessages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: widget.message.preview,
          isMe: false,
          time: widget.message.time,
        ),
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final now = DateTime.now();
    final timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _chatMessages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _messageController.text.trim(),
          isMe: true,
          time: timeString,
        ),
      );
    });

    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Simulate a response (optional - remove if not needed)
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _chatMessages.add(
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              content: 'Message received via ${MessageSourceHelper.getSourceName(_currentMessage.source)}',
              isMe: false,
              time: timeString,
              // source: _currentMessage.source,
            ),
          );
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom();
        });
      }
    });
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'U';
    final words = name.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    } else {
      return (words[0][0] + words[1][0]).toUpperCase();
    }
  }

  Widget _buildMessage(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe) ...[
            CircleAvatar(
              backgroundColor: MessageSourceHelper.getSourceColor(_currentMessage.source),
              radius: 16,
              child: Text(
                _getInitials(_currentMessage.senderName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isMe
                        ? const Color(0xFFE3F2FD)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(message.isMe ? 18 : 4),
                      bottomRight: Radius.circular(message.isMe ? 4 : 18),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (message.isMe) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 16,
              child: Text(
                'M',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showActionSheet(String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action action selected'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: MessageSourceHelper.getSourceColor(_currentMessage.source),
              radius: 20,
              child: Icon(
                MessageSourceHelper.getSourceIcon(_currentMessage.source),
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _currentMessage.senderName,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Text(
                  //   '${MessageSourceHelper.getSourceDisplayName(_currentMessage.source)} • Contact',
                  //   style: TextStyle(
                  //     color: Colors.grey[600],
                  //     fontSize: 12,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.black54),
            onPressed: () => _showActionSheet('Star'),
          ),
          IconButton(
            icon: const Icon(Icons.email, color: Colors.black54),
            onPressed: () => _showActionSheet('Email'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black54),
            onSelected: _showActionSheet,
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'archive',
                child: Text('Archive'),
              ),
              const PopupMenuItem<String>(
                value: 'mute',
                child: Text('Mute'),
              ),
              const PopupMenuItem<String>(
                value: 'block',
                child: Text('Block'),
              ),
              const PopupMenuItem<String>(
                value: 'info',
                child: Text('Contact Info'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Source indicator bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: MessageSourceHelper.getSourceColor(_currentMessage.source).withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MessageSourceHelper.getSourceIcon(_currentMessage.source),
                    size: 16,
                    color: MessageSourceHelper.getSourceColor(_currentMessage.source),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Chatting via ${MessageSourceHelper.getSourceName(_currentMessage.source)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: MessageSourceHelper.getSourceColor(_currentMessage.source),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: _chatMessages.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: MessageSourceHelper.getSourceColor(_currentMessage.source),
                    radius: 30,
                    child: Icon(
                      MessageSourceHelper.getSourceIcon(_currentMessage.source),
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start chatting with ${_currentMessage.senderName}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Messages will be sent via ${MessageSourceHelper.getSourceName(_currentMessage.source)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_chatMessages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () => _showActionSheet('Attachment'),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.mic, color: Colors.grey),
                    onPressed: () => _showActionSheet('Voice message'),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFED29),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.black87),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}