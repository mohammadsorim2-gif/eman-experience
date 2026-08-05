import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'features/operations/data/operations_repository.dart';
import 'features/products/data/product_repository.dart';
import 'features/raw_materials/data/raw_material_repository.dart';

class EmanEnterpriseApp extends StatelessWidget {
  const EmanEnterpriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman ERP',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF146C5A)),
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        cardTheme: const CardThemeData(elevation: 0, margin: EdgeInsets.zero, color: Colors.white),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFDDE6E2))),
        ),
      ),
      home: const EnterpriseShell(),
    );
  }
}

class EnterpriseShell extends StatefulWidget {
  const EnterpriseShell({super.key});
  @override
  State<EnterpriseShell> createState() => _EnterpriseShellState();
}

class _EnterpriseShellState extends State<EnterpriseShell> {
  int index = 0;
  bool collapsed = false;
  final firestore = FirebaseFirestore.instance;

  static const items = [
    ('Dashboard', Icons.grid_view_rounded),
    ('Factory Hub', Icons.factory_outlined),
    ('Products', Icons.inventory_2_outlined),
    ('Recipes', Icons.science_outlined),
    ('Raw Materials', Icons.grass_outlined),
    ('Inventory', Icons.warehouse_outlined),
    ('Production', Icons.precision_manufacturing_outlined),
    ('Batches', Icons.qr_code_2_rounded),
    ('Quality', Icons.verified_outlined),
    ('Shipping', Icons.local_shipping_outlined),
    ('Reports', Icons.bar_chart_rounded),
    ('Users & Roles', Icons.admin_panel_settings_outlined),
  ];

  Widget get page {
    switch (index) {
      case 2: return ProductsWorkspace(repository: ProductRepository(firestore));
      case 3: return RecipesWorkspace(repository: OperationsRepository(firestore));
      case 4: return RawMaterialsWorkspace(repository: RawMaterialRepository(firestore));
      case 5: return InventoryWorkspace(rawRepository: RawMaterialRepository(firestore), operationsRepository: OperationsRepository(firestore));
      default: return _OverviewPage(title: items[index].$1, moduleIndex: index, onOpen: (value) => setState(() => index = value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final mobile = constraints.maxWidth < 760;
      final sidebar = _Sidebar(items: items, selected: index, collapsed: collapsed && !mobile, onSelect: (value) {
        setState(() => index = value);
        if (mobile) Navigator.maybePop(context);
      });
      return Scaffold(
        drawer: mobile ? Drawer(child: SafeArea(child: sidebar)) : null,
        body: Row(children: [
          if (!mobile) AnimatedContainer(duration: const Duration(milliseconds: 220), width: collapsed ? 82 : 250, child: sidebar),
          Expanded(child: Column(children: [
            _TopBar(title: items[index].$1, mobile: mobile, onMenu: () {
              if (mobile) Scaffold.of(context).openDrawer(); else setState(() => collapsed = !collapsed);
            }),
            Expanded(child: page),
          ])),
        ]),
      );
    });
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.items, required this.selected, required this.collapsed, required this.onSelect});
  final List<(String, IconData)> items;
  final int selected;
  final bool collapsed;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => Container(
    color: const Color(0xFF0B2F29),
    child: Column(children: [
      Padding(padding: const EdgeInsets.all(20), child: Row(children: [
        const CircleAvatar(backgroundColor: Color(0xFF35B995), child: Icon(Icons.factory_rounded, color: Colors.white)),
        if (!collapsed) ...[const SizedBox(width: 12), const Expanded(child: Text('EMAN ERP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)))],
      ])),
      Expanded(child: ListView.builder(itemCount: items.length, itemBuilder: (_, i) {
        final active = i == selected;
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3), child: ListTile(
          selected: active,
          selectedTileColor: Colors.white.withValues(alpha: .12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          leading: Icon(items[i].$2, color: active ? const Color(0xFF62D5B5) : Colors.white70, size: 20),
          title: collapsed ? null : Text(items[i].$1, style: TextStyle(color: active ? Colors.white : Colors.white70, fontWeight: active ? FontWeight.w700 : FontWeight.w500)),
          onTap: () => onSelect(i),
        ));
      })),
      if (!collapsed) const Padding(padding: EdgeInsets.all(18), child: Text('Production workspace • v1.1', style: TextStyle(color: Colors.white38, fontSize: 11))),
    ]),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.mobile, required this.onMenu});
  final String title;
  final bool mobile;
  final VoidCallback onMenu;
  @override
  Widget build(BuildContext context) => Container(
    height: 72,
    padding: const EdgeInsets.symmetric(horizontal: 18),
    decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE4EBE8)))),
    child: Row(children: [
      IconButton(onPressed: onMenu, icon: Icon(mobile ? Icons.menu_rounded : Icons.menu_open_rounded)),
      const SizedBox(width: 8),
      Text(title, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF163832))),
      const Spacer(),
      const SizedBox(width: 260, child: TextField(decoration: InputDecoration(isDense: true, hintText: 'Search ERP...', prefixIcon: Icon(Icons.search_rounded)))),
      const SizedBox(width: 12),
      IconButton(onPressed: () {}, icon: const Badge(child: Icon(Icons.notifications_none_rounded))),
      const CircleAvatar(child: Text('EM')),
    ]),
  );
}

