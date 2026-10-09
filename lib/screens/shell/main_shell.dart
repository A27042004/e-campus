import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/session_provider.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../academics/academics_screen.dart';
import '../home/home_screen.dart';
import '../news/tech_news_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import '../services/services_screen.dart';
import 'app_drawer.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  static const _titles = ['Home', 'Academics', 'Services', 'Tech News', 'Profile'];

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<SessionProvider>().user;
    if (user == null) return const SizedBox.shrink();

    final pages = <Widget>[
      HomeScreen(onTab: _go),
      const AcademicsScreen(embedded: true),
      const ServicesScreen(embedded: true),
      const TechNewsScreen(embedded: true),
      const ProfileScreen(embedded: true),
    ];

    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _go(0);
      },
      child: Scaffold(
        drawer: AppDrawer(currentTab: _index, onTab: _go),
        appBar: _index == 0
            ? null
            : CustomAppBar(
                title: _titles[_index],
                leading: Builder(
                  builder: (ctx) => Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: IconButton(
                      tooltip: 'Menu',
                      icon: const Icon(Icons.menu_rounded),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                ),
                actions: [
                  BellButton(onTap: () => pushPage(context, const NotificationsScreen()), count: 2),
                ],
              ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          child: KeyedSubtree(key: ValueKey(_index), child: pages[_index]),
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: _go,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
            NavigationDestination(
                icon: Icon(Icons.school_outlined), selectedIcon: Icon(Icons.school_rounded), label: 'Academics'),
            NavigationDestination(
                icon: Icon(Icons.grid_view_outlined),
                selectedIcon: Icon(Icons.grid_view_rounded),
                label: 'Services'),
            NavigationDestination(
                icon: Icon(Icons.newspaper_outlined),
                selectedIcon: Icon(Icons.newspaper_rounded),
                label: 'News'),
            NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
