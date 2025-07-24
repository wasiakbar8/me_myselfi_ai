import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../features/dashboard/presentation/widgets/hamburger.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onProfilePressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) => Hamburger(
          onItemSelected: (index) {
            // Placeholder for navigation, can be expanded later
          },
        ),
      ),
      title: Text(title, style: AppTextStyles.headerTitle),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, size: AppConstants.iconSize),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
      backgroundColor: AppColors.background,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.headerHeight);
}