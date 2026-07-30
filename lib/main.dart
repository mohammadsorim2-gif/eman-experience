import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const EmanExperienceApp());

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  static const Color primary = Color(0xFF0057B8);
  static const Color navy = Color(0xFF062A50);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman Experience',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: navy,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
          headlineMedium: TextStyle(
            color: navy,
            fontSize: 34,
            fontWeight: FontWeight.w800,
          ),
          titleLarge: TextStyle(
            color: navy,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: const CatalogHomePage(),
    );
  }
}

class BrandInfo {
  const BrandInfo({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.logo,
  });

  final String id;
  final String title;
  final String subtitle;
  final String logo;
}

const brands = <BrandInfo>[
  BrandInfo(
    id: 'all',
    title: 'All Products',
    subtitle: 'Explore the complete Eman portfolio',
    logo: 'assets/logos/Eman logo.png',
  ),
  BrandInfo(
    id: 'valore',
    title: 'Valore',
    subtitle: '10 g instant powder drinks',
    logo: 'assets/brands/valore/Valore Logo.png',
  ),
  BrandInfo(
    id: 'friocups',
    title: 'Frio Cups',
    subtitle: '9 g instant powder drinks',
    logo: 'assets/brands/friocups/Frio Cups Logo.png',
  ),
  BrandInfo(
    id: 'royac',
    title: 'Roya C',
    subtitle: 'Professional 2.5 kg beverage solutions',
    logo: 'assets/brands/royac/ROya c Logo.png',
  ),
  BrandInfo(
    id: 'fullfresh',
    title: 'Full Fresh',
    subtitle: '9 g flavored powder drinks',
    logo: 'assets/brands/fullfresh/Full Fresh Logo.png',
  ),
];

class CatalogHomePage extends StatefulWidget {
  const CatalogHomePage({super.key});

  @override
  State<CatalogHomePage> createState() => _CatalogHomePageState();
}

class _CatalogHomePageState extends State<CatalogHomePage> {
  final Set<String> selectedProducts = <String>{};
  final TextEditingController searchController = TextEditingController();
  List<String> allProductAssets = <String>[];
  String selectedBrand = 'all';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final assets = manifest
        .listAssets()
        .where((path) => path.startsWith('assets/products/'))
        .where((path) {
          final lower = path.toLowerCase();
          return lower.endsWith('.png') ||
              lower.endsWith('.jpg') ||
              lower.endsWith('.jpeg') ||
              lower.endsWith('.webp');
        })
        .toList()
      ..sort();

