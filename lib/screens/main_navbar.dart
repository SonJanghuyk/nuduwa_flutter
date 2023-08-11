import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        height: 60,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.map),
            label: '찾기',
            selectedIcon: Icon(Icons.map, color: Colors.white),
          ),
          NavigationDestination(
            icon: Icon(Icons.people),
            label: '모임',
            selectedIcon: Icon(Icons.people, color: Colors.white),
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble),
            label: '1:1 채팅',
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: '내 정보',
            selectedIcon: Icon(Icons.person, color: Colors.white),
          ),
        ],
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) => _onTap(context, index),
        indicatorColor: Colors.blue,
        surfaceTintColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
