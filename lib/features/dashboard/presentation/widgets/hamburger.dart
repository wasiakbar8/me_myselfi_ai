import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';


class Hamburger extends StatelessWidget {
  final Function(int) onItemSelected;

  const Hamburger({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }
}

class HamburgerDrawer extends StatelessWidget {
  final Function(int) onItemSelected;

  const HamburgerDrawer({super.key, required this.onItemSelected});



  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(

              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/logo1.png',
                  height: 35,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 20),
                Image.asset(
                  'assets/logos/logo2.png',
                  height: 35,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // "main" section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  index: 0,
                ),



                _buildDrawerItem(
                  context,
                  icon: Icons.inbox,
                  title: 'Unified Inbox',
                  index: 4,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.assistant,
                  title: 'AI Assistant',
                  index: 5,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.mic,
                  title: 'AI Voice Agent',
                  index: 6,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.calendar_today,
                  title: 'AI Smart Calendar',
                  index: 7,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.wallet,
                  title: 'Vault',
                  index: 3,
                ),
                // "settings" section header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
                  index: 8,
                ),
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  index: 9,
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
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
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Placeholder for _buildDrawerItem (assuming it exists in your code)
  Widget _buildDrawerItem(BuildContext context, {required IconData icon, required String title, required int index}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        // Handle navigation or action based on index
        Navigator.pop(context); // Close drawer
      },
    );
  }

  // Widget _buildDrawerItem(BuildContext context,
  //     {required IconData icon, required String title, required int index}) {
  //   return ListTile(
  //     leading: Icon(icon),
  //     title: Text(title),
  //     onTap: () {
  //       onItemSelected(index);
  //       Navigator.pop(context);
  //     },
  //   );
  // }
}
