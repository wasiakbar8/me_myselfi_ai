import 'package:flutter/material.dart';
import 'package:me_myself_ai/features/diary/views/diary_screen.dart';
import 'package:me_myself_ai/pages/api_integrations.dart';

import '../../../../pages/upgrade_premium.dart';
import '../../../budget/views/budget_tracking_screen.dart';
import '../../../calendar/views/calendar_screen.dart';
import '../../../vault/views/vault_password_screen.dart';

class AnimatedQuickToolsWidget extends StatefulWidget {
  const AnimatedQuickToolsWidget({super.key});

  @override
  State<AnimatedQuickToolsWidget> createState() =>
      _AnimatedQuickToolsWidgetState();
}

class _AnimatedQuickToolsWidgetState extends State<AnimatedQuickToolsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  final GlobalKey _widgetKey = GlobalKey();

  late List<List<QuickToolItem>> _tools;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeTools();
    _animationController.forward();
  }

  void _initializeTools() {
    _tools = [
      [
        QuickToolItem(
          icon: Icons.security,
          title: 'Vault',
          subtitle: 'Secure Storage',
          color: const Color(0xFF2196F3),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VaultPasswordScreen(),
              ),
            );
          },
        ),
        QuickToolItem(
          icon: Icons.attach_money,
          title: 'Budget',
          subtitle: 'Expense Track',
          color: const Color(0xFF4CAF50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BudgetTrackingScreen()),
            );
          },
        ),
        QuickToolItem(
          icon: Icons.book,
          title: 'Diary',
          subtitle: 'Daily Journal',
          color: const Color(0xFF9C27B0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CalendarScreen()),
            );
          },
        ),
      ],
      [
        QuickToolItem(
          icon: Icons.share,
          title: 'Integrate',
          subtitle: 'Apps',
          color: const Color(0xFF00BCD4),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ApiIntegrationsPage(),
              ),
            );
          },
        ),
        QuickToolItem(
          icon: Icons.star,
          title: 'Upgrade',
          subtitle: 'Premium',
          color: const Color(0xFFFFD60A),
          backgroundColor: const Color(0xFFFFED29).withOpacity(0.3),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UpgradePremiumPage(),
              ),
            );
          },
        ),
      ],
    ];
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _widgetKey,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildToolsGrid(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Quick Tools',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        GestureDetector(
          onTap: () => print('More options tapped'),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.more_horiz,
              color: Color(0xFF535860),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolsGrid() {
    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _tools.expand((row) => row).map((tool) {
        return _buildToolCard(tool);
      }).toList(),
    );
  }

  Widget _buildToolCard(QuickToolItem tool) {
    return GestureDetector(
      onTap: () => _animateCardTap(tool),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: tool.backgroundColor ?? const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tool.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(tool.icon, color: tool.color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                tool.title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF333333),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                tool.subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF535860)),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _animateCardTap(QuickToolItem tool) {
    final controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    final animation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.forward().then((_) {
      controller.reverse().then((_) {
        controller.dispose();
        tool.onTap();
      });
    });
  }
}

class QuickToolItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color? backgroundColor;
  final VoidCallback onTap;

  QuickToolItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.backgroundColor,
    required this.onTap,
  });
}
