import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class AdvancedProductCatalog extends StatefulWidget {
  const AdvancedProductCatalog({super.key});

  @override
  State<AdvancedProductCatalog> createState() => _AdvancedProductCatalogState();
}

class _AdvancedProductCatalogState extends State<AdvancedProductCatalog> {
  String query = '';
  String selectedBrand = 'all';

  static const products = <_Product>[
    _Product(
      brand: 'Frio Cups',
      flavorKey: 'orange',
      image: 'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
      weight: '9 g',
      format: 'Single serve',
      moq: '1 container',
    ),
    _Product(
      brand: 'Frio Cups',
      flavorKey: 'mango',
      image: 'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
      weight: '9 g',
      format: 'Single serve',
      moq: '1 container',
    ),
    _Product(
      brand: 'Frio Cups',
      flavorKey: 'berries',
      image: 'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
      weight: '9 g',
      format: 'Single serve',
      moq: '1 container',
    ),
    _Product(
      brand: 'Frio Cups',
      flavorKey: 'banana',
      image: 'assets/products/friocups/9g-banana-flavored-powder-drink-friocups.png',
      weight: '9 g',
      format: 'Single serve',
      moq: '1 container',
    ),
    _Product(
      brand: 'Full Fresh',
      flavorKey: 'strawberry',
      image: 'assets/products/fullfresh/Full-fresh-9g-drink-powder-strawberry.png',
      weight: '9 g',
      format: 'Single serve',
      moq: '1 container',
    ),
    _Product(
      brand: 'Valore',
      flavorKey: 'orange',
      image: 'assets/products/valore/orange-flavored-powder-drink-valore-10grams.png',
      weight: '10 g',
      format: 'Single serve',
      moq: '1 container',
    ),
  ];

