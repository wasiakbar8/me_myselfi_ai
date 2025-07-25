import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class Hamburger extends StatelessWidget {
  const Hamburger({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

class HamburgerDrawer extends StatelessWidget {
  const HamburgerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/logo1.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/logos/logo2.png',
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Main',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  route: '/dashboard_screen',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.inbox,
                  title: 'Unified Inbox',
                  route: '/unified_inbox_screen',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.assistant,
                  title: 'AI Assistant',
                  route: '/ai_assistant_screen',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.mic,
                  title: 'AI Voice Agent',
                  route: '/ai_voice',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today,
                  title: 'AI Smart Calendar',
                  route: '/calendar_screen',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.wallet,
                  title: 'Vault',
                  route: '/vault_password_screen',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.person,
                  title: 'Profile',
                  route: '/profile',
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  route: '/settings',
                ),
              ],
            ),
          ),
          const Divider(),
          InkWell(
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/profile_info');
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundImage: NetworkImage('https://via.placeholder.com/40'),
                  ),
                  const SizedBox(width: 12.0),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('admin@memyself.ai', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pop(context); // Close drawer
                      Navigator.pushNamed(context, '/profile_info');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
      }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close drawer
        Navigator.pushNamedAndRemoveUntil(
          context,
          route,
              (route) => route.settings.name == '/dashboard_screen',
        );
      },
      highlightColor: const Color(0x80FFED29),
      child: ListTile(
        leading: Icon(icon, color: Colors.black),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}