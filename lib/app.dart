import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmanExperienceApp extends StatefulWidget {
  const EmanExperienceApp({super.key});

  @override
  State<EmanExperienceApp> createState() => _EmanExperienceAppState();
}

class _EmanExperienceAppState extends State<EmanExperienceApp> {
  String language = 'en';

  @override
  void initState() {
    super.initState();
    _restore();
  }

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('eman_language');
    if (saved != null && Copy.languages.contains(saved) && mounted) {
      setState(() => language = saved);
    }
  }

  Future<void> _changeLanguage(String value) async {
    setState(() => language = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('eman_language', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale(language),
      supportedLocales: Copy.languages.map(Locale.new).toList(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFBF5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0878C9)),
        fontFamily: 'Arial',
      ),
      home: Directionality(
        textDirection: language == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: HomePage(language: language, onLanguageChanged: _changeLanguage),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.language, required this.onLanguageChanged});

  final String language;
  final ValueChanged<String> onLanguageChanged;

  Copy get t => Copy(language);

  static const logo = 'assets/logos/Eman logo.png';
  static const brands = [
    'assets/brands/valore/Valore Logo.png',
    'assets/brands/friocups/Frio Cups Logo.png',
    'assets/brands/royac/ROya c Logo.png',
    'assets/brands/fullfresh/Full Fresh Logo.png',
  ];
  static const products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-coconut-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-grape-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-banana-flavored-powder-drink-friocups.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 92,
            backgroundColor: Colors.white.withValues(alpha: .97),
            surfaceTintColor: Colors.transparent,
            title: Image.asset(logo, height: 54, fit: BoxFit.contain),
            actions: [
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: language,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  items: const {
                    'en': 'EN', 'tr': 'TR', 'ar': 'AR',
                    'es': 'ES', 'pt': 'PT', 'ru': 'RU',
                  }.entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value))).toList(),
                  onChanged: (value) { if (value != null) onLanguageChanged(value); },
                ),
              ),
              const SizedBox(width: 12),
            ],
          ),
          SliverToBoxAdapter(child: _hero(context)),
          SliverToBoxAdapter(child: _brands(context)),
          SliverToBoxAdapter(child: _products(context)),
          SliverToBoxAdapter(child: _privateLabel(context)),
          SliverToBoxAdapter(child: _export(context)),
          SliverToBoxAdapter(child: _contact(context)),
          SliverToBoxAdapter(child: _footer()),
        ],
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4FBFF), Color(0xFFFFF6E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(builder: (context, c) {
            final compact = c.maxWidth < 900;
            final text = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t['eyebrow'], style: const TextStyle(color: Color(0xFF0878C9), fontWeight: FontWeight.w800, letterSpacing: 1.7)),
                const SizedBox(height: 20),
                Text(t['hero'], style: TextStyle(fontSize: compact ? 48 : 74, height: .98, fontWeight: FontWeight.w900, color: const Color(0xFF07304F))),
                const SizedBox(height: 24),
                Text(t['heroBody'], style: const TextStyle(fontSize: 18, height: 1.65, color: Color(0xFF536674))),
                const SizedBox(height: 30),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  FilledButton(onPressed: () {}, child: Text(t['explore'])),
                  OutlinedButton(onPressed: () {}, child: Text(t['privateLabel'])),
                ]),
              ],
            );
            final visual = Container(
              height: compact ? 500 : 620,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(36), boxShadow: const [BoxShadow(blurRadius: 40, color: Color(0x18000000), offset: Offset(0, 18))]),
              child: Stack(alignment: Alignment.center, children: [
                Positioned.fill(child: ClipRRect(borderRadius: BorderRadius.circular(36), child: const DecoratedBox(decoration: BoxDecoration(gradient: RadialGradient(colors: [Color(0xFFFFE8A6), Color(0xFFFFF8E8)]))))),
                Positioned(left: 18, bottom: 18, child: Image.asset(products[2], width: compact ? 175 : 220)),
                Image.asset(products[0], width: compact ? 230 : 300),
                Positioned(right: 12, bottom: 18, child: Image.asset(products[1], width: compact ? 175 : 220)),
              ]),
            );
            if (compact) return Column(children: [text, const SizedBox(height: 42), visual]);
            return SizedBox(height: 650, child: Row(children: [Expanded(child: text), const SizedBox(width: 58), Expanded(child: visual)]));
          }),
        ),
      ),
    );
  }

  Widget _brands(BuildContext context) => _section(
    context,
    title: t['brands'],
    subtitle: t['brandsBody'],
    child: LayoutBuilder(builder: (_, c) {
      final width = c.maxWidth > 850 ? (c.maxWidth - 54) / 4 : (c.maxWidth - 18) / 2;
      return Wrap(spacing: 18, runSpacing: 18, children: brands.map((path) => Container(
        width: width,
        height: 160,
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFE7EBEE))),
        child: Image.asset(path, fit: BoxFit.contain),
      )).toList());
    }),
  );

  Widget _products(BuildContext context) => _section(
    context,
    title: t['products'],
    subtitle: t['productsBody'],
    background: const Color(0xFFF5FAFD),
    child: LayoutBuilder(builder: (_, c) {
      final columns = c.maxWidth > 950 ? 3 : c.maxWidth > 600 ? 2 : 1;
      final width = (c.maxWidth - (columns - 1) * 20) / columns;
      return Wrap(spacing: 20, runSpacing: 20, children: products.map((path) => Container(
        width: width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
        child: Column(children: [
          SizedBox(height: 260, child: Image.asset(path, fit: BoxFit.contain)),
          const SizedBox(height: 16),
          Text(t['instant'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF07304F))),
          const SizedBox(height: 8),
          Text(t['singleServe'], style: const TextStyle(color: Color(0xFF677986))),
        ]),
      )).toList());
    }),
  );

  Widget _privateLabel(BuildContext context) => _section(
    context,
    title: t['privateLabel'],
    subtitle: t['privateBody'],
    child: Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(color: const Color(0xFF07304F), borderRadius: BorderRadius.circular(34)),
      child: LayoutBuilder(builder: (_, c) => Wrap(spacing: 18, runSpacing: 18, children: [
        _feature(Icons.science_outlined, t['formula']),
        _feature(Icons.palette_outlined, t['packaging']),
        _feature(Icons.precision_manufacturing_outlined, t['production']),
        _feature(Icons.public, t['exportReady']),
      ])),
    ),
  );

  Widget _feature(IconData icon, String label) => Container(
    width: 245,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(color: Colors.white.withValues(alpha: .08), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)),
    child: Row(children: [Icon(icon, color: const Color(0xFFFFCF65)), const SizedBox(width: 14), Expanded(child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))]),
  );

  Widget _export(BuildContext context) => _section(
    context,
    title: t['export'],
    subtitle: t['exportBody'],
    background: const Color(0xFFFFF7EA),
    child: Wrap(spacing: 18, runSpacing: 18, alignment: WrapAlignment.center, children: [
      _stat('20+', t['markets']), _stat('30+', t['flavors']), _stat('4', t['brandsCount']), _stat('6', t['languages']),
    ]),
  );

  Widget _stat(String value, String label) => Container(
    width: 220,
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
    child: Column(children: [Text(value, style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Color(0xFF0878C9))), Text(label, textAlign: TextAlign.center)]),
  );

  Widget _contact(BuildContext context) => _section(
    context,
    title: t['contact'],
    subtitle: t['contactBody'],
    child: Center(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.arrow_outward), label: Text(t['startProject']))),
  );

  Widget _section(BuildContext context, {required String title, required String subtitle, required Widget child, Color background = Colors.white}) => Container(
    color: background,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 96),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1280), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 46, height: 1.05, fontWeight: FontWeight.w900, color: Color(0xFF07304F))),
      const SizedBox(height: 14),
      ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: Text(subtitle, style: const TextStyle(fontSize: 17, height: 1.6, color: Color(0xFF657985)))),
      const SizedBox(height: 46),
      child,
    ]))),
  );

  Widget _footer() => Container(
    color: const Color(0xFF05283F),
    padding: const EdgeInsets.all(42),
    child: Row(children: [Image.asset(logo, height: 50), const Spacer(), Text(t['footer'], style: const TextStyle(color: Colors.white70))]),
  );
}

