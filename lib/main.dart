import 'package:flutter/material.dart';

void main() => runApp(const EmanExperienceApp());

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0057B8);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman Experience',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blue),
        scaffoldBackgroundColor: const Color(0xFFF5F8FC),
        fontFamily: 'Arial',
      ),
      home: const CatalogHomePage(),
    );
  }
}

class CatalogHomePage extends StatefulWidget {
  const CatalogHomePage({super.key});

  @override
  State<CatalogHomePage> createState() => _CatalogHomePageState();
}

class _CatalogHomePageState extends State<CatalogHomePage> {
  static const blue = Color(0xFF0057B8);
  static const navy = Color(0xFF052A55);
  final Set<String> inquiry = {};

  final products = const [
    Product('Valori Orange', 'Valori', 'Juice Drink', 'assets/images/products/valori_orange.png'),
    Product('Valori Mango', 'Valori', 'Juice Drink', 'assets/images/products/valori_mango.png'),
    Product('Fresh Cocktail', 'Fresh', 'Fruit Beverage', 'assets/images/products/fresh_cocktail.png'),
    Product('Roya Cola', 'Roya', 'Carbonated Drink', 'assets/images/products/roya_cola.png'),
    Product('Frio Cup', 'Frio', 'Cup Beverage', 'assets/images/products/frio_cup.png'),
    Product('Private Label', 'Eman', 'Made for your brand', 'assets/images/products/private_label.png'),
  ];

  void toggleInquiry(String name) {
    setState(() => inquiry.contains(name) ? inquiry.remove(name) : inquiry.add(name));
  }

  void openInquiry() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InquirySheet(items: inquiry.toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _header()),
          SliverToBoxAdapter(child: _hero()),
          SliverToBoxAdapter(child: _sectionTitle()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 72),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;
                final count = width > 1200 ? 3 : width > 720 ? 2 : 1;
                return SliverGrid.builder(
                  itemCount: products.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: count,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: count == 1 ? 1.22 : 1.05,
                  ),
                  itemBuilder: (_, index) {
                    final product = products[index];
                    return ProductCard(
                      product: product,
                      selected: inquiry.contains(product.name),
                      onToggle: () => toggleInquiry(product.name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openInquiry,
        backgroundColor: navy,
        foregroundColor: Colors.white,
        icon: Badge(
          label: Text('${inquiry.length}'),
          isLabelVisible: inquiry.isNotEmpty,
          child: const Icon(Icons.request_quote_outlined),
        ),
        label: const Text('طلب عرض سعر'),
      ),
    );
  }

  Widget _header() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 760;
          return Row(
            children: [
              Image.asset(
                'assets/logos/eman_logo.png',
                height: 42,
                errorBuilder: (_, __, ___) => const _LogoFallback(),
              ),
              const Spacer(),
              if (!compact) ...[
                const _NavText('الرئيسية'),
                const _NavText('العلامات'),
                const _NavText('المنتجات'),
                const _NavText('Private Label'),
                const SizedBox(width: 18),
              ],
              IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
              FilledButton.icon(
                onPressed: openInquiry,
                style: FilledButton.styleFrom(backgroundColor: blue),
                icon: const Icon(Icons.shopping_bag_outlined),
                label: Text(compact ? '${inquiry.length}' : 'طلبات الأسعار ${inquiry.length}'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _hero() {
    return Container(
      margin: const EdgeInsets.all(28),
      constraints: const BoxConstraints(minHeight: 510),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF062C59), Color(0xFF0057B8), Color(0xFF1A78D4)],
        ),
        boxShadow: const [BoxShadow(color: Color(0x33002F67), blurRadius: 40, offset: Offset(0, 18))],
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, c) {
          final compact = c.maxWidth < 850;
          final copy = Padding(
            padding: EdgeInsets.all(compact ? 30 : 56),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('EMAN DIGITAL CATALOG', style: TextStyle(color: Color(0xFFBFDFFF), fontWeight: FontWeight.w800, letterSpacing: 2)),
                const SizedBox(height: 22),
                Text(
                  'اكتشف المنتجات.\nاختر الكميات.\nواطلب عرض السعر.',
                  style: TextStyle(color: Colors.white, fontSize: compact ? 42 : 64, height: 1.08, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 22),
                const Text('كتالوج تفاعلي احترافي لمنتجات Eman مع نظام طلب مباشر للعملاء والموزعين.', style: TextStyle(color: Colors.white70, fontSize: 18, height: 1.6)),
                const SizedBox(height: 30),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    FilledButton.icon(
                      onPressed: () {},
                      style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: navy, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                      icon: const Icon(Icons.grid_view_rounded),
                      label: const Text('تصفح المنتجات'),
                    ),
                    OutlinedButton.icon(
                      onPressed: openInquiry,
                      style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20)),
                      icon: const Icon(Icons.request_quote_outlined),
                      label: const Text('طلب عرض سعر'),
                    ),
                  ],
                ),
              ],
            ),
          );

          final visual = Padding(
            padding: const EdgeInsets.all(34),
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: .10), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white24)),
              child: Image.asset(
                'assets/images/hero/hero_products.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.inventory_2_outlined, size: 150, color: Colors.white54)),
              ),
            ),
          );

          return compact
              ? Column(children: [copy, SizedBox(height: 360, child: visual)])
              : Row(children: [Expanded(flex: 11, child: copy), Expanded(flex: 9, child: visual)]);
        },
      ),
    );
  }

  Widget _sectionTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(28, 32, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('الكتالوج', style: TextStyle(color: navy, fontSize: 38, fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          Text('اختر المنتجات التي تهمك وأضفها إلى طلب عرض السعر.', style: TextStyle(color: Color(0xFF5E7187), fontSize: 17)),
        ],
      ),
    );
  }
}

