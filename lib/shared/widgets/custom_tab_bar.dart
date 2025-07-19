// lib/shared/widgets/custom_tab_bar.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppConstants.tabHeight,
      margin: const EdgeInsets.symmetric(horizontal: AppConstants.containerPadding),
      decoration: BoxDecoration(
        color: AppColors.tabInactiveBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          int index = entry.key;
          String tab = entry.value;
          bool isActive = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(index),
              child: Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.tabActiveBackground : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    tab,
                    style: AppTextStyles.buttonText.copyWith(
                      color: isActive ? AppColors.darkGray : AppColors.mediumGray,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
