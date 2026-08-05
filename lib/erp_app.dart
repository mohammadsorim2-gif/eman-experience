import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'features/factory_cycle/presentation/factory_cycle_screen.dart';

class EmanErpApp extends StatelessWidget {
  const EmanErpApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eman ERP',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C5A)),
          scaffoldBackgroundColor: const Color(0xFFF4F7F6),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF7F9F8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero, color: Colors.white),
        ),
        home: const ErpShell(),
      );
}

class ErpShell extends StatefulWidget {
  const ErpShell({super.key});

  @override
  State<ErpShell> createState() => _ErpShellState();
}

class _ErpShellState extends State<ErpShell> {
  int selectedIndex = 0;
  bool collapsed = false;

  static const items = <_NavItem>[
    _NavItem('Dashboard', Icons.grid_view_rounded),
    _NavItem('Factory Hub', Icons.factory_outlined),
    _NavItem('Products', Icons.inventory_2_outlined),
    _NavItem('Recipes', Icons.science_outlined),
    _NavItem('Raw Materials', Icons.grass_outlined),
    _NavItem('Inventory', Icons.warehouse_outlined),
    _NavItem('Production', Icons.precision_manufacturing_outlined),
    _NavItem('Batches', Icons.qr_code_2_rounded),
    _NavItem('Quality', Icons.verified_outlined),
    _NavItem('Shipping', Icons.local_shipping_outlined),
    _NavItem('Reports', Icons.bar_chart_rounded),
    _NavItem('Users & Roles', Icons.admin_panel_settings_outlined),
  ];

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
        final mobile = constraints.maxWidth < 760;
        return Scaffold(
          drawer: mobile ? Drawer(child: SafeArea(child: _Sidebar(selectedIndex: selectedIndex, collapsed: false, onSelect: _select))) : null,
          body: Builder(builder: (scaffoldContext) => Row(children: [
                if (!mobile)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: collapsed ? 82 : 252,
                    child: _Sidebar(selectedIndex: selectedIndex, collapsed: collapsed, onSelect: _select),
                  ),
                Expanded(child: Column(children: [
                  _Header(
                    title: items[selectedIndex].label,
                    mobile: mobile,
                    onMenu: () => mobile ? Scaffold.of(scaffoldContext).openDrawer() : setState(() => collapsed = !collapsed),
                  ),
                  Expanded(child: _page()),
                ])),
              ])),
        );
      });

  Widget _page() {
    if (selectedIndex == 0) return _Dashboard(onNavigate: _select);
    if (selectedIndex == 1) return const FactoryCycleScreen();
    if (selectedIndex >= 6 && selectedIndex <= 9) return FactoryCycleScreen(initialTab: selectedIndex - 6);
    return _ModulePlaceholder(title: items[selectedIndex].label, icon: items[selectedIndex].icon);
  }

  void _select(int index) {
    setState(() => selectedIndex = index);
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) Navigator.of(context).pop();
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.collapsed, required this.onSelect});
  final int selectedIndex;
  final bool collapsed;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: const Color(0xFF0C2E28),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(collapsed ? 19 : 22, 22, collapsed ? 19 : 22, 18),
            child: Row(children: [
              Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFF2BC497), borderRadius: BorderRadius.circular(13)), child: const Icon(Icons.bubble_chart_rounded, color: Colors.white)),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('EMAN ERP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: .8)),
                  Text('Beverage Operations', style: TextStyle(color: Color(0xFF9EC8BC), fontSize: 11)),
                ])),
              ],
            ]),
          ),
          const Divider(color: Color(0xFF21463F), height: 1),
          Expanded(child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            itemCount: _ErpShellState.items.length,
            itemBuilder: (_, index) {
              final item = _ErpShellState.items[index];
              final selected = selectedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Tooltip(
                  message: collapsed ? item.label : '',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => onSelect(index),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: collapsed ? 18 : 14, vertical: 12),
                      decoration: BoxDecoration(color: selected ? const Color(0xFF17493F) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
                      child: Row(children: [
                        Icon(item.icon, size: 20, color: selected ? const Color(0xFF55D9B2) : const Color(0xFFA8C2BB)),
                        if (!collapsed) ...[
                          const SizedBox(width: 13),
                          Expanded(child: Text(item.label, style: TextStyle(color: selected ? Colors.white : const Color(0xFFC3D4CF), fontWeight: selected ? FontWeight.w700 : FontWeight.w500))),
                        ],
                      ]),
                    ),
                  ),
                ),
              );
            },
          )),
          if (!collapsed)
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF143D35), borderRadius: BorderRadius.circular(16)),
              child: const Row(children: [
                CircleAvatar(radius: 18, backgroundColor: Color(0xFF2BC497), child: Text('EA', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Factory Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)), Text('Eman Experience', style: TextStyle(color: Color(0xFF9EC8BC), fontSize: 11))])),
              ]),
            ),
        ]),
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.mobile, required this.onMenu});
  final String title;
  final bool mobile;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) => Container(
        height: 76,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE4EBE8)))),
        child: Row(children: [
          IconButton(onPressed: onMenu, icon: const Icon(Icons.menu_rounded)),
          const SizedBox(width: 8),
          Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF173A33))),
            const Text('Eman Experience · Live factory operations', style: TextStyle(fontSize: 12, color: Color(0xFF748C86))),
          ])),
          if (!mobile) SizedBox(width: 260, child: TextField(decoration: const InputDecoration(isDense: true, hintText: 'Search ERP...', prefixIcon: Icon(Icons.search_rounded, size: 20)))),
          const SizedBox(width: 10),
          IconButton(onPressed: () {}, icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_none_rounded))),
          const CircleAvatar(radius: 18, backgroundColor: Color(0xFF173A33), child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ]),
      );
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.onNavigate});
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('productionOrders').snapshots(),
        builder: (context, ordersSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('batches').snapshots(),
          builder: (context, batchesSnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance.collection('qualityInspections').where('status', isEqualTo: 'pending').snapshots(),
            builder: (context, qualitySnapshot) => StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('shipments').snapshots(),
              builder: (context, shipmentsSnapshot) {
                final orders = ordersSnapshot.data?.docs ?? const [];
                final batches = batchesSnapshot.data?.docs ?? const [];
                final running = orders.where((d) => d.data()['status'] == 'running').length;
                final released = batches.where((d) => d.data()['status'] == 'released').length;
                final pendingQc = qualitySnapshot.data?.size ?? 0;
                final shipments = shipmentsSnapshot.data?.size ?? 0;
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF103F35), Color(0xFF1F8A70)]), borderRadius: BorderRadius.circular(22)),
                      child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Factory Control Center', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                        SizedBox(height: 8),
                        Text('Track every order from planning through production, quality release, and customer delivery.', style: TextStyle(color: Color(0xFFD3EEE6))),
                      ]),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(builder: (_, c) {
                      final count = c.maxWidth >= 1050 ? 4 : c.maxWidth >= 600 ? 2 : 1;
                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: count,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: count == 1 ? 2.6 : 1.8,
                        children: [
                          _Kpi('Running Orders', '$running', Icons.precision_manufacturing_outlined),
                          _Kpi('Released Batches', '$released', Icons.verified_outlined),
                          _Kpi('Pending Quality', '$pendingQc', Icons.fact_check_outlined),
                          _Kpi('Total Shipments', '$shipments', Icons.local_shipping_outlined),
                        ],
                      );
                    }),
                    const SizedBox(height: 20),
                    const Text('Factory workflow', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    Wrap(spacing: 12, runSpacing: 12, children: [
                      _QuickAction('Create production order', Icons.add_task_rounded, () => onNavigate(6)),
                      _QuickAction('Track batches', Icons.qr_code_2_rounded, () => onNavigate(7)),
                      _QuickAction('Quality release', Icons.verified_user_outlined, () => onNavigate(8)),
                      _QuickAction('Schedule shipment', Icons.local_shipping_outlined, () => onNavigate(9)),
                    ]),
                  ]),
                );
              },
            ),
          ),
        ),
      );
}

class _Kpi extends StatelessWidget {
  const _Kpi(this.label, this.value, this.icon);
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(children: [
          Container(width: 46, height: 46, decoration: BoxDecoration(color: const Color(0xFFE6F5F0), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: const Color(0xFF146C5A))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [Text(value, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: Color(0xFF71847F)))])),
        ]),
      ));
}

class _QuickAction extends StatelessWidget {
  const _QuickAction(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionChip(avatar: Icon(icon, size: 19), label: Text(label), onPressed: onTap, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10));
}

class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({required this.title, required this.icon});
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Center(child: Container(
        constraints: const BoxConstraints(maxWidth: 520),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 54, color: const Color(0xFF146C5A)),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          const Text('This module is connected to the ERP navigation and will be completed in the next production batch.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF71847F), height: 1.5)),
        ]),
      ));
}

class _NavItem {
  const _NavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
