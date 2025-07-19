// lib/features/dashboard/domain/models/message_stats.dart
class MessageStats {
  final int totalReceived;
  final int whatsAppCount;
  final int emailCount;
  final int smsCount;
  final int slackCount;

  MessageStats({
    required this.totalReceived,
    required this.whatsAppCount,
    required this.emailCount,
    required this.smsCount,
    required this.slackCount,
  });
}
