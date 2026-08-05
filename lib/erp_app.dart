import 'package:flutter/material.dart';

class EmanErpApp extends StatelessWidget {
  const EmanErpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman ERP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF146C5A),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: Colors.white,
        ),
      ),
      home: const ErpDashboardScreen(),
    );
  }
}

class ErpDashboardScreen extends StatefulWidget {
  const ErpDashboardScreen({super.key});

  @override
  State<ErpDashboardScreen> createState() => _ErpDashboardScreenState();
}

class _ErpDashboardScreenState extends State<ErpDashboardScreen> {
  int selectedIndex = 0;
  bool collapsed = false;

  static const navItems = <_NavItem>[
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 760;
        final compact = constraints.maxWidth < 1120;
        return Scaffold(
          drawer: mobile
              ? Drawer(child: SafeArea(child: _Sidebar(selectedIndex: selectedIndex, collapsed: false, onSelect: _select)))
              : null,
          body: Row(
            children: [
              if (!mobile)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: collapsed ? 84 : 252,
                  child: _Sidebar(selectedIndex: selectedIndex, collapsed: collapsed, onSelect: _select),
                ),
              Expanded(
                child: Column(
                  children: [
                    _Header(
                      mobile: mobile,
                      collapsed: collapsed,
                      onMenu: () {
                        if (mobile) {
                          Scaffold.of(context).openDrawer();
                        } else {
                          setState(() => collapsed = !collapsed);
                        }
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(compact ? 20 : 28),
                        child: const _DashboardContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _select(int index) => setState(() => selectedIndex = index);
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.collapsed, required this.onSelect});

  final int selectedIndex;
  final bool collapsed;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFF0C2E28),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(collapsed ? 18 : 22, 22, collapsed ? 18 : 22, 18),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(color: const Color(0xFF2BC497), borderRadius: BorderRadius.circular(13)),
                  child: const Icon(Icons.bubble_chart_rounded, color: Colors.white),
                ),
                if (!collapsed) ...[
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('EMAN ERP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: .8)),
                      SizedBox(height: 2),
                      Text('Beverage Operations', style: TextStyle(color: Color(0xFF9EC8BC), fontSize: 11)),
                    ]),
                  ),
                ],
              ],
            ),
          ),
          const Divider(color: Color(0xFF21463F), height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
              itemCount: _ErpDashboardScreenState.navItems.length,
              itemBuilder: (context, index) {
                final item = _ErpDashboardScreenState.navItems[index];
                final selected = index == selectedIndex;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Tooltip(
                    message: collapsed ? item.label : '',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => onSelect(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        padding: EdgeInsets.symmetric(horizontal: collapsed ? 18 : 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: selected ? const Color(0xFF17493F) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(item.icon, size: 20, color: selected ? const Color(0xFF55D9B2) : const Color(0xFFA8C2BB)),
                            if (!collapsed) ...[
                              const SizedBox(width: 13),
                              Expanded(
                                child: Text(item.label, style: TextStyle(color: selected ? Colors.white : const Color(0xFFC3D4CF), fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!collapsed)
            Container(
              margin: const EdgeInsets.all(14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF143D35), borderRadius: BorderRadius.circular(16)),
              child: const Row(children: [
                CircleAvatar(radius: 18, backgroundColor: Color(0xFF2BC497), child: Text('MA', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Factory Admin', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)), Text('Production Plant', style: TextStyle(color: Color(0xFF9EC8BC), fontSize: 11))])),
                Icon(Icons.more_vert, color: Color(0xFF9EC8BC), size: 18),
              ]),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.mobile, required this.collapsed, required this.onMenu});
  final bool mobile;
  final bool collapsed;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE4EBE8)))),
      child: Row(children: [
        IconButton(onPressed: onMenu, icon: Icon(mobile ? Icons.menu_rounded : collapsed ? Icons.last_page_rounded : Icons.first_page_rounded)),
        const SizedBox(width: 8),
        const Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Operations Dashboard', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF173A33))), Text('Live overview of factory performance', style: TextStyle(fontSize: 12, color: Color(0xFF748C86)))])),
        if (!mobile)
          SizedBox(width: 260, child: TextField(decoration: InputDecoration(isDense: true, hintText: 'Search anything...', prefixIcon: const Icon(Icons.search_rounded, size: 20), filled: true, fillColor: const Color(0xFFF4F7F6), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))),
        const SizedBox(width: 12),
        IconButton(onPressed: () {}, icon: const Badge(smallSize: 8, child: Icon(Icons.notifications_none_rounded))),
        const SizedBox(width: 6),
        const CircleAvatar(radius: 18, backgroundColor: Color(0xFF173A33), child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ]),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _WelcomeCard(),
      const SizedBox(height: 22),
      LayoutBuilder(builder: (context, c) {
        final columns = c.maxWidth >= 1250 ? 4 : c.maxWidth >= 680 ? 2 : 1;
        final cards = const [
          _KpiCard('Production Today', '18,420 kg', '+8.4%', Icons.precision_manufacturing_rounded, Color(0xFF1F8A70)),
          _KpiCard('Active Orders', '24', '6 urgent', Icons.assignment_outlined, Color(0xFF3578E5)),
          _KpiCard('Inventory Value', '₺4.86M', '+2.1%', Icons.warehouse_outlined, Color(0xFF8C5BE8)),
          _KpiCard('Pending QC', '7 batches', '2 critical', Icons.fact_check_outlined, Color(0xFFE48535)),
        ];
        return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: columns, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: columns == 1 ? 2.5 : 2.05, children: cards);
      }),
      const SizedBox(height: 22),
      LayoutBuilder(builder: (context, c) {
        final stack = c.maxWidth < 980;
        final left = Column(children: const [_SectionCard(title: 'Production Overview', child: _ProductionOverview()), SizedBox(height: 18), _SectionCard(title: 'Recent Activity', child: _RecentActivity())]);
        final right = Column(children: const [_SectionCard(title: 'Quick Actions', child: _QuickActions()), SizedBox(height: 18), _SectionCard(title: 'Alerts & Attention', child: _Alerts())]);
        return stack ? Column(children: [left, const SizedBox(height: 18), right]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 2, child: left), const SizedBox(width: 18), Expanded(child: right)]);
      }),
    ]);
  }
}

