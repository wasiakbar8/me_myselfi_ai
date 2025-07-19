// lib/features/dashboard/presentation/widgets/unified_inbox_section.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/badge_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/models/message_stats.dart';

class UnifiedInboxSection extends StatelessWidget {
  final MessageStats messageStats;
  final VoidCallback? onGoToInbox;
  final Function(String)? onServiceTap;

  const UnifiedInboxSection({
    super.key,
    required this.messageStats,
    this.onGoToInbox,
    this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Unified Inbox',
                style: AppTextStyles.sectionTitle,
              ),
              Text(
                'Today',
                style: AppTextStyles.bodyText,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.containerPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BadgeWidget(
                label: 'WhatsApp',
                count: messageStats.whatsAppCount,
                backgroundColor: AppColors.whatsAppGreen,
                icon:  FontAwesomeIcons.whatsapp,
                onTap: () => onServiceTap?.call('whatsapp'),
              ),
              BadgeWidget(
                label: 'Email',
                count: messageStats.emailCount,
                backgroundColor: AppColors.emailPurple,
                icon: Icons.email,
                onTap: () => onServiceTap?.call('email'),
              ),
              BadgeWidget(
                label: 'SMS',
                count: messageStats.smsCount,
                backgroundColor: AppColors.smsTeal,
                icon: Icons.sms,
                onTap: () => onServiceTap?.call('sms'),
              ),
              BadgeWidget(
                label: 'Slack',
                count: messageStats.slackCount,
                backgroundColor: AppColors.slackBlue,
                icon: Icons.chat_bubble,
                onTap: () => onServiceTap?.call('slack'),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.containerPadding),
          PrimaryButton(
            text: 'Go to Inbox',
            onPressed: onGoToInbox,
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
