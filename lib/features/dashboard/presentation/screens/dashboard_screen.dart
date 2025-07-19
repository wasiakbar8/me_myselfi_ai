import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/custom_tab_bar.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/message_stats.dart';
import '../../domain/models/ai_activity.dart';
import '../widgets/hamburger.dart';
import '../widgets/unified_inbox_section.dart';
import '../widgets/ai_activity_section.dart';
import '../widgets/calendar_section.dart';
import '../widgets/voice_agent.dart';
import '../widgets/quick_tools.dart';
import '../widgets/chat_bot.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;
  bool _isListening = false;

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

  void _handleMicPress() {
    setState(() {
      _isListening = !_isListening;
    });

    if (_isListening) {
      print('Started listening...');
    } else {
      print('Stopped listening...');
    }
  }

  Widget bordered({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        onProfilePressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile pressed')),
          );
        },
      ),
      drawer: HamburgerDrawer(onItemSelected: (index) {}),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: AppConstants.basePadding),
              CustomTabBar(
                tabs: const ['Business', 'Personal'],
                currentIndex: _currentTabIndex,
                onTap: (index) {
                  setState(() {
                    _currentTabIndex = index;
                  });
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.basePadding),
                  child: Column(
                    children: [
                      HorizontalDashboardCards(
                        messageCount: _messageStats.totalReceived,
                        aiActionsCount: _activities.length,
                        eventsCount: 5,
                        onMessageTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Messages tapped')),
                          );
                        },
                        onAIActionTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI Actions tapped')),
                          );
                        },
                        onEventTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Events tapped')),
                          );
                        },
                      ),

                      bordered(
                        child: UnifiedInboxSection(
                          messageStats: _messageStats,
                          onGoToInbox: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Go to Inbox pressed')),
                            );
                          },
                          onServiceTap: (service) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$service service tapped')),
                            );
                          },
                        ),
                      ),
                      bordered(
                        child: AIActivitySection(
                          activities: _activities,
                          onViewAllActivity: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('View All Activity pressed')),
                            );
                          },
                          onActivityTap: (activity) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Activity tapped: ${activity.title}')),
                            );
                          },
                        ),
                      ),
                      bordered(
                        child: CalendarSection(
                          onAddEvent: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Add calendar event pressed')),
                            );
                          },
                        ),
                      ),
                      bordered(
                        child: VoiceAgentWidget(
                          meetings: 3,
                          tasks: 7,
                          messages: 23,
                          onMicPressed: _handleMicPress,
                          isListening: _isListening,
                        ),
                      ),
                      bordered(
                        child: AnimatedQuickToolsWidget(),
                      ),




                      const SizedBox(height: 40),


                      const Text('Developed by Devisgon❤'),
                      const SizedBox(height: 40),

                    ],
                  ),
                ),
              ),
            ],
          ),
          const ChatBotWidget(),
        ],

      )



    );
  }
}