class _OverviewPage extends StatelessWidget {
  const _OverviewPage({required this.title, required this.moduleIndex, required this.onOpen});
  final String title;
  final int moduleIndex;
  final ValueChanged<int> onOpen;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(moduleIndex == 0 ? 'Factory command center' : title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Color(0xFF153A33))),
      const SizedBox(height: 6),
      Text(moduleIndex == 0 ? 'Live control of products, recipes, raw materials and inventory.' : 'This module is prepared for the next operational batch.', style: const TextStyle(color: Color(0xFF6A7D78))),
      const SizedBox(height: 22),
      if (moduleIndex == 0) ...[
        Wrap(spacing: 14, runSpacing: 14, children: const [
          _Metric('Today production', '18.4 t', '+8.2%', Icons.precision_manufacturing_outlined),
          _Metric('Active orders', '24', '6 urgent', Icons.assignment_outlined),
          _Metric('Low stock', '7', 'Needs action', Icons.warning_amber_rounded),
          _Metric('Pending QC', '5', '2 priority', Icons.fact_check_outlined),
        ]),
        const SizedBox(height: 22),
        Card(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Operational modules', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          Wrap(spacing: 12, runSpacing: 12, children: [
            _ModuleButton('Products', Icons.inventory_2_outlined, () => onOpen(2)),
            _ModuleButton('Recipes', Icons.science_outlined, () => onOpen(3)),
            _ModuleButton('Raw materials', Icons.grass_outlined, () => onOpen(4)),
            _ModuleButton('Inventory', Icons.warehouse_outlined, () => onOpen(5)),
          ]),
        ]))),
      ] else Card(child: Padding(padding: const EdgeInsets.all(32), child: Row(children: [Icon(EnterpriseShell.items[moduleIndex].$2, size: 42), const SizedBox(width: 18), Expanded(child: Text('$title foundation is ready for Firestore integration.', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)))]))),
    ]),
  );
}

class _Metric extends StatelessWidget {
  const _Metric(this.label, this.value, this.note, this.icon);
  final String label, value, note;
  final IconData icon;
  @override
  Widget build(BuildContext context) => SizedBox(width: 240, child: Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: const Color(0xFF146C5A)), const SizedBox(height: 16), Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 5), Text(note, style: const TextStyle(color: Color(0xFF71817D), fontSize: 12))]))));
}

class _ModuleButton extends StatelessWidget {
  const _ModuleButton(this.label, this.icon, this.onTap);
  final String label; final IconData icon; final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => OutlinedButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16)));
}

class ProductsWorkspace extends StatelessWidget {
  const ProductsWorkspace({super.key, required this.repository});
  final ProductRepository repository;
  @override
  Widget build(BuildContext context) => _WorkspaceFrame(
    title: 'Product master data', subtitle: 'Manage finished instant beverage products and SKUs.', actionLabel: 'New product',
    onAction: () => _showProductDialog(context, repository),
    child: StreamBuilder<List<Product>>(stream: repository.watchProducts(activeOnly: false), builder: (_, snapshot) {
      if (snapshot.hasError) return _ErrorState(snapshot.error.toString());
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final data = snapshot.data!;
      if (data.isEmpty) return const _EmptyState('No products yet', 'Create the first finished product SKU.');
      return _DataCard(columns: const ['SKU', 'Product', 'Brand', 'Category', 'Unit', 'Status'], rows: data.map((p) => [p.sku, p.name, p.brand, p.category, p.unit, p.active ? 'Active' : 'Archived']).toList());
    }),
  );
}

