import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  static const primary = Color(0xFF0067C8);
  static const navy = Color(0xFF052B52);
  static const pale = Color(0xFFF3F8FD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman Experience',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: pale,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDCE7F2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFDCE7F2)),
          ),
        ),
      ),
      home: const CatalogScreen(),
    );
  }
}

class BrandData {
  const BrandData(this.id, this.name, this.logo, this.description);
  final String id;
  final String name;
  final String logo;
  final String description;
}

const brandData = <BrandData>[
  BrandData('all', 'All Products', 'assets/logos/Eman logo.png', 'The complete Eman portfolio'),
  BrandData('valore', 'Valore', 'assets/brands/valore/Valore Logo.png', '10 g instant powder drinks'),
  BrandData('friocups', 'Frio Cups', 'assets/brands/friocups/Frio Cups Logo.png', '9 g instant powder drinks'),
  BrandData('royac', 'Roya C', 'assets/brands/royac/ROya c Logo.png', '2.5 kg professional solutions'),
  BrandData('fullfresh', 'Full Fresh', 'assets/brands/fullfresh/Full Fresh Logo.png', '9 g flavored powder drinks'),
];

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final _productsKey = GlobalKey();
  final _privateLabelKey = GlobalKey();
  final _search = TextEditingController();
  final Set<String> _quote = {};
  List<String> _assets = [];
  String _brand = 'all';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _loadAssets() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final items = manifest.listAssets().where((path) {
      final lower = path.toLowerCase();
      return path.startsWith('assets/products/') &&
          (lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg') || lower.endsWith('.webp'));
    }).toList()..sort();
    if (!mounted) return;
    setState(() {
      _assets = items;
      _loading = false;
    });
  }

  List<String> get _visible {
    final query = _search.text.trim().toLowerCase();
    return _assets.where((path) {
      final matchesBrand = _brand == 'all' || path.contains('/$_brand/');
      final matchesSearch = query.isEmpty || _name(path).toLowerCase().contains(query);
      return matchesBrand && matchesSearch;
    }).toList();
  }

  String _name(String path) {
    var value = path.split('/').last.split('.').first;
    const removals = ['powder-drink', 'flavored', 'friocups', 'valore', 'full-fresh'];
    for (final item in removals) {
      value = value.replaceAll(RegExp(item, caseSensitive: false), '');
    }
    value = value
        .replaceAll(RegExp('2-5kg', caseSensitive: false), '2.5 kg')
        .replaceAll(RegExp('10grams', caseSensitive: false), '10 g')
        .replaceAll(RegExp('10g', caseSensitive: false), '10 g')
        .replaceAll(RegExp('9g', caseSensitive: false), '9 g')
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return value.split(' ').map((word) => word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}').join(' ');
  }

  String _brandName(String path) {
    if (path.contains('/valore/')) return 'Valore';
    if (path.contains('/friocups/')) return 'Frio Cups';
    if (path.contains('/royac/')) return 'Roya C';
    if (path.contains('/fullfresh/')) return 'Full Fresh';
    return 'Eman';
  }

  void _scrollTo(GlobalKey key) {
    final target = key.currentContext;
    if (target == null) return;
    Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 650), curve: Curves.easeOutCubic);
  }

  void _openQuote() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QuoteSheet(
        items: _quote.toList(),
        productName: _name,
        onRemove: (item) => setState(() => _quote.remove(item)),
      ),
    );
  }

  void _openProduct(String path) {
    showDialog<void>(
      context: context,
      builder: (_) => ProductDialog(
        path: path,
        name: _name(path),
        brand: _brandName(path),
        selected: _quote.contains(path),
        onToggle: () {
          setState(() => _quote.contains(path) ? _quote.remove(path) : _quote.add(path));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header()),
          SliverToBoxAdapter(child: _hero()),
          SliverToBoxAdapter(child: _brands()),
          SliverToBoxAdapter(key: _productsKey, child: _catalogHeader()),
          if (_loading)
            const SliverToBoxAdapter(child: SizedBox(height: 320, child: Center(child: CircularProgressIndicator())))
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
              sliver: SliverLayoutBuilder(builder: (_, constraints) {
                final w = constraints.crossAxisExtent;
                final columns = w >= 1400 ? 4 : w >= 980 ? 3 : w >= 650 ? 2 : 1;
                return SliverGrid.builder(
                  itemCount: _visible.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: columns == 1 ? 1.08 : .80,
                  ),
                  itemBuilder: (_, i) {
                    final path = _visible[i];
                    return ProductCard(
                      path: path,
                      title: _name(path),
                      brand: _brandName(path),
                      selected: _quote.contains(path),
                      onOpen: () => _openProduct(path),
                      onToggle: () => setState(() => _quote.contains(path) ? _quote.remove(path) : _quote.add(path)),
                    );
                  },
                );
              }),
            ),
          SliverToBoxAdapter(key: _privateLabelKey, child: _privateLabel()),
          const SliverToBoxAdapter(child: AppFooter()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openQuote,
        backgroundColor: EmanExperienceApp.navy,
        foregroundColor: Colors.white,
        icon: Badge(isLabelVisible: _quote.isNotEmpty, label: Text('${_quote.length}'), child: const Icon(Icons.request_quote_outlined)),
        label: const Text('Request Quote'),
      ),
    );
  }

  Widget _header() => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
        child: LayoutBuilder(builder: (_, c) {
          final compact = c.maxWidth < 820;
          return Row(children: [
            Image.asset('assets/logos/Eman logo.png', height: 48),
            const Spacer(),
            if (!compact) ...[
              TextButton(onPressed: () {}, child: const Text('Home')),
              TextButton(onPressed: () => _scrollTo(_productsKey), child: const Text('Products')),
              TextButton(onPressed: () => _scrollTo(_privateLabelKey), child: const Text('Private Label')),
              const SizedBox(width: 10),
            ],
            FilledButton.icon(onPressed: _openQuote, icon: const Icon(Icons.request_quote_outlined), label: Text(compact ? '${_quote.length}' : 'Quote List ${_quote.length}')),
          ]);
        }),
      );

  Widget _hero() {
    final samples = _assets.take(3).toList();
    return Container(
      margin: const EdgeInsets.all(24),
      constraints: const BoxConstraints(minHeight: 540),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF031C36), Color(0xFF0067C8), Color(0xFF2B8DE8)]),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(builder: (_, c) {
        final compact = c.maxWidth < 900;
        final copy = Padding(
          padding: EdgeInsets.all(compact ? 30 : 58),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('EMAN DIGITAL EXPERIENCE', style: TextStyle(color: Color(0xFFB9DCFF), fontWeight: FontWeight.w800, letterSpacing: 2.2)),
            const SizedBox(height: 22),
            Text('Flavor built\nfor every market.', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, height: 1.02, fontSize: compact ? 46 : 70)),
            const SizedBox(height: 20),
            const Text('Discover our beverage portfolio, explore every flavor and create your quotation request in seconds.', style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.6)),
            const SizedBox(height: 30),
            Wrap(spacing: 12, runSpacing: 12, children: [
              FilledButton.icon(onPressed: () => _scrollTo(_productsKey), style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: EmanExperienceApp.navy, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)), icon: const Icon(Icons.grid_view_rounded), label: const Text('Explore Products')),
              OutlinedButton.icon(onPressed: _openQuote, style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)), icon: const Icon(Icons.request_quote_outlined), label: const Text('Request a Quote')),
            ]),
          ]),
        );
        final visual = Stack(alignment: Alignment.center, children: [
          Container(width: 390, height: 390, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: .08), border: Border.all(color: Colors.white24))),
          for (var i = 0; i < samples.length; i++)
            Transform.translate(offset: Offset((i - 1) * 95, i == 1 ? -18 : 38), child: Transform.rotate(angle: (i - 1) * .10, child: SizedBox(width: i == 1 ? 210 : 175, height: i == 1 ? 350 : 300, child: Image.asset(samples[i], fit: BoxFit.contain)))),
        ]);
        return compact ? Column(children: [copy, SizedBox(height: 390, child: visual)]) : Row(children: [Expanded(flex: 11, child: copy), Expanded(flex: 9, child: visual)]);
      }),
    );
  }

  Widget _brands() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 42),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Our Brands', style: TextStyle(color: EmanExperienceApp.navy, fontSize: 36, fontWeight: FontWeight.w900)),
          const SizedBox(height: 18),
          SizedBox(
            height: 134,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brandData.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                final item = brandData[i];
                final active = item.id == _brand;
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => setState(() => _brand = item.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 228,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(color: active ? const Color(0xFFE8F3FF) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: active ? EmanExperienceApp.primary : const Color(0xFFE0E9F2), width: active ? 2 : 1)),
                    child: Row(children: [
                      Container(width: 64, height: 64, padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17)), child: Image.asset(item.logo, fit: BoxFit.contain)),
                      const SizedBox(width: 13),
                      Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.name, style: const TextStyle(color: EmanExperienceApp.navy, fontSize: 17, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 5),
                        Text(item.description, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF6E8195), fontSize: 12)),
                      ])),
                    ]),
                  ),
                );
              },
            ),
          ),
        ]),
      );

  Widget _catalogHeader() => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
        child: LayoutBuilder(builder: (_, c) {
          final compact = c.maxWidth < 730;
          final title = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Product Catalog', style: TextStyle(color: EmanExperienceApp.navy, fontSize: 36, fontWeight: FontWeight.w900)),
            const SizedBox(height: 7),
            Text('${_visible.length} products available', style: const TextStyle(color: Color(0xFF718397), fontSize: 16)),
          ]);
          final search = SizedBox(width: compact ? double.infinity : 370, child: TextField(controller: _search, onChanged: (_) => setState(() {}), decoration: const InputDecoration(hintText: 'Search flavor or product...', prefixIcon: Icon(Icons.search))));
          return compact ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 18), search]) : Row(children: [Expanded(child: title), search]);
        }),
      );

  Widget _privateLabel() => Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 70),
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(34), gradient: const LinearGradient(colors: [Color(0xFF9BCBFA), Color(0xFF0067C8)])),
        child: Container(
          padding: const EdgeInsets.all(42),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(33)),
          child: LayoutBuilder(builder: (_, c) {
            final compact = c.maxWidth < 780;
            final icon = Container(width: 180, height: 180, decoration: BoxDecoration(color: const Color(0xFFEAF4FE), borderRadius: BorderRadius.circular(34)), child: const Icon(Icons.design_services_outlined, size: 86, color: EmanExperienceApp.primary));
            final text = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('PRIVATE LABEL', style: TextStyle(color: EmanExperienceApp.primary, fontWeight: FontWeight.w900, letterSpacing: 2)),
              const SizedBox(height: 12),
              const Text('Your brand. Our expertise.', style: TextStyle(color: EmanExperienceApp.navy, fontSize: 38, fontWeight: FontWeight.w900)),
              const SizedBox(height: 14),
              const Text('From flavor development and packaging to production and export support, Eman helps you create a beverage product built for your market.', style: TextStyle(color: Color(0xFF64788D), fontSize: 17, height: 1.6)),
              const SizedBox(height: 22),
              FilledButton.icon(onPressed: _openQuote, icon: const Icon(Icons.arrow_forward), label: const Text('Start Your Project')),
            ]);
            return compact ? Column(children: [icon, const SizedBox(height: 28), text]) : Row(children: [icon, const SizedBox(width: 42), Expanded(child: text)]);
          }),
        ),
      );
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.path, required this.title, required this.brand, required this.selected, required this.onOpen, required this.onToggle});
  final String path;
  final String title;
  final String brand;
  final bool selected;
  final VoidCallback onOpen;
  final VoidCallback onToggle;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, hover ? -7 : 0, 0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), border: Border.all(color: widget.selected ? EmanExperienceApp.primary : const Color(0xFFE1E9F2), width: widget.selected ? 2 : 1), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: hover ? .12 : .05), blurRadius: hover ? 28 : 14, offset: const Offset(0, 12))]),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onOpen,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(24), decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFFF9FCFF), Color(0xFFEAF3FC)])), child: Hero(tag: widget.path, child: Image.asset(widget.path, fit: BoxFit.contain)))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.brand.toUpperCase(), style: const TextStyle(color: EmanExperienceApp.primary, fontWeight: FontWeight.w800, letterSpacing: 1.2, fontSize: 12)),
                  const SizedBox(height: 7),
                  Text(widget.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: EmanExperienceApp.navy, fontSize: 20, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  const Text('Click to rotate 360°', style: TextStyle(color: Color(0xFF77899B), fontSize: 12)),
                ])),
                IconButton.filled(onPressed: widget.onToggle, style: IconButton.styleFrom(backgroundColor: widget.selected ? EmanExperienceApp.primary : const Color(0xFFE7F2FF), foregroundColor: widget.selected ? Colors.white : EmanExperienceApp.primary), icon: Icon(widget.selected ? Icons.check : Icons.add)),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  const ProductDialog({super.key, required this.path, required this.name, required this.brand, required this.selected, required this.onToggle});
  final String path;
  final String name;
  final String brand;
  final bool selected;
  final VoidCallback onToggle;

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _rotation = 0;
  double _dragStart = 0;
  double _rotationStart = 0;
  bool _autoSpin = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 7))
      ..addListener(() {
        if (_autoSpin && mounted) setState(() => _rotation = _controller.value * math.pi * 2);
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startDrag(DragStartDetails details) {
    setState(() => _autoSpin = false);
    _dragStart = details.localPosition.dx;
    _rotationStart = _rotation;
  }

  void _drag(DragUpdateDetails details) {
    setState(() => _rotation = _rotationStart + (details.localPosition.dx - _dragStart) * .012);
  }

  void _toggleSpin() {
    setState(() {
      _autoSpin = !_autoSpin;
      if (_autoSpin) {
        _controller.value = ((_rotation % (math.pi * 2)) / (math.pi * 2)).clamp(0, 1);
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 980),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: LayoutBuilder(builder: (_, c) {
            final compact = c.maxWidth < 700;
            final viewer = Container(
              height: compact ? 390 : 540,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F7FE),
                borderRadius: BorderRadius.circular(24),
                gradient: const RadialGradient(colors: [Colors.white, Color(0xFFE5F1FC)]),
              ),
              child: Stack(children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragStart: _startDrag,
                    onHorizontalDragUpdate: _drag,
                    child: Center(
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, .0016)
                          ..rotateY(_rotation),
                        child: Padding(
                          padding: const EdgeInsets.all(38),
                          child: Image.asset(widget.path, fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .9), borderRadius: BorderRadius.circular(30)),
                    child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.threesixty, size: 20, color: EmanExperienceApp.primary), SizedBox(width: 7), Text('360° VIEW', style: TextStyle(fontWeight: FontWeight.w900, color: EmanExperienceApp.navy))]),
                  ),
                ),
                Positioned(
                  right: 14,
                  top: 14,
                  child: IconButton.filledTonal(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    FilledButton.tonalIcon(onPressed: _toggleSpin, icon: Icon(_autoSpin ? Icons.pause : Icons.play_arrow), label: Text(_autoSpin ? 'Pause rotation' : 'Auto rotate')),
                    const SizedBox(width: 10),
                    const Flexible(child: Text('Drag left or right to rotate', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF60758A), fontWeight: FontWeight.w600))),
                  ]),
                ),
              ]),
            );
            final info = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(widget.brand.toUpperCase(), style: const TextStyle(color: EmanExperienceApp.primary, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
              const SizedBox(height: 12),
              Text(widget.name, style: const TextStyle(color: EmanExperienceApp.navy, fontSize: 36, fontWeight: FontWeight.w900)),
              const SizedBox(height: 18),
              const Text('Interactive product presentation. Rotate the package with your mouse or finger and inspect it from every direction.', style: TextStyle(color: Color(0xFF64788D), fontSize: 16, height: 1.6)),
              const SizedBox(height: 24),
              const Wrap(spacing: 10, runSpacing: 10, children: [Chip(label: Text('Interactive 360°')), Chip(label: Text('Export ready')), Chip(label: Text('Multiple markets'))]),
              const SizedBox(height: 26),
              SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: widget.onToggle, icon: Icon(widget.selected ? Icons.check : Icons.add), label: Text(widget.selected ? 'Added to Quote' : 'Add to Quote'), style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)))),
            ]);
            return compact ? SingleChildScrollView(child: Column(children: [viewer, const SizedBox(height: 26), info])) : Row(children: [Expanded(flex: 11, child: viewer), const SizedBox(width: 34), Expanded(flex: 9, child: info)]);
          }),
        ),
      ),
    );
  }
}

