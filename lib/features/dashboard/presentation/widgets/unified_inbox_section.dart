import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/widgets/custom_card.dart';
import '../../../../shared/widgets/badge_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../unified_inbox/models/unified_inbox_model.dart';
import '../../domain/models/message_stats.dart';
// import '../utils/unified_source_helper.dart'; // Import to use MessageSource enum

class UnifiedInboxSection extends StatelessWidget {
  final MessageStats messageStats;
  final VoidCallback? onGoToInbox;

  const UnifiedInboxSection({
    super.key,
    required this.messageStats,
    this.onGoToInbox,
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
                icon: FontAwesomeIcons.whatsapp,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/unified_inbox_screen',
                    arguments: MessageSource.whatsapp, // Pass WhatsApp filter
                  );
                },
              ),
              BadgeWidget(
                label: 'Email',
                count: messageStats.emailCount,
                backgroundColor: AppColors.emailPurple,
                icon: Icons.email,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/unified_inbox_screen',
                    arguments: MessageSource.email, // Pass Email filter
                  );
                },
              ),
              BadgeWidget(
                label: 'SMS',
                count: messageStats.smsCount,
                backgroundColor: AppColors.smsTeal,
                icon: FontAwesomeIcons.sms,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/unified_inbox_screen',
                    arguments: MessageSource.sms, // Pass SMS filter
                  );
                },
              ),
              BadgeWidget(
                label: 'Slack',
                count: messageStats.slackCount,
                backgroundColor: AppColors.slackBlue,
                icon: Icons.chat_bubble,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/unified_inbox_screen',
                    arguments: MessageSource.slack, // Pass Slack filter
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: AppConstants.containerPadding),
          PrimaryButton(
            text: 'Go to Inbox',
            onPressed: () {
              Navigator.pushNamed(context, '/unified_inbox_screen');
            },
            icon: Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}