class RawMaterialsWorkspace extends StatelessWidget {
  const RawMaterialsWorkspace({super.key, required this.repository});
  final RawMaterialRepository repository;
  @override
  Widget build(BuildContext context) => _WorkspaceFrame(
    title: 'Raw materials', subtitle: 'Ingredients, packaging materials and reorder thresholds.', actionLabel: 'New material',
    onAction: () => _showMaterialDialog(context, repository),
    child: StreamBuilder<List<RawMaterial>>(stream: repository.watchMaterials(), builder: (_, snapshot) {
      if (snapshot.hasError) return _ErrorState(snapshot.error.toString());
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final data = snapshot.data!;
      if (data.isEmpty) return const _EmptyState('No raw materials', 'Add sugar, flavor, citric acid or packaging materials.');
      return _DataCard(columns: const ['Code', 'Material', 'Stock', 'Reorder', 'Unit', 'Status'], rows: data.map((m) => [m.code, m.name, m.currentStock.toStringAsFixed(2), m.reorderLevel.toStringAsFixed(2), m.unit, m.isLowStock ? 'Low stock' : 'Healthy']).toList());
    }),
  );
}

class RecipesWorkspace extends StatelessWidget {
  const RecipesWorkspace({super.key, required this.repository});
  final OperationsRepository repository;
  @override
  Widget build(BuildContext context) => _WorkspaceFrame(
    title: 'Recipes & BOM', subtitle: 'Versioned beverage formulas and standard batch sizes.', actionLabel: 'New recipe',
    onAction: () => _showRecipeDialog(context, repository),
    child: StreamBuilder<List<Recipe>>(stream: repository.watchRecipes(), builder: (_, snapshot) {
      if (snapshot.hasError) return _ErrorState(snapshot.error.toString());
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final data = snapshot.data!;
      if (data.isEmpty) return const _EmptyState('No recipes', 'Create a formula and later attach ingredients and percentages.');
      return _DataCard(columns: const ['Code', 'Recipe', 'Product ID', 'Batch size', 'Unit', 'Version'], rows: data.map((r) => [r.code, r.name, r.productId, r.batchSize.toStringAsFixed(2), r.unit, 'v${r.version}']).toList());
    }),
  );
}

class InventoryWorkspace extends StatelessWidget {
  const InventoryWorkspace({super.key, required this.rawRepository, required this.operationsRepository});
  final RawMaterialRepository rawRepository;
  final OperationsRepository operationsRepository;
  @override
  Widget build(BuildContext context) => _WorkspaceFrame(
    title: 'Inventory movements', subtitle: 'Post receipts and issues with transactional stock updates.', actionLabel: 'Post movement',
    onAction: () => _showMovementDialog(context, rawRepository, operationsRepository),
    child: StreamBuilder<List<StockMovement>>(stream: operationsRepository.watchMovements(), builder: (_, snapshot) {
      if (snapshot.hasError) return _ErrorState(snapshot.error.toString());
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
      final data = snapshot.data!;
      if (data.isEmpty) return const _EmptyState('No stock movements', 'Receive raw materials or issue them to production.');
      return _DataCard(columns: const ['Material', 'Type', 'Quantity', 'Unit', 'Reference', 'Date'], rows: data.map((m) => [m.materialName, m.type.toUpperCase(), m.quantity.toStringAsFixed(2), m.unit, m.reference, m.createdAt?.toLocal().toString().split('.').first ?? 'Pending']).toList());
    }),
  );
}

class _WorkspaceFrame extends StatelessWidget {
  const _WorkspaceFrame({required this.title, required this.subtitle, required this.actionLabel, required this.onAction, required this.child});
  final String title, subtitle, actionLabel;
  final VoidCallback onAction;
  final Widget child;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: Color(0xFF6C7D78)))])), FilledButton.icon(onPressed: onAction, icon: const Icon(Icons.add_rounded), label: Text(actionLabel))]),
    const SizedBox(height: 20), Expanded(child: child),
  ]));
}

class _DataCard extends StatelessWidget {
  const _DataCard({required this.columns, required this.rows});
  final List<String> columns;
  final List<List<String>> rows;
  @override
  Widget build(BuildContext context) => Card(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: SingleChildScrollView(child: DataTable(columns: columns.map((e) => DataColumn(label: Text(e, style: const TextStyle(fontWeight: FontWeight.w800)))).toList(), rows: rows.map((r) => DataRow(cells: r.map((e) => DataCell(Text(e))).toList())).toList())));
}