class QuoteSheet extends StatefulWidget {
  const QuoteSheet({super.key, required this.items, required this.productName, required this.onRemove});
  final List<String> items;
  final String Function(String) productName;
  final ValueChanged<String> onRemove;

  @override
  State<QuoteSheet> createState() => _QuoteSheetState();
}

class _QuoteSheetState extends State<QuoteSheet> {
  late final List<String> items = [...widget.items];
  final company = TextEditingController();
  final contact = TextEditingController();
  final country = TextEditingController();
  final notes = TextEditingController();

  @override
  void dispose() {
    company.dispose();
    contact.dispose();
    country.dispose();
    notes.dispose();
    super.dispose();
  }

  void _submit() {
    if (items.isEmpty || company.text.trim().isEmpty || contact.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add products and complete company and contact details.')));
      return;
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Your inquiry has been prepared successfully.')));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 780,
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .9),
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Expanded(child: Text('Request a Quote', style: TextStyle(color: EmanExperienceApp.navy, fontSize: 30, fontWeight: FontWeight.w900))), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))]),
            const SizedBox(height: 10),
            Text('${items.length} selected products', style: const TextStyle(color: Color(0xFF6F8194))),
            const SizedBox(height: 18),
            if (items.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 50), child: Center(child: Text('Your quote list is empty.')))
            else
              ...items.map((path) => ListTile(contentPadding: EdgeInsets.zero, leading: SizedBox(width: 58, child: Image.asset(path, fit: BoxFit.contain)), title: Text(widget.productName(path)), trailing: IconButton(onPressed: () { widget.onRemove(path); setState(() => items.remove(path)); }, icon: const Icon(Icons.delete_outline)))),
            const Divider(height: 30),
            TextField(controller: company, decoration: const InputDecoration(labelText: 'Company name *', prefixIcon: Icon(Icons.business_outlined))),
            const SizedBox(height: 12),
            TextField(controller: contact, decoration: const InputDecoration(labelText: 'Email or phone number *', prefixIcon: Icon(Icons.alternate_email))),
            const SizedBox(height: 12),
            TextField(controller: country, decoration: const InputDecoration(labelText: 'Country', prefixIcon: Icon(Icons.public))),
            const SizedBox(height: 12),
            TextField(controller: notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Quantities and notes', prefixIcon: Icon(Icons.notes))),
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _submit, style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)), icon: const Icon(Icons.send_outlined), label: const Text('Send Inquiry'))),
          ]),
        ),
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EmanExperienceApp.navy,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 38),
      child: LayoutBuilder(builder: (_, c) {
        final compact = c.maxWidth < 650;
        final logo = Image.asset('assets/logos/Eman logo.png', height: 52, errorBuilder: (_, __, ___) => const Text('EMAN', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)));
        const copy = Text('Digital catalog · Product discovery · Private label', style: TextStyle(color: Colors.white60));
        return compact ? Column(children: [logo, const SizedBox(height: 16), copy]) : Row(children: [logo, const Spacer(), copy]);
      }),
    );
  }
}