class Copy {
  Copy(this.language);
  final String language;
  static const languages = ['en', 'tr', 'ar', 'es', 'pt', 'ru'];

  String operator [](String key) => (_data[language] ?? _data['en']!)[key] ?? key;

  static const Map<String, Map<String, String>> _data = {
    'en': {'eyebrow':'GLOBAL BEVERAGE MANUFACTURER','hero':'Flavor made for the world.','heroBody':'EMAN creates colorful, high-performing powdered beverages for retail, foodservice, distributors and private-label partners.','explore':'Explore products','privateLabel':'Private Label','brands':'Our brands','brandsBody':'Four distinctive brands built for different channels, markets and consumer moments.','products':'Featured products','productsBody':'Real products, real flavors and flexible formats for everyday refreshment.','instant':'Instant powdered drink','singleServe':'Single-serve retail format','privateBody':'From formulation to shelf-ready packaging, we build complete beverage programs for your brand.','formula':'Custom formulation','packaging':'Packaging design','production':'Scalable production','exportReady':'Export support','export':'Made to travel','exportBody':'A multilingual, export-focused partner prepared for international distribution and long-term growth.','markets':'Markets served','flavors':'Flavor concepts','brandsCount':'Portfolio brands','languages':'Website languages','contact':'Let’s create your next beverage line.','contactBody':'Tell us about your market, target format and business goals.','startProject':'Start a project','footer':'EMAN · Beverage innovation and manufacturing'},
    'tr': {'eyebrow':'KÜRESEL İÇECEK ÜRETİCİSİ','hero':'Dünya için üretilen lezzet.','heroBody':'EMAN; perakende, horeca, distribütör ve private label ortakları için renkli ve güçlü toz içecekler üretir.','explore':'Ürünleri keşfet','privateLabel':'Özel Marka','brands':'Markalarımız','brandsBody':'Farklı kanallar ve pazarlar için geliştirilen dört güçlü marka.','products':'Öne çıkan ürünler','productsBody':'Günlük ferahlık için gerçek ürünler, gerçek aromalar ve esnek formatlar.','instant':'Toz içecek','singleServe':'Tek kullanımlık perakende formatı','privateBody':'Formülden raf hazır ambalaja kadar markanız için eksiksiz içecek programları oluşturuyoruz.','formula':'Özel formül','packaging':'Ambalaj tasarımı','production':'Ölçeklenebilir üretim','exportReady':'İhracat desteği','export':'Dünyaya hazır','exportBody':'Uluslararası dağıtım ve uzun vadeli büyüme için çok dilli, ihracat odaklı ortak.','markets':'Hizmet verilen pazar','flavors':'Aroma konsepti','brandsCount':'Portföy markası','languages':'Site dili','contact':'Yeni içecek serinizi birlikte oluşturalım.','contactBody':'Pazarınızı, formatınızı ve hedeflerinizi bize anlatın.','startProject':'Projeye başla','footer':'EMAN · İçecek inovasyonu ve üretimi'},
    'ar': {'eyebrow':'مصنّع مشروبات عالمي','hero':'نكهات صُنعت للعالم.','heroBody':'تطوّر EMAN مشروبات بودرة ملونة وعالية الجودة لقطاع التجزئة والمطاعم والموزعين وشركاء العلامة الخاصة.','explore':'استكشف المنتجات','privateLabel':'العلامة الخاصة','brands':'علاماتنا التجارية','brandsBody':'أربع علامات مميزة مصممة لقنوات وأسواق وتجارب استهلاكية مختلفة.','products':'منتجات مختارة','productsBody':'منتجات حقيقية ونكهات متنوعة وأحجام مرنة للانتعاش اليومي.','instant':'مشروب بودرة سريع التحضير','singleServe':'عبوة فردية للبيع بالتجزئة','privateBody':'من تطوير الوصفة إلى التغليف الجاهز للعرض، نبني برنامج مشروبات متكاملًا لعلامتك.','formula':'تطوير وصفة خاصة','packaging':'تصميم التغليف','production':'إنتاج قابل للتوسع','exportReady':'دعم التصدير','export':'مصمم للأسواق العالمية','exportBody':'شريك متعدد اللغات يركز على التصدير والتوزيع الدولي والنمو طويل الأمد.','markets':'سوقًا نخدمه','flavors':'فكرة نكهة','brandsCount':'علامات تجارية','languages':'لغات الموقع','contact':'لنصنع خط مشروباتك القادم.','contactBody':'أخبرنا عن سوقك والحجم المطلوب وأهداف مشروعك.','startProject':'ابدأ مشروعك','footer':'EMAN · ابتكار وتصنيع المشروبات'},
    'es': {'eyebrow':'FABRICANTE GLOBAL DE BEBIDAS','hero':'Sabor creado para el mundo.','heroBody':'EMAN crea bebidas en polvo coloridas para retail, foodservice, distribuidores y marcas privadas.','explore':'Ver productos','privateLabel':'Marca privada','brands':'Nuestras marcas','brandsBody':'Cuatro marcas para distintos canales y mercados.','products':'Productos destacados','productsBody':'Productos reales, sabores diversos y formatos flexibles.','instant':'Bebida instantánea en polvo','singleServe':'Formato individual','privateBody':'De la fórmula al envase listo para vender.','formula':'Fórmula personalizada','packaging':'Diseño de envase','production':'Producción escalable','exportReady':'Apoyo a exportación','export':'Listo para el mundo','exportBody':'Socio multilingüe orientado a la distribución internacional.','markets':'Mercados','flavors':'Sabores','brandsCount':'Marcas','languages':'Idiomas','contact':'Creemos su próxima línea.','contactBody':'Cuéntenos su mercado y objetivos.','startProject':'Iniciar proyecto','footer':'EMAN · Innovación y fabricación de bebidas'},
    'pt': {'eyebrow':'FABRICANTE GLOBAL DE BEBIDAS','hero':'Sabor feito para o mundo.','heroBody':'A EMAN cria bebidas em pó para varejo, foodservice, distribuidores e marcas próprias.','explore':'Ver produtos','privateLabel':'Marca própria','brands':'Nossas marcas','brandsBody':'Quatro marcas para diferentes canais e mercados.','products':'Produtos em destaque','productsBody':'Produtos reais, sabores variados e formatos flexíveis.','instant':'Bebida instantânea em pó','singleServe':'Formato individual','privateBody':'Da fórmula à embalagem pronta para venda.','formula':'Fórmula personalizada','packaging':'Design de embalagem','production':'Produção escalável','exportReady':'Suporte à exportação','export':'Pronto para o mundo','exportBody':'Parceiro multilíngue focado em distribuição internacional.','markets':'Mercados','flavors':'Sabores','brandsCount':'Marcas','languages':'Idiomas','contact':'Vamos criar sua próxima linha.','contactBody':'Conte-nos sobre seu mercado e objetivos.','startProject':'Iniciar projeto','footer':'EMAN · Inovação e fabricação de bebidas'},
    'ru': {'eyebrow':'МЕЖДУНАРОДНЫЙ ПРОИЗВОДИТЕЛЬ НАПИТКОВ','hero':'Вкус, созданный для мира.','heroBody':'EMAN производит порошковые напитки для розницы, HoReCa, дистрибьюторов и частных марок.','explore':'Смотреть продукты','privateLabel':'Частная марка','brands':'Наши бренды','brandsBody':'Четыре бренда для разных каналов и рынков.','products':'Популярные продукты','productsBody':'Реальные продукты, яркие вкусы и гибкие форматы.','instant':'Растворимый порошковый напиток','singleServe':'Порционный формат','privateBody':'От рецептуры до готовой упаковки.','formula':'Индивидуальная рецептура','packaging':'Дизайн упаковки','production':'Масштабируемое производство','exportReady':'Экспортная поддержка','export':'Готово для мира','exportBody':'Многоязычный партнер для международной дистрибуции.','markets':'Рынков','flavors':'Вкусов','brandsCount':'Бренда','languages':'Языков','contact':'Создадим вашу следующую линейку.','contactBody':'Расскажите о рынке и целях проекта.','startProject':'Начать проект','footer':'EMAN · Инновации и производство напитков'},
  };
}