class Product {
  const Product(this.name, this.brand, this.category, this.image);
  final String name;
  final String brand;
  final String category;
  final String image;
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product, required this.selected, required this.onToggle});
  final Product product;
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
        transform: Matrix4.translationValues(0, hovered ? -8 : 0, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: widget.selected ? const Color(0xFF0057B8) : const Color(0xFFE4EBF3), width: widget.selected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: hovered ? .12 : .05), blurRadius: hovered ? 30 : 16, offset: const Offset(0, 12))],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                color: const Color(0xFFF1F6FC),
                padding: const EdgeInsets.all(22),
                child: Image.asset(widget.product.image, fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Icon(Icons.local_drink_outlined, size: 100, color: Color(0xFF8FB7DF))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.product.brand.toUpperCase(), style: const TextStyle(color: Color(0xFF0057B8), fontWeight: FontWeight.w800, letterSpacing: 1.4)),
                        const SizedBox(height: 7),
                        Text(widget.product.name, style: const TextStyle(color: Color(0xFF052A55), fontSize: 22, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 5),
                        Text(widget.product.category, style: const TextStyle(color: Color(0xFF72869A))),
                      ],
                    ),
                  ),
                  IconButton.filled(
                    onPressed: widget.onToggle,
                    style: IconButton.styleFrom(backgroundColor: widget.selected ? const Color(0xFF0057B8) : const Color(0xFFEAF3FC), foregroundColor: widget.selected ? Colors.white : const Color(0xFF0057B8)),
                    icon: Icon(widget.selected ? Icons.check : Icons.add_shopping_cart_outlined),
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

class InquirySheet extends StatelessWidget {
  const InquirySheet({super.key, required this.items});
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 720,
        constraints: const BoxConstraints(maxHeight: 650),
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Expanded(child: Text('طلب عرض السعر', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF052A55)))),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
            ]),
            const SizedBox(height: 16),
            if (items.isEmpty)
              const Padding(padding: EdgeInsets.symmetric(vertical: 70), child: Center(child: Text('لم تضف أي منتج بعد.')))
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(backgroundColor: Color(0xFFEAF3FC), child: Icon(Icons.inventory_2_outlined, color: Color(0xFF0057B8))),
                    title: Text(items[i], style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: const Text('الكمية تحدد لاحقاً'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: items.isEmpty ? null : () {},
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF0057B8), padding: const EdgeInsets.symmetric(vertical: 20)),
                icon: const Icon(Icons.send_outlined),
                label: const Text('متابعة وإرسال الطلب'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoFallback extends StatelessWidget {
  const _LogoFallback();
  @override
  Widget build(BuildContext context) => const Row(children: [
        CircleAvatar(backgroundColor: Color(0xFF0057B8), child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
        SizedBox(width: 10),
        Text('EMAN', style: TextStyle(color: Color(0xFF052A55), fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 2)),
      ]);
}

class _NavText extends StatelessWidget {
  const _NavText(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(text, style: const TextStyle(color: Color(0xFF294C70), fontWeight: FontWeight.w700)),
      );
}