  String t(BuildContext context, String key) {
    final code = AppLocaleScope.of(context).languageCode;
    final values = <String, Map<String, String>>{
      'title': {
        'tr': 'Global Ürün Kataloğu',
        'en': 'Global Product Catalog',
        'ar': 'كاتالوج المنتجات العالمي',
        'es': 'Catálogo global de productos',
        'pt': 'Catálogo global de produtos',
        'ru': 'Глобальный каталог продукции',
        'fr': 'Catalogue mondial des produits',
        'de': 'Globaler Produktkatalog',
      },
      'subtitle': {
        'tr': 'Marka, aroma ve ambalaj seçeneklerini inceleyin; ürün detaylarını açın ve doğrudan teklif talebi oluşturun.',
        'en': 'Explore brands, flavors and packaging options, open product details and request a quote directly.',
        'ar': 'استعرض العلامات والنكهات وخيارات التعبئة، وافتح تفاصيل المنتج واطلب عرض سعر مباشرة.',
        'es': 'Explore marcas, sabores y envases, vea los detalles y solicite una cotización.',
        'pt': 'Explore marcas, sabores e embalagens, veja detalhes e solicite uma cotação.',
        'ru': 'Изучайте бренды, вкусы и упаковку, открывайте детали и запрашивайте цену.',
        'fr': 'Explorez marques, saveurs et emballages, consultez les détails et demandez un devis.',
        'de': 'Marken, Geschmacksrichtungen und Verpackungen entdecken und direkt ein Angebot anfragen.',
      },
      'search': {
        'tr': 'Ürün, aroma veya marka ara',
        'en': 'Search product, flavor or brand',
        'ar': 'ابحث عن منتج أو نكهة أو علامة',
        'es': 'Buscar producto, sabor o marca',
        'pt': 'Pesquisar produto, sabor ou marca',
        'ru': 'Поиск продукта, вкуса или бренда',
        'fr': 'Rechercher un produit, une saveur ou une marque',
        'de': 'Produkt, Geschmack oder Marke suchen',
      },
      'all': {'tr': 'Tümü', 'en': 'All', 'ar': 'الكل', 'es': 'Todos', 'pt': 'Todos', 'ru': 'Все', 'fr': 'Tous', 'de': 'Alle'},
      'details': {'tr': 'Detayları Gör', 'en': 'View Details', 'ar': 'عرض التفاصيل', 'es': 'Ver detalles', 'pt': 'Ver detalhes', 'ru': 'Подробнее', 'fr': 'Voir les détails', 'de': 'Details ansehen'},
      'quote': {'tr': 'Teklif Talebi', 'en': 'Request Quote', 'ar': 'طلب عرض سعر', 'es': 'Solicitar cotización', 'pt': 'Solicitar cotação', 'ru': 'Запросить цену', 'fr': 'Demander un devis', 'de': 'Angebot anfragen'},
      'weight': {'tr': 'Net ağırlık', 'en': 'Net weight', 'ar': 'الوزن الصافي', 'es': 'Peso neto', 'pt': 'Peso líquido', 'ru': 'Вес нетто', 'fr': 'Poids net', 'de': 'Nettogewicht'},
      'format': {'tr': 'Ambalaj formatı', 'en': 'Packaging format', 'ar': 'نوع العبوة', 'es': 'Formato de envase', 'pt': 'Formato da embalagem', 'ru': 'Формат упаковки', 'fr': 'Format d’emballage', 'de': 'Verpackungsformat'},
      'moq': {'tr': 'Minimum sipariş', 'en': 'Minimum order', 'ar': 'الحد الأدنى للطلب', 'es': 'Pedido mínimo', 'pt': 'Pedido mínimo', 'ru': 'Минимальный заказ', 'fr': 'Commande minimale', 'de': 'Mindestbestellmenge'},
      'powder': {'tr': 'Toz İçecek', 'en': 'Powder Drink', 'ar': 'مشروب بودرة', 'es': 'Bebida en polvo', 'pt': 'Bebida em pó', 'ru': 'Порошковый напиток', 'fr': 'Boisson en poudre', 'de': 'Getränkepulver'},
      'orange': {'tr': 'Portakal', 'en': 'Orange', 'ar': 'برتقال', 'es': 'Naranja', 'pt': 'Laranja', 'ru': 'Апельсин', 'fr': 'Orange', 'de': 'Orange'},
      'mango': {'tr': 'Mango', 'en': 'Mango', 'ar': 'مانجو', 'es': 'Mango', 'pt': 'Manga', 'ru': 'Манго', 'fr': 'Mangue', 'de': 'Mango'},
      'berries': {'tr': 'Orman Meyveleri', 'en': 'Berries', 'ar': 'توت مشكل', 'es': 'Frutos rojos', 'pt': 'Frutas vermelhas', 'ru': 'Ягоды', 'fr': 'Fruits rouges', 'de': 'Beeren'},
      'banana': {'tr': 'Muz', 'en': 'Banana', 'ar': 'موز', 'es': 'Banana', 'pt': 'Banana', 'ru': 'Банан', 'fr': 'Banane', 'de': 'Banane'},
      'strawberry': {'tr': 'Çilek', 'en': 'Strawberry', 'ar': 'فراولة', 'es': 'Fresa', 'pt': 'Morango', 'ru': 'Клубника', 'fr': 'Fraise', 'de': 'Erdbeere'},
      'singleServe': {'tr': 'Tek kullanımlık saşe', 'en': 'Single-serve sachet', 'ar': 'ظرف فردي', 'es': 'Sobre individual', 'pt': 'Sachê individual', 'ru': 'Порционный саше', 'fr': 'Sachet individuel', 'de': 'Einzelportion'},
      'container': {'tr': '1 konteyner', 'en': '1 container', 'ar': 'حاوية واحدة', 'es': '1 contenedor', 'pt': '1 contêiner', 'ru': '1 контейнер', 'fr': '1 conteneur', 'de': '1 Container'},
      'noResults': {'tr': 'Sonuç bulunamadı', 'en': 'No products found', 'ar': 'لا توجد نتائج', 'es': 'No se encontraron productos', 'pt': 'Nenhum produto encontrado', 'ru': 'Продукты не найдены', 'fr': 'Aucun produit trouvé', 'de': 'Keine Produkte gefunden'},
    };
    return values[key]?[code] ?? values[key]?['tr'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final brands = ['all', ...{for (final product in products) product.brand}];
    final visibleProducts = products.where((product) {
      final matchesBrand = selectedBrand == 'all' || product.brand == selectedBrand;
      final haystack = '${product.brand} ${t(context, product.flavorKey)}'.toLowerCase();
      return matchesBrand && haystack.contains(query.toLowerCase());
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Text(
          t(context, 'title'),
          style: const TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w900,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 10),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850),
          child: Text(
            t(context, 'subtitle'),
            style: const TextStyle(fontSize: 17, height: 1.6, color: Color(0xFF607482)),
          ),
        ),
        const SizedBox(height: 28),
        TextField(
          onChanged: (value) => setState(() => query = value),
          decoration: InputDecoration(
            hintText: t(context, 'search'),
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: brands.map((brand) {
              final selected = selectedBrand == brand;
              return Padding(
                padding: const EdgeInsetsDirectional.only(end: 10),
                child: ChoiceChip(
                  selected: selected,
                  label: Text(brand == 'all' ? t(context, 'all') : brand),
                  onSelected: (_) => setState(() => selectedBrand = brand),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 26),
        if (visibleProducts.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Center(
              child: Column(
                children: [
                  const Icon(Icons.search_off, size: 64, color: Color(0xFF9AABB6)),
                  const SizedBox(height: 14),
                  Text(t(context, 'noResults'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1180
                  ? 3
                  : constraints.maxWidth >= 700
                      ? 2
                      : 1;
              final width = (constraints.maxWidth - ((columns - 1) * 18)) / columns;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: visibleProducts.map((product) {
                  return SizedBox(
                    width: width,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => _openProduct(context, product),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 260,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F9FC),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Hero(
                                  tag: product.image,
                                  child: Image.asset(
                                    product.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => const Icon(
                                      Icons.local_drink,
                                      size: 90,
                                      color: EmanExperienceApp.blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(product.brand, style: const TextStyle(color: EmanExperienceApp.blue, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text(
                                '${t(context, product.flavorKey)} ${t(context, 'powder')}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  Chip(label: Text(product.weight)),
                                  Chip(label: Text(t(context, 'singleServe'))),
                                ],
                              ),
                              const SizedBox(height: 18),
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _openProduct(context, product),
                                  icon: const Icon(Icons.open_in_new),
                                  label: Text(t(context, 'details')),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
      ],
    );
  }

  void _openProduct(BuildContext context, _Product product) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: .88,
          minChildSize: .65,
          maxChildSize: .96,
          builder: (context, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(28),
                children: [
                  Center(
                    child: Container(
                      width: 54,
                      height: 5,
                      decoration: BoxDecoration(color: const Color(0xFFD9E2E8), borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final stacked = constraints.maxWidth < 760;
                      final image = Container(
                        height: 380,
                        decoration: BoxDecoration(color: const Color(0xFFF5F9FC), borderRadius: BorderRadius.circular(28)),
                        child: Hero(
                          tag: product.image,
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.contain,
                            errorBuilder: (_, _, _) => const Icon(Icons.local_drink, size: 120, color: EmanExperienceApp.blue),
                          ),
                        ),
                      );
                      final details = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.brand, style: const TextStyle(color: EmanExperienceApp.blue, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 8),
                          Text(
                            '${t(context, product.flavorKey)} ${t(context, 'powder')}',
                            style: const TextStyle(fontSize: 36, height: 1.05, fontWeight: FontWeight.w900, color: EmanExperienceApp.navy),
                          ),
                          const SizedBox(height: 26),
                          _SpecRow(label: t(context, 'weight'), value: product.weight),
                          _SpecRow(label: t(context, 'format'), value: t(context, 'singleServe')),
                          _SpecRow(label: t(context, 'moq'), value: t(context, 'container')),
                          const SizedBox(height: 28),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.request_quote_outlined),
                              label: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                child: Text(t(context, 'quote')),
                              ),
                            ),
                          ),
                        ],
                      );
                      if (stacked) {
                        return Column(children: [image, const SizedBox(height: 28), details]);
                      }
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: image),
                          const SizedBox(width: 34),
                          Expanded(child: details),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SpecRow extends StatelessWidget {
  const _SpecRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6C7D88)))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, color: EmanExperienceApp.navy)),
        ],
      ),
    );
  }
}

class _Product {
  const _Product({
    required this.brand,
    required this.flavorKey,
    required this.image,
    required this.weight,
    required this.format,
    required this.moq,
  });

  final String brand;
  final String flavorKey;
  final String image;
  final String weight;
  final String format;
  final String moq;
}
