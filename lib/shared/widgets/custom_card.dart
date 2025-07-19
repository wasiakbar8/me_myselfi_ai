import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(AppConstants.basePadding),
      child: Card(
        color: AppColors.cardBackground,
        elevation: 3,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppConstants.cardPadding),
          child: child,
        ),
      ),
    );
  }
}

// New widget for horizontal scrollable cards
class HorizontalDashboardCards extends StatefulWidget {
  final int messageCount;
  final int aiActionsCount;
  final int eventsCount;
  final VoidCallback? onMessageTap;
  final VoidCallback? onAIActionTap;
  final VoidCallback? onEventTap;

  const HorizontalDashboardCards({
    super.key,
    required this.messageCount,
    required this.aiActionsCount,
    required this.eventsCount,
    this.onMessageTap,
    this.onAIActionTap,
    this.onEventTap,
  });

  @override
  State<HorizontalDashboardCards> createState() => _HorizontalDashboardCardsState();
}

class _HorizontalDashboardCardsState extends State<HorizontalDashboardCards>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  List<DashboardCardData> get cardsData => [
    DashboardCardData(
      title: 'Messages',
      value: widget.messageCount.toString(),
      subtitle: 'Received today',
      icon: Icons.message_outlined,
      color: const Color(0xFFFFC107), // Amber color
      percentage: '+15%',
      onTap: widget.onMessageTap,
    ),
    DashboardCardData(
      title: 'AI Actions',
      value: widget.aiActionsCount.toString(),
      subtitle: 'Performed today',
      icon: Icons.discord,
      color: const Color(0xFF2196F3), // Blue color
      percentage: '+8%',
      onTap: widget.onAIActionTap,
    ),
    DashboardCardData(
      title: 'Events',
      value: widget.eventsCount.toString(),
      subtitle: 'Scheduled today',
      icon: Icons.event,
      color: const Color(0xFF4CAF50), // Green color
      percentage: '+2%',
      onTap: widget.onEventTap,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Horizontal scrollable cards
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
              _animationController.forward().then((_) {
                _animationController.reverse();
              });
            },
            itemCount: cardsData.length,
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                    value = (value * 0.038).clamp(-1, 1);
                  }

                  return Transform.rotate(
                    angle: value,
                    child: Transform.scale(
                      scale: currentIndex == index ? 1.0 : 0.9,
                      child: AnimatedDashboardCard(
                        data: cardsData[index],
                        isActive: currentIndex == index,
                        animationController: _animationController,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Page indicators
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              cardsData.length,
                  (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 8,
                width: currentIndex == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? cardsData[currentIndex].color
                      : Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedDashboardCard extends StatelessWidget {
  final DashboardCardData data;
  final bool isActive;
  final AnimationController animationController;

  const AnimatedDashboardCard({
    super.key,
    required this.data,
    required this.isActive,
    required this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        final scaleAnimation = Tween<double>(
          begin: 1.0,
          end: 1.05,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ));

        return Transform.scale(
          scale: isActive ? scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: data.onTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Card(
                color: AppColors.cardBackground,
                elevation: isActive ? 20 : 2,
                shadowColor: const Color.fromRGBO(0, 0, 0, 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Left side - Icon and content
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                // Icon with background
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: data.color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    data.icon,
                                    size: 24,
                                    color: data.color,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Title in front of icon
                                Text(
                                  data.title,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Value with animation
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 800),
                              tween: Tween<double>(
                                begin: 0,
                                end: double.parse(data.value),
                              ),
                              builder: (context, value, child) {
                                return Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            // Subtitle
                            Text(
                              data.subtitle,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Right side - Chart
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Percentage indicator above center of graph
                            SizedBox(
                              height: 20, // Half of chart height (100 / 2) to position above center
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                     Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: data.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        data.percentage,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: data.color,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                  ),
                                ],
                              ),
                            ),
                            // Chart
                            Container(
                              height: 100,
                              padding: const EdgeInsets.only(left: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(8, (index) {
                                  final heights = [0.3, 0.7, 0.4, 0.9, 0.6, 0.8, 0.5, 0.7];
                                  return AnimatedContainer(
                                    duration: Duration(milliseconds: 300 + (index * 100)),
                                    height: heights[index] * 60,
                                    width: 3,
                                    decoration: BoxDecoration(
                                      color: data.color.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DashboardCardData {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String percentage;
  final VoidCallback? onTap;

  DashboardCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.percentage,
    this.onTap,
  });
}