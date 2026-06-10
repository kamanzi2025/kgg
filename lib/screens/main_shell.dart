import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_provider.dart';
import 'home/home_screen.dart';
import 'explore/explore_screen.dart';
import 'chat/chats_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    ExploreScreen(),
    SizedBox.shrink(), // placeholder for FAB tap
    ChatsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final idx = provider.currentNavIndex;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: IndexedStack(
        index: idx == 2 ? 0 : idx, // keep home visible when FAB tapped
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (provider.canPost) {
            Navigator.pushNamed(context, '/post/create');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Only Club Leaders, Organizers, and Entrepreneurs can post.',
                ),
                backgroundColor: AppColors.cardBackground,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        backgroundColor: AppColors.accentGold,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.black, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNav(
        currentIndex: idx,
        onTap: provider.setNavIndex,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.cardBackground,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, selectedIcon: Icons.home_rounded, label: 'Home', index: 0, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.explore_outlined, selectedIcon: Icons.explore_rounded, label: 'Explore', index: 1, current: currentIndex, onTap: onTap),
          const SizedBox(width: 48), // FAB notch gap
          _NavItem(icon: Icons.chat_bubble_outline_rounded, selectedIcon: Icons.chat_bubble_rounded, label: 'Chats', index: 3, current: currentIndex, onTap: onTap),
          _NavItem(icon: Icons.person_outline_rounded, selectedIcon: Icons.person_rounded, label: 'Profile', index: 4, current: currentIndex, onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected ? AppColors.accentGold : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accentGold : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
