// lib/features/dashboard/domain/models/ai_activity.dart
class AIActivity {
final String id;
final String title;
final String description;
final String timestamp;
final AIActivityType type;

AIActivity({
required this.id,
required this.title,
required this.description,
required this.timestamp,
required this.type,
});
}

enum AIActivityType {
smartReply,
calendarEvent,
callSummary,
}