class _WelcomeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF123C33), Color(0xFF1B6A57)]), borderRadius: BorderRadius.circular(22)),
    child: Wrap(runSpacing: 16, alignment: WrapAlignment.spaceBetween, crossAxisAlignment: WrapCrossAlignment.center, children: [
      const SizedBox(width: 520, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good morning, Factory Team', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)), SizedBox(height: 8), Text('Plant performance is stable. Two quality alerts and one low-stock item need attention today.', style: TextStyle(color: Color(0xFFD0E8E1), height: 1.5))])),
      FilledButton.icon(onPressed: () {}, style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF164D40), padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16)), icon: const Icon(Icons.add_rounded), label: const Text('New Production Order')),
    ]),
  );
}

class _KpiCard extends StatelessWidget {
  const _KpiCard(this.title, this.value, this.note, this.icon, this.color);
  final String title, value, note;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE3ECE8))),
    child: Row(children: [Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: color)), const SizedBox(width: 14), Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Color(0xFF6D817B), fontSize: 12)), const SizedBox(height: 5), Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: Color(0xFF183A33))), const SizedBox(height: 3), Text(note, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700))]))]),
  );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});
  final String title;
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE3ECE8))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF183A33)))), TextButton(onPressed: () {}, child: const Text('View all'))]), const SizedBox(height: 14), child]));
}