class _EmptyState extends StatelessWidget {
  const _EmptyState(this.title, this.subtitle); final String title, subtitle;
  @override Widget build(BuildContext context) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.inbox_outlined, size: 52, color: Color(0xFF89A19A)), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 5), Text(subtitle, style: const TextStyle(color: Color(0xFF71817D)))]));
}
class _ErrorState extends StatelessWidget {
  const _ErrorState(this.message); final String message;
  @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('Unable to load data.\n$message', textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent))));
}

Future<void> _showProductDialog(BuildContext context, ProductRepository repository) async {
  final sku = TextEditingController(), name = TextEditingController(), brand = TextEditingController(), category = TextEditingController();
  await _formDialog(context, 'Create product', [('SKU', sku), ('Product name', name), ('Brand', brand), ('Category', category)], () => repository.createProduct(sku: sku.text, name: name.text, brand: brand.text, category: category.text, unit: 'kg'));
}
Future<void> _showMaterialDialog(BuildContext context, RawMaterialRepository repository) async {
  final code = TextEditingController(), name = TextEditingController(), reorder = TextEditingController(text: '100');
  await _formDialog(context, 'Create raw material', [('Code', code), ('Material name', name), ('Reorder level', reorder)], () => repository.createMaterial(code: code.text, name: name.text, unit: 'kg', reorderLevel: double.parse(reorder.text)));
}
Future<void> _showRecipeDialog(BuildContext context, OperationsRepository repository) async {
  final code = TextEditingController(), name = TextEditingController(), product = TextEditingController(), batch = TextEditingController(text: '1000');
  await _formDialog(context, 'Create recipe', [('Code', code), ('Recipe name', name), ('Product ID', product), ('Batch size', batch)], () => repository.createRecipe(code: code.text, name: name.text, productId: product.text, batchSize: double.parse(batch.text), unit: 'kg'));
}
Future<void> _showMovementDialog(BuildContext context, RawMaterialRepository raw, OperationsRepository operations) async {
  final materials = await raw.watchMaterials().first;
  if (!context.mounted || materials.isEmpty) return;
  RawMaterial selected = materials.first;
  String type = 'receipt';
  final quantity = TextEditingController(), reference = TextEditingController();
  await showDialog(context: context, builder: (dialogContext) => StatefulBuilder(builder: (_, setState) => AlertDialog(title: const Text('Post stock movement'), content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [DropdownButtonFormField<RawMaterial>(initialValue: selected, items: materials.map((m) => DropdownMenuItem(value: m, child: Text('${m.code} • ${m.name}'))).toList(), onChanged: (v) => setState(() => selected = v!), decoration: const InputDecoration(labelText: 'Material')), const SizedBox(height: 12), DropdownButtonFormField<String>(initialValue: type, items: const [DropdownMenuItem(value: 'receipt', child: Text('Receipt')), DropdownMenuItem(value: 'issue', child: Text('Issue to production'))], onChanged: (v) => setState(() => type = v!), decoration: const InputDecoration(labelText: 'Movement type')), const SizedBox(height: 12), TextField(controller: quantity, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantity')), const SizedBox(height: 12), TextField(controller: reference, decoration: const InputDecoration(labelText: 'Reference'))])), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () async { try { await operations.postMovement(materialId: selected.id, materialName: selected.name, type: type, quantity: double.parse(quantity.text), unit: selected.unit, reference: reference.text); if (dialogContext.mounted) Navigator.pop(dialogContext); } catch (e) { if (dialogContext.mounted) ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text(e.toString()))); } }, child: const Text('Post'))])));
}

Future<void> _formDialog(BuildContext context, String title, List<(String, TextEditingController)> fields, Future<void> Function() submit) async {
  await showDialog(context: context, builder: (dialogContext) => AlertDialog(title: Text(title), content: SizedBox(width: 420, child: Column(mainAxisSize: MainAxisSize.min, children: [for (final field in fields) ...[TextField(controller: field.$2, decoration: InputDecoration(labelText: field.$1)), const SizedBox(height: 12)]])), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')), FilledButton(onPressed: () async { try { await submit(); if (dialogContext.mounted) Navigator.pop(dialogContext); } catch (e) { if (dialogContext.mounted) ScaffoldMessenger.of(dialogContext).showSnackBar(SnackBar(content: Text(e.toString()))); } }, child: const Text('Save'))]));
}
