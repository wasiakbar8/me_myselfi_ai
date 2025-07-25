// lib/features/ai_assistant/views/ai_assistant_screen.dart
import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../shared/widgets/custom_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../dashboard/domain/models/ai_activity.dart';
import '../../dashboard/domain/models/message_stats.dart';
import '../../dashboard/presentation/widgets/hamburger.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isListening = false;

  // Sample data
  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'received',
      'content':
          'Good morning! I\'ve processed your emails and found 5 urgent items requiring attention.',
      'timestamp': '9:15 AM',
      'avatar': 'assets/images/ai_avatar.png',
    },
    {
      'type': 'received',
      'content':
          'Your client presentation is scheduled in 2 hours. Would you like me to prepare the final slides?',
      'timestamp': '9:30 AM',
      'avatar': 'assets/images/ai_avatar.png',
    },
    {
      'type': 'sent',
      'content': 'Yes, please prepare the slides and send me a summary.',
      'timestamp': '9:32 AM',
    },
    {
      'type': 'received',
      'content':
          'Done! I\'ve updated your presentation with the latest data and sent the summary to your email.',
      'timestamp': '9:35 AM',
      'avatar': 'assets/images/ai_avatar.png',
    },
  ];

  final List<Map<String, dynamic>> _statsData = [
    {
      'title': 'Messages',
      'count': '24',
      'subtitle': 'Received today',
      'percentage': '+12%',
      'color': AppColors.slackBlue,
      'icon': Icons.message,
    },
    {
      'title': 'AI Actions',
      'count': '18',
      'subtitle': 'Performed today',
      'percentage': '+8%',
      'color': AppColors.whatsAppGreen,
      'icon': Icons.smart_toy,
    },
    {
      'title': 'Events',
      'count': '5',
      'subtitle': 'Scheduled today',
      'percentage': '+15%',
      'color': AppColors.emailPurple,
      'icon': Icons.event,
    },
  ];

  final List<String> _insights = [
    'Your most productive hours today were between 9 AM and 11 AM',
    'Client meeting preparation is still pending for tomorrow',
    'Email response rate improved by 15% this week',
  ];

  final List<String> _voiceCommands = [
    'Summarize my emails',
    'Schedule a meeting with Alex',
    'What\'s on my calendar today?',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: CustomAppBar(
        title: 'AI Assistant',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },
      ),
      drawer: HamburgerDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppConstants.basePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCards(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildAssistantStatus(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildMessagesSection(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildNextEventCard(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildInsightsSection(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildVoiceCommandsSection(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildUsageStatistics(),
            const SizedBox(height: AppConstants.containerPadding),
            _buildAssistantPerformance(),
            const SizedBox(height: 100), // Space for bottom input
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomInput(),
    );
  }

  final MessageStats _messageStats = MessageStats(
    totalReceived: 24,
    whatsAppCount: 8,
    emailCount: 12,
    smsCount: 3,
    slackCount: 5,
  );

  final List<AIActivity> _activities = [
    AIActivity(
      id: '1',
      title: 'Smart Reply Sent',
      description: 'Sent response to client inquiry about project timeline',
      timestamp: '10 min ago',
      type: AIActivityType.smartReply,
    ),
    AIActivity(
      id: '2',
      title: 'Calendar Event Extracted',
      description: 'Added "Quarterly Review" to your calendar for next Monday',
      timestamp: '25 min ago',
      type: AIActivityType.calendarEvent,
    ),
    AIActivity(
      id: '3',
      title: 'Call Summary Created',
      description: 'Generated summary of your call with Marketing team',
      timestamp: '1 hour ago',
      type: AIActivityType.callSummary,
    ),
  ];
  Widget _buildStatsCards() {
    return HorizontalDashboardCards(
      messageCount: _messageStats.totalReceived,
      aiActionsCount: _activities.length,
      eventsCount: 5,
      onMessageTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Messages tapped')));
      },
      onAIActionTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('AI Actions tapped')));
      },
      onEventTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Events tapped')));
      },
    );
  }

  Widget _buildAssistantStatus() {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.whatsAppGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.smart_toy, color: AppColors.whatsAppGreen),
          ),
          const SizedBox(width: AppConstants.cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Assistant Status',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.whatsAppGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Active - Monitoring your activity',
                      style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesSection() {
    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.whatsAppGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.smart_toy, color: AppColors.whatsAppGreen),
          ),
          const SizedBox(width: AppConstants.cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Activity Summary',
                  style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.whatsAppGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Active - Monitoring your activity',
                      style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    final bool isReceived = message['type'] == 'received';

    return Row(
      mainAxisAlignment: isReceived
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isReceived) ...[
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.smart_toy, size: 18, color: Colors.black),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isReceived ? Colors.white : AppColors.primary,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message['content'],
                  style: AppTextStyles.bodyText.copyWith(
                    color: isReceived ? Colors.black : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message['timestamp'],
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isReceived) ...[
          const SizedBox(width: 8),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.slackBlue,
            child: const Icon(Icons.person, size: 18, color: Colors.white),
          ),
        ],
      ],
    );
  }

  Widget _buildNextEventCard() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Next Scheduled Event',
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.basePadding),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: AppColors.slackBlue,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Client Presentation',
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '3:00 PM - 4:00 PM',
                        style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                      ),
                      Text(
                        'Acme Corp.',
                        style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  'In 2 hours',
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 12,
                    color: AppColors.slackBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text('AI Insights', style: AppTextStyles.sectionTitle),
            ],
          ),
          const SizedBox(height: AppConstants.basePadding),
          ..._insights.map(
            (insight) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.whatsAppGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      insight,
                      style: AppTextStyles.bodyText.copyWith(fontSize: 13),
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

  Widget _buildVoiceCommandsSection() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.keyboard_voice,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Voice Commands', style: AppTextStyles.sectionTitle),
            ],
          ),
          const SizedBox(height: AppConstants.basePadding),
          ..._voiceCommands.map(
            (command) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => _executeVoiceCommand(command),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '"$command"',
                          style: AppTextStyles.bodyText.copyWith(fontSize: 13),
                        ),
                      ),
                      const Icon(
                        Icons.play_arrow,
                        color: AppColors.slackBlue,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageStatistics() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AI Usage Statistics', style: AppTextStyles.sectionTitle),
              Row(
                children: [
                  _buildTimeFilter('Today', true),
                  _buildTimeFilter('Week', false),
                  _buildTimeFilter('Month', false),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppConstants.basePadding),
          Text(
            'AI Credits Used    68% (680/1000)',
            style: AppTextStyles.bodyText.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: 0.68,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: AppConstants.basePadding),
          _buildUsageItem('Chat Completions', '320 credits', Icons.chat),
          _buildUsageItem('Text Generation', '210 credits', Icons.text_fields),
          _buildUsageItem('Voice Processing', '150 credits', Icons.mic),
        ],
      ),
    );
  }

  Widget _buildUsageItem(String title, String credits, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.slackBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyText.copyWith(fontSize: 13),
            ),
          ),
          Text(
            credits,
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 12,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeFilter(String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isActive ? AppColors.primary : Colors.transparent,
          foregroundColor: isActive ? Colors.black : Colors.grey[600],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12)),
      ),
    );
  }

  Widget _buildAssistantPerformance() {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Assistant Performance', style: AppTextStyles.sectionTitle),
          const SizedBox(height: AppConstants.basePadding),
          _buildPerformanceItem(
            'Response Accuracy',
            0.92,
            AppColors.whatsAppGreen,
          ),
          _buildPerformanceItem('Avg. Response Time', 0.5, AppColors.slackBlue),
          _buildPerformanceItem(
            'User Satisfaction',
            0.88,
            AppColors.emailPurple,
          ),
          const SizedBox(height: AppConstants.basePadding),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                const Icon(Icons.school, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Training Status: ',
                  style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                ),
                Text(
                  'Personalization Active',
                  style: AppTextStyles.bodyText.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceItem(String label, double value, Color color) {
    String displayValue;
    if (label.contains('Time')) {
      displayValue = '${(value * 2.5).toStringAsFixed(1)}s';
    } else {
      displayValue = '${(value * 100).toInt()}%';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: AppTextStyles.bodyText.copyWith(fontSize: 13)),
              Text(
                displayValue,
                style: AppTextStyles.bodyText.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ask me anything',
            style: AppTextStyles.bodyText.copyWith(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your question or command...',
                    hintStyle: AppTextStyles.bodyText.copyWith(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    suffixIcon: IconButton(
                      onPressed: _sendMessage,
                      icon: const Icon(Icons.send, color: AppColors.primary),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _toggleListening,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: _isListening ? Colors.black : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'type': 'sent',
          'content': _messageController.text.trim(),
          'timestamp': _getCurrentTime(),
        });
      });
      _messageController.clear();
      _scrollToBottom();

      // Simulate AI response
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add({
            'type': 'received',
            'content':
                'I\'ve processed your request. Let me help you with that.',
            'timestamp': _getCurrentTime(),
            'avatar': 'assets/images/ai_avatar.png',
          });
        });
        _scrollToBottom();
      });
    }
  }

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      // Start voice recognition
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isListening = false;
        });
      });
    }
  }

  void _executeVoiceCommand(String command) {
    setState(() {
      _messages.add({
        'type': 'sent',
        'content': command,
        'timestamp': _getCurrentTime(),
      });
    });

    _scrollToBottom();

    // Simulate AI response based on command
    Future.delayed(const Duration(seconds: 1), () {
      String response;
      switch (command) {
        case 'Summarize my emails':
          response =
              'I found 12 new emails. 3 are urgent: client proposal review, budget approval, and team meeting confirmation.';
          break;
        case 'Schedule a meeting with Alex':
          response =
              'I\'ve checked Alex\'s calendar. Available slots: Tomorrow 2 PM or Thursday 10 AM. Which would you prefer?';
          break;
        case 'What\'s on my calendar today?':
          response =
              'You have 3 events today: Team standup at 10 AM, Client presentation at 3 PM, and Performance review at 5 PM.';
          break;
        default:
          response =
              'I\'ve processed your voice command. How else can I assist you?';
      }

      setState(() {
        _messages.add({
          'type': 'received',
          'content': response,
          'timestamp': _getCurrentTime(),
          'avatar': 'assets/images/ai_avatar.png',
        });
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class MiniChartPainter extends CustomPainter {
  final Color color;

  MiniChartPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.3);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
