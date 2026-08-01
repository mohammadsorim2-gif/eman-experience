import 'package:flutter/material.dart';

import 'app.dart';
import 'screens/factory/factory_dashboard.dart';

void main() {
  runApp(const EmanOneApp());
}

class EmanOneApp extends StatelessWidget {
  const EmanOneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAN ONE',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: EmanExperienceApp.blue,
          primary: EmanExperienceApp.blue,
        ),
        scaffoldBackgroundColor: EmanExperienceApp.background,
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE7EDF3)),
          ),
        ),
      ),
      home: const EmanOneShell(),
    );
  }
}

class EmanOneShell extends StatefulWidget {
  const EmanOneShell({super.key});

  @override
  State<EmanOneShell> createState() => _EmanOneShellState();
}

class _EmanOneShellState extends State<EmanOneShell> {
  int currentIndex = 0;

  static const pages = [
    PublicHome(),
    ProductsPage(),
    BecomePartnerPage(),
    PartnerDashboard(),
    FactoryDashboard(),
    AdminPreviewPage(),
  ];

  static const destinations = [
    (Icons.home_outlined, Icons.home, 'Home'),
    (Icons.inventory_2_outlined, Icons.inventory_2, 'Products'),
    (Icons.person_add_alt_outlined, Icons.person_add_alt, 'Partner'),
    (Icons.dashboard_outlined, Icons.dashboard, 'Partner Dashboard'),
    (Icons.factory_outlined, Icons.factory, 'EMAN Factory'),
    (Icons.admin_panel_settings_outlined, Icons.admin_panel_settings, 'Admin'),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 980;

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 238,
              backgroundColor: Colors.white,
              selectedIndex: currentIndex,
              onDestinationSelected: (value) => setState(() => currentIndex = value),
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/logos/Eman logo.png',
                      height: 52,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        'EMAN',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ONE PLATFORM',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF72838E),
                      ),
                    ),
                  ],
                ),
              ),
              destinations: destinations
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.$1),
                      selectedIcon: Icon(item.$2),
                      label: Text(item.$3),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(width: 1),
            Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: pages[currentIndex])),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/logos/Eman logo.png',
              height: 38,
              errorBuilder: (context, error, stackTrace) => const Text('EMAN'),
            ),
            const SizedBox(width: 10),
            const Text('ONE', style: TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      drawer: NavigationDrawer(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() => currentIndex = value);
          Navigator.pop(context);
        },
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 24, 16, 12),
            child: Text('EMAN ONE', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          ),
          ...destinations.map(
            (item) => NavigationDrawerDestination(icon: Icon(item.$1), selectedIcon: Icon(item.$2), label: Text(item.$3)),
          ),
        ],
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: pages[currentIndex]),
    );
  }
}