    if (!mounted) return;
    setState(() {
      allProductAssets = assets;
      loading = false;
    });
  }

  List<String> get visibleProducts {
    final query = searchController.text.trim().toLowerCase();
    return allProductAssets.where((path) {
      final brandMatches =
          selectedBrand == 'all' || path.contains('/$selectedBrand/');
      final queryMatches = query.isEmpty || _displayName(path).toLowerCase().contains(query);
      return brandMatches && queryMatches;
    }).toList();
  }

  String _displayName(String path) {
    final fileName = path.split('/').last.split('.').first;
    final cleaned = fileName
        .replaceAll(RegExp(r'(?i)powder-drink'), '')
        .replaceAll(RegExp(r'(?i)flavored'), '')
        .replaceAll(RegExp(r'(?i)friocups'), '')
        .replaceAll(RegExp(r'(?i)valore'), '')
        .replaceAll(RegExp(r'(?i)full-fresh'), '')
        .replaceAll(RegExp(r'(?i)2-5kg'), '2.5 kg')
        .replaceAll(RegExp(r'(?i)10grams'), '10 g')
        .replaceAll(RegExp(r'(?i)10g'), '10 g')
        .replaceAll(RegExp(r'(?i)9g'), '9 g')
        .replaceAll('-', ' ')
        .replaceAll('_', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleaned.isEmpty) return 'Product';
    return cleaned
        .split(' ')
        .map((word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  String _brandName(String path) {
    if (path.contains('/valore/')) return 'Valore';
    if (path.contains('/friocups/')) return 'Frio Cups';
    if (path.contains('/royac/')) return 'Roya C';
    if (path.contains('/fullfresh/')) return 'Full Fresh';
    return 'Eman';
  }

  void _toggleProduct(String path) {
    setState(() {
      selectedProducts.contains(path)
          ? selectedProducts.remove(path)
          : selectedProducts.add(path);
    });
  }

  void _openInquiry() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InquiryPanel(
        products: selectedProducts.toList(),
        displayName: _displayName,
        onRemove: (path) {
          setState(() => selectedProducts.remove(path));
        },
      ),
    );
  }

  void _scrollToProducts() {
    Scrollable.ensureVisible(
      _productsKey.currentContext!,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeOutCubic,
    );
  }

  final GlobalKey _productsKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: _buildBrandStrip()),
          SliverToBoxAdapter(key: _productsKey, child: _buildCatalogHeading()),
          if (loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (visibleProducts.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('No products found.')),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  final columns = width >= 1350
                      ? 4
                      : width >= 960
                          ? 3
                          : width >= 620
                              ? 2
                              : 1;
                  return SliverGrid.builder(
                    itemCount: visibleProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 18,
                      mainAxisSpacing: 18,
                      childAspectRatio: columns == 1 ? 1.05 : 0.82,
                    ),
                    itemBuilder: (_, index) {
                      final path = visibleProducts[index];
                      return ProductCard(
                        imagePath: path,
                        title: _displayName(path),
                        brand: _brandName(path),
                        selected: selectedProducts.contains(path),
                        onToggle: () => _toggleProduct(path),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openInquiry,
        backgroundColor: EmanExperienceApp.navy,
        foregroundColor: Colors.white,
        icon: Badge(
          isLabelVisible: selectedProducts.isNotEmpty,
          label: Text('${selectedProducts.length}'),
          child: const Icon(Icons.request_quote_outlined),
        ),
        label: const Text('Request Quote'),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 820;
          return Row(
            children: [
              Image.asset(
                'assets/logos/Eman logo.png',
                height: 48,
                errorBuilder: (_, __, ___) => const Text(
                  'EMAN',
                  style: TextStyle(
                    color: EmanExperienceApp.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 28,
                  ),
                ),
              ),
              const Spacer(),
              if (!compact) ...[
                TextButton(onPressed: () {}, child: const Text('Home')),
                TextButton(onPressed: _scrollToProducts, child: const Text('Products')),
                TextButton(onPressed: () {}, child: const Text('Private Label')),
                const SizedBox(width: 10),
              ],
              FilledButton.icon(
                onPressed: _openInquiry,
                icon: const Icon(Icons.request_quote_outlined),
                label: Text(compact ? '${selectedProducts.length}' : 'Quote List ${selectedProducts.length}'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHero() {
    final heroProducts = allProductAssets.take(3).toList();
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          colors: [Color(0xFFB6D9FF), Color(0xFF0057B8)],
        ),
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: 520),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF041F3D), Color(0xFF0057B8), Color(0xFF2585E5)],
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            final copy = Padding(
              padding: EdgeInsets.all(compact ? 30 : 56),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'EMAN DIGITAL EXPERIENCE',
                    style: TextStyle(
                      color: Color(0xFFBBDDFF),
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'A smarter way\nto discover flavor.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.02,
                      fontSize: compact ? 46 : 68,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'Explore our complete beverage portfolio and build your quotation request in seconds.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton.icon(
                        onPressed: _scrollToProducts,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: EmanExperienceApp.navy,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        ),
                        icon: const Icon(Icons.grid_view_rounded),
                        label: const Text('Explore Products'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _openInquiry,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white54),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        ),
                        icon: const Icon(Icons.request_quote_outlined),
                        label: const Text('Request a Quote'),
                      ),
                    ],
                  ),
                ],
              ),
            );

            final visual = _HeroProductVisual(products: heroProducts);
            return compact
                ? Column(children: [copy, SizedBox(height: 390, child: visual)])
                : Row(
                    children: [
                      Expanded(flex: 11, child: copy),
                      Expanded(flex: 9, child: visual),
                    ],
                  );
          },
        ),
      ),
    );
  }

  Widget _buildBrandStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 38),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Our Brands', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 18),
          SizedBox(
            height: 132,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (_, index) {
                final brand = brands[index];
                final active = selectedBrand == brand.id;
                return InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => setState(() => selectedBrand = brand.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 220,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFFE7F2FF) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: active
                            ? EmanExperienceApp.primary
                            : const Color(0xFFE2EAF3),
                        width: active ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(17),
                          ),
                          child: Image.asset(brand.logo, fit: BoxFit.contain),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                brand.title,
                                style: const TextStyle(
                                  color: EmanExperienceApp.navy,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                brand.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF6D8094),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogHeading() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final title = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Product Catalog', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 7),
              Text(
                '${visibleProducts.length} products available',
                style: const TextStyle(color: Color(0xFF718397), fontSize: 16),
              ),
            ],
          );
          final search = SizedBox(
            width: compact ? double.infinity : 360,
            child: TextField(
              controller: searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search flavor or product...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          );
          return compact
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 18), search])
              : Row(children: [Expanded(child: title), search]);
        },
      ),
    );
  }
}

