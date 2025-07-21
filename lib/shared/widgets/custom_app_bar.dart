// // lib/shared/widgets/custom_app_bar.dart
// import 'package:flutter/material.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;
//   final Widget? leading;
//   final bool centerTitle;
//
//   const CustomAppBar({
//     Key? key,
//     required this.title,
//     this.actions,
//     this.leading,
//     this.centerTitle = true,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       leading: leading ?? IconButton(
//         icon: const Icon(Icons.menu, color: Colors.black87),
//         onPressed: () {
//           // Handle menu action
//         },
//       ),
//       title: Text(
//         title,
//         style: const TextStyle(
//           color: Colors.black87,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       centerTitle: centerTitle,
//       actions: actions ?? [
//         IconButton(
//           icon: const Icon(Icons.account_circle, color: Colors.black87),
//           onPressed: () {
//             // Handle profile action
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }





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
          onPressed: onProfilePressed,
        ),
      ],
      backgroundColor: AppColors.background,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.headerHeight);
}