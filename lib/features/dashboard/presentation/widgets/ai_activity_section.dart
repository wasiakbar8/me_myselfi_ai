// lib/features/dashboard/presentation/widgets/ai_activity_section.dart
import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/ai_activity.dart';

class AIActivitySection extends StatelessWidget {
  final List<AIActivity> activities;
  final VoidCallback? onViewAllActivity;
  final Function(AIActivity)? onActivityTap;

  const AIActivitySection({
    super.key,
    required this.activities,
    this.onViewAllActivity,
    this.onActivityTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI Activity',
            style: AppTextStyles.sectionTitle,
          ),
          const SizedBox(height: AppConstants.containerPadding),
          ...activities.map((activity) => _buildActivityItem(activity)),
          const SizedBox(height: AppConstants.containerPadding),
          PrimaryButton(
            text: 'View All Activity',
            onPressed: onViewAllActivity,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(AIActivity activity) {
    IconData icon;
    Color iconColor;

    switch (activity.type) {
      case AIActivityType.smartReply:
        icon = Icons.reply;
        iconColor = AppColors.slackBlue;
        break;
      case AIActivityType.calendarEvent:
        icon = Icons.calendar_today;
        iconColor = AppColors.whatsAppGreen;
        break;
      case AIActivityType.callSummary:
        icon = Icons.call;
        iconColor = AppColors.emailPurple;
        break;
    }

    return GestureDetector(
      onTap: () => onActivityTap?.call(activity),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.basePadding),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: AppConstants.iconSize,
              ),
            ),
            const SizedBox(width: AppConstants.cardPadding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: AppTextStyles.sectionTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    activity.description,
                    style: AppTextStyles.bodyText.copyWith(fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              activity.timestamp,
              style: AppTextStyles.bodyText.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
