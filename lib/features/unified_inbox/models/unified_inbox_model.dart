// lib/features/unified_inbox/models/unified_inbox_model.dart

enum MessageSource {
  whatsapp,
  email,
  sms,
  slack,


}

class MessageModel {
  final String id;
  final String senderName;
  final String preview;
  final String time;
  final MessageSource source;
  final bool isUnread;
  final String? avatar;
  final List<ChatMessage> chatMessages;

  MessageModel({
    required this.id,
    required this.senderName,
    required this.preview,
    required this.time,
    required this.source,
    this.isUnread = false,
    this.avatar,
    this.chatMessages = const [],
  });

  MessageModel copyWith({
    String? id,
    String? senderName,
    String? preview,
    String? time,
    MessageSource? source,
    bool? isUnread,
    String? avatar,
    List<ChatMessage>? chatMessages,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      preview: preview ?? this.preview,
      time: time ?? this.time,
      source: source ?? this.source,
      isUnread: isUnread ?? this.isUnread,
      avatar: avatar ?? this.avatar,
      chatMessages: chatMessages ?? this.chatMessages,
    );
  }
}

class ChatMessage {
  final String id;
  final String content;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isMe,
    required this.time,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isMe,
    String? time,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isMe: isMe ?? this.isMe,
      time: time ?? this.time,
    );
  }
}