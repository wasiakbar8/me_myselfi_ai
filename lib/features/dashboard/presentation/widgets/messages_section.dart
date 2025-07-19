// lib/features/dashboard/presentation/widgets/messages_section.dart
import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';

class MessagesSection extends StatelessWidget {
  final int messageCount;
  final VoidCallback? onNotificationPressed;

  const MessagesSection({
    super.key,
    required this.messageCount,
    this.onNotificationPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.message_outlined,
                      size: AppConstants.iconSize,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: AppConstants.basePadding),
                    Text(
                      'Messages',
                      style: AppTextStyles.sectionTitle,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.basePadding),
                Text(
                  '$messageCount',
                  style: AppTextStyles.headerTitle.copyWith(fontSize: 32),
                ),
                Text(
                  'Received today',
                  style: AppTextStyles.bodyText,
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: onNotificationPressed,
                icon: const Icon(
                  Icons.notifications_outlined,
                  size: AppConstants.iconSize,
                  color: AppColors.darkGray,
                ),
              ),
              const SizedBox(height: 8),
              // Simple bar chart representation
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Icon(
                    Icons.bar_chart,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