class _HeroProductVisual extends StatelessWidget {
  const _HeroProductVisual({required this.products});

  final List<String> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Icon(Icons.local_drink_outlined, size: 180, color: Colors.white30),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 390,
          height: 390,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white24),
          ),
        ),
        for (var index = 0; index < products.length; index++)
          Transform.translate(
            offset: Offset((index - 1) * 92, index == 1 ? -14 : 35),
            child: Transform.rotate(
              angle: (index - 1) * 0.10,
              child: SizedBox(
                width: index == 1 ? 210 : 175,
                height: index == 1 ? 340 : 300,
                child: Image.asset(products[index], fit: BoxFit.contain),
              ),
            ),
          ),
      ],
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.brand,
    required this.selected,
    required this.onToggle,
  });

  final String imagePath;
  final String title;
  final String brand;
  final bool selected;
  final VoidCallback onToggle;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        transform: Matrix4.translationValues(0, hovered ? -7 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: widget.selected
                ? EmanExperienceApp.primary
                : const Color(0xFFE1E9F2),
            width: widget.selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: hovered ? 0.12 : 0.05),
              blurRadius: hovered ? 28 : 14,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF8FBFF), Color(0xFFEAF3FC)],
                  ),
                ),
                child: Hero(
                  tag: widget.imagePath,
                  child: Image.asset(widget.imagePath, fit: BoxFit.contain),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.brand.toUpperCase(),
                          style: const TextStyle(
                            color: EmanExperienceApp.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          widget.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: EmanExperienceApp.navy,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: widget.onToggle,
                    style: IconButton.styleFrom(
                      backgroundColor: widget.selected
                          ? EmanExperienceApp.primary
                          : const Color(0xFFE7F2FF),
                      foregroundColor: widget.selected
                          ? Colors.white
                          : EmanExperienceApp.primary,
                    ),
                    icon: Icon(widget.selected ? Icons.check : Icons.add),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InquiryPanel extends StatefulWidget {
  const InquiryPanel({
    super.key,
    required this.products,
    required this.displayName,
    required this.onRemove,
  });

  final List<String> products;
  final String Function(String) displayName;
  final ValueChanged<String> onRemove;

  @override
  State<InquiryPanel> createState() => _InquiryPanelState();
}

class _InquiryPanelState extends State<InquiryPanel> {
  late final List<String> items = List<String>.from(widget.products);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 760,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.86,
        ),
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Request a Quote',
                    style: TextStyle(
                      color: EmanExperienceApp.navy,
                      fontSize: 29,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 14),
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Center(child: Text('Your quote list is empty.')),
              )
            else ...[
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, index) {
                    final path = items[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 6),
                      leading: SizedBox(
                        width: 58,
                        child: Image.asset(path, fit: BoxFit.contain),
                      ),
                      title: Text(widget.displayName(path)),
                      trailing: IconButton(
                        onPressed: () {
                          widget.onRemove(path);
                          setState(() => items.remove(path));
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Company name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email or phone number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('Send Inquiry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
