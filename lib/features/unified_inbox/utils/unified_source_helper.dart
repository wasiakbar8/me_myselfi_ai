// lib/features/unified_inbox/utils/unified_source_helper.dart
import 'package:flutter/material.dart';
import '../models/unified_inbox_model.dart';

class MessageSourceHelper {
  static Color getSourceColor(MessageSource source) {
    switch (source) {
      case MessageSource.whatsapp:
        return const Color(0xFF25D366);
      case MessageSource.email:
        return const Color(0xFF4285F4);
      case MessageSource.sms:
        return const Color(0xFF9C27B0);
      case MessageSource.slack:
        return const Color(0xFF4A154B);
    }
  }

  static IconData getSourceIcon(MessageSource source) {
    switch (source) {
      case MessageSource.whatsapp:
        return Icons.message;
      case MessageSource.email:
        return Icons.email;
      case MessageSource.sms:
        return Icons.sms;
      case MessageSource.slack:
        return Icons.messenger;
    }
  }

  static String getSourceName(MessageSource source) {
    switch (source) {
      case MessageSource.whatsapp:
        return 'WhatsApp';
      case MessageSource.email:
        return 'Email';
      case MessageSource.sms:
        return 'SMS';
      case MessageSource.slack:
        return 'Slack';
    }
  }

  static int getMessageCount(MessageSource source, List<MessageModel> messages) {
    return messages.where((msg) => msg.source == source).length;
  }
}