class _ProductionOverview extends StatelessWidget {
  const _ProductionOverview();
  @override
  Widget build(BuildContext context) => Column(children: const [
    _ProgressRow('Valore Orange 10 g', 'Batch EM-240801', .86, '8,600 / 10,000 kg'),
    _ProgressRow('Frio Cups Mango 9 g', 'Batch EM-240802', .62, '4,960 / 8,000 kg'),
    _ProgressRow('Roya C Lemon 2.5 kg', 'Batch EM-240803', .37, '2,220 / 6,000 kg'),
  ]);
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow(this.title, this.subtitle, this.progress, this.value);
  final String title, subtitle, value;
  final double progress;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w700))), Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF6D817B)))]), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF82958F))), const SizedBox(height: 9), LinearProgressIndicator(value: progress, minHeight: 8, borderRadius: BorderRadius.circular(10), backgroundColor: const Color(0xFFE7EFEC))]));
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();
  @override
  Widget build(BuildContext context) {
    const actions = [
      ('Production Order', Icons.add_task_rounded), ('Receive Material', Icons.move_to_inbox_outlined), ('Quality Check', Icons.verified_outlined), ('Stock Transfer', Icons.swap_horiz_rounded), ('Create Batch', Icons.qr_code_2_rounded), ('Shipment', Icons.local_shipping_outlined),
    ];
    return Wrap(spacing: 10, runSpacing: 10, children: actions.map((item) => SizedBox(width: 145, child: OutlinedButton.icon(onPressed: () {}, style: OutlinedButton.styleFrom(alignment: Alignment.centerLeft, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14), side: const BorderSide(color: Color(0xFFDCE7E3))), icon: Icon(item.$2, size: 18), label: Text(item.$1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)))).toList());
  }
}

class _RecentActivity extends StatelessWidget {
  const _RecentActivity();
  @override
  Widget build(BuildContext context) => const Column(children: [
    _ActivityRow(Icons.inventory_2_outlined, 'Raw material received', 'Citric acid · 1,200 kg · Warehouse A', '12 min ago'),
    _ActivityRow(Icons.verified_outlined, 'Quality check approved', 'Batch EM-240798 · Valore Strawberry', '28 min ago'),
    _ActivityRow(Icons.local_shipping_outlined, 'Shipment dispatched', 'Order SO-1048 · Istanbul distributor', '1 hr ago'),
    _ActivityRow(Icons.precision_manufacturing_outlined, 'Production order started', 'PO-2039 · Line 2', '2 hrs ago'),
  ]);
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow(this.icon, this.title, this.subtitle, this.time);
  final IconData icon;
  final String title, subtitle, time;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 10), child: Row(children: [CircleAvatar(radius: 18, backgroundColor: const Color(0xFFE8F4F0), child: Icon(icon, size: 18, color: const Color(0xFF1E7C65))), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), const SizedBox(height: 3), Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF748C86)))])), Text(time, style: const TextStyle(fontSize: 10, color: Color(0xFF92A39E)))]));
}

class _Alerts extends StatelessWidget {
  const _Alerts();
  @override
  Widget build(BuildContext context) => const Column(children: [
    _AlertRow(Color(0xFFE85D4A), Icons.error_outline_rounded, 'Critical stock', 'Mango flavor is below minimum level.'),
    _AlertRow(Color(0xFFF0A23A), Icons.schedule_rounded, 'QC waiting', 'Two batches await final laboratory release.'),
    _AlertRow(Color(0xFF3D7BE0), Icons.build_outlined, 'Maintenance due', 'Mixer MX-02 service is due tomorrow.'),
  ]);
}

class _AlertRow extends StatelessWidget {
  const _AlertRow(this.color, this.icon, this.title, this.message);
  final Color color;
  final IconData icon;
  final String title, message;
  @override
  Widget build(BuildContext context) => Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: .08), borderRadius: BorderRadius.circular(13), border: Border.all(color: color.withValues(alpha: .18))), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 20, color: color), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: color, fontSize: 12)), const SizedBox(height: 3), Text(message, style: const TextStyle(fontSize: 11, color: Color(0xFF5D716B), height: 1.4))]))]));
}

class _NavItem {
  const _NavItem(this.label, this.icon);
  final String label;
  final IconData icon;
}
