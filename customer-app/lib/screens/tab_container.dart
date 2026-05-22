import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/theme.dart';
import 'home_tab.dart';
import 'explore_tab.dart';
import 'search_tab.dart';
import 'bookings_tab.dart';
import 'profile_tab.dart';

class TabContainer extends StatefulWidget {
  const TabContainer({super.key});

  @override
  State<TabContainer> createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HomeTab(),
    const ExploreTab(),
    const SearchTab(),
    const BookingsTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primary,
          unselectedItemColor: AppTheme.textMuted,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.home, size: 20),
              activeIcon: Icon(LucideIcons.home, size: 22),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.map, size: 20),
              activeIcon: Icon(LucideIcons.map, size: 22),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.search, size: 20),
              activeIcon: Icon(LucideIcons.search, size: 22),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.calendar, size: 20),
              activeIcon: Icon(LucideIcons.calendar, size: 22),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.user, size: 20),
              activeIcon: Icon(LucideIcons.user, size: 22),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
