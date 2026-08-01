import 'package:flutter/material.dart';

class EmanRemoteApp extends StatelessWidget {
  const EmanRemoteApp({super.key});

  static const _navy = Color(0xFF06324F);
  static const _blue = Color(0xFF0878C9);
  static const _cream = Color(0xFFFFF7E8);
  static const _raw =
      'https://raw.githubusercontent.com/mohammadsorim2-gif/eman-experience/402379e4e79d5a585fc704baeadb78497be94d33';

  static String media(String path) => '$_raw/$path';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAN — Global Beverage Manufacturer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: _blue),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Arial',
      ),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  static const products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-banana-flavored-powder-drink-friocups.png',
    'assets/products/fullfresh/Full-fresh-9g-drink-powder-strawberry.png',
    'assets/products/royac/orange-powder-drink-2-5kg.png',
  ];

  static const brands = [
    'assets/brands/valore/Valore Logo.png',
    'assets/brands/friocups/Frio Cups Logo.png',
    'assets/brands/royac/ROya c Logo.png',
    'assets/brands/fullfresh/Full Fresh Logo.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 84,
            title: _RemoteImage(
              EmanRemoteApp.media('assets/logos/Eman logo.png'),
              height: 50,
            ),
            actions: [
              if (MediaQuery.sizeOf(context).width > 800) ...[
                TextButton(onPressed: () {}, child: const Text('Products')),
                TextButton(onPressed: () {}, child: const Text('Private Label')),
                TextButton(onPressed: () {}, child: const Text('Export')),
              ],
              const SizedBox(width: 16),
            ],
          ),
          SliverToBoxAdapter(child: _hero(context)),
          SliverToBoxAdapter(child: _brands(context)),
          SliverToBoxAdapter(child: _products(context)),
          const SliverToBoxAdapter(child: _PrivateLabel()),
          const SliverToBoxAdapter(child: _ExportSection()),
          const SliverToBoxAdapter(child: _ContactSection()),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF0FAFF), Color(0xFFFFF3D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1260),
          child: LayoutBuilder(
            builder: (context, c) {
              final compact = c.maxWidth < 900;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'GLOBAL BEVERAGE MANUFACTURER',
                    style: TextStyle(
                      color: EmanRemoteApp._blue,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.6,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Flavor made\nfor the world.',
                    style: TextStyle(
                      fontSize: compact ? 54 : 76,
                      height: .96,
                      fontWeight: FontWeight.w900,
                      color: EmanRemoteApp._navy,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'EMAN creates high-performing powdered beverages for distributors, wholesalers, foodservice and private-label partners.',
                    style: TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF5B6D79)),
                  ),
                  const SizedBox(height: 30),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      FilledButton(onPressed: () {}, child: const Text('Explore products')),
                      OutlinedButton(onPressed: () {}, child: const Text('Private Label')),
                    ],
                  ),
                ],
              );
              final visual = Container(
                height: compact ? 470 : 600,
                decoration: BoxDecoration(
                  color: EmanRemoteApp._cream,
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: const [
                    BoxShadow(color: Color(0x18000000), blurRadius: 40, offset: Offset(0, 18)),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      left: 12,
                      bottom: 12,
                      child: _RemoteImage(EmanRemoteApp.media(products[2]), width: compact ? 150 : 210),
                    ),
                    _RemoteImage(EmanRemoteApp.media(products[0]), width: compact ? 220 : 300),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: _RemoteImage(EmanRemoteApp.media(products[1]), width: compact ? 150 : 210),
                    ),
                  ],
                ),
              );
              if (compact) {
                return Column(children: [copy, const SizedBox(height: 42), visual]);
              }
              return SizedBox(
                height: 650,
                child: Row(
                  children: [
                    Expanded(child: copy),
                    const SizedBox(width: 56),
                    Expanded(child: visual),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _brands(BuildContext context) {
    return _section(
      title: 'Our brands',
      subtitle: 'Four distinctive brands built for different channels, markets and consumer moments.',
      child: LayoutBuilder(
        builder: (_, c) {
          final w = c.maxWidth > 850 ? (c.maxWidth - 54) / 4 : (c.maxWidth - 18) / 2;
          return Wrap(
            spacing: 18,
            runSpacing: 18,
            children: brands
                .map(
                  (path) => Container(
                    width: w,
                    height: 160,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5EBEF)),
                    ),
                    child: _RemoteImage(EmanRemoteApp.media(path), fit: BoxFit.contain),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _products(BuildContext context) {
    return _section(
      background: const Color(0xFFF4FAFD),
      title: 'Featured products',
      subtitle: 'Real products, real flavors and flexible formats for international distribution.',
      child: LayoutBuilder(
        builder: (_, c) {
          final columns = c.maxWidth > 950 ? 3 : c.maxWidth > 600 ? 2 : 1;
          final w = (c.maxWidth - (columns - 1) * 20) / columns;
          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: products
                .map(
                  (path) => Container(
                    width: w,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      children: [
                        SizedBox(height: 260, child: _RemoteImage(EmanRemoteApp.media(path), fit: BoxFit.contain)),
                        const SizedBox(height: 16),
                        const Text('Instant powdered drink', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: EmanRemoteApp._navy)),
                        const SizedBox(height: 8),
                        const Text('Wholesale and export format', style: TextStyle(color: Color(0xFF697B87))),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  Widget _section({required String title, required String subtitle, required Widget child, Color background = Colors.white}) {
    return Container(
      color: background,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 92),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1260),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 46, height: 1.05, fontWeight: FontWeight.w900, color: EmanRemoteApp._navy)),
              const SizedBox(height: 14),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Text(subtitle, style: const TextStyle(fontSize: 17, height: 1.6, color: Color(0xFF657985))),
              ),
              const SizedBox(height: 46),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivateLabel extends StatelessWidget {
  const _PrivateLabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 92),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1260),
          child: Container(
            padding: const EdgeInsets.all(42),
            decoration: BoxDecoration(color: EmanRemoteApp._navy, borderRadius: BorderRadius.circular(34)),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Private Label', style: TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900)),
                SizedBox(height: 14),
                Text('From formulation and packaging to scalable production and export support.', style: TextStyle(color: Colors.white70, fontSize: 18)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportSection extends StatelessWidget {
  const _ExportSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EmanRemoteApp._cream,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 92),
      child: const Center(
        child: Text('Built for global distribution', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w900, color: EmanRemoteApp._navy)),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: EmanRemoteApp._navy,
      padding: const EdgeInsets.all(56),
      child: const Center(
        child: Text('Let’s create your next beverage line.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 38, fontWeight: FontWeight.w900)),
      ),
    );
  }
}

class _RemoteImage extends StatelessWidget {
  const _RemoteImage(this.url, {this.width, this.height, this.fit = BoxFit.contain});

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      Uri.encodeFull(url),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported_outlined, size: 42, color: Color(0xFFB7C5CE)),
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
