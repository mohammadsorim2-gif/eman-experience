from pathlib import Path

path = Path('lib/main.dart')
text = path.read_text(encoding='utf-8')

text = text.replace("import 'screens/home/polished_home.dart';", "import 'screens/home/modern_home_dashboard.dart';")

old_pages = """  static const pages = [
    PolishedHome(),
    AdvancedProductCatalog(),
    LocalizedBecomePartnerPage(),
    LocalizedRfqBuilder(),
    AdvancedPartnerDashboard(),
    AdvancedFactoryDashboard(),
    AdvancedExecutiveDashboard(),
    LocalizedAdminDashboard(),
  ];
"""
new_pages = """  List<Widget> get pages => [
    ModernHomeDashboard(onNavigate: _openDestination),
    const AdvancedProductCatalog(),
    const LocalizedBecomePartnerPage(),
    const LocalizedRfqBuilder(),
    const AdvancedPartnerDashboard(),
    const AdvancedFactoryDashboard(),
    const AdvancedExecutiveDashboard(),
    const LocalizedAdminDashboard(),
  ];
"""
if old_pages not in text:
    raise SystemExit('pages block not found')
text = text.replace(old_pages, new_pages, 1)

old_open = """  void _openDestination(int index) {
    if (index < 0 || index >= pages.length) return;
    setState(() => currentIndex = index);
  }
"""
new_open = """  void _openDestination(int index) {
    if (index < 0 || index >= pages.length) return;
    setState(() => currentIndex = index);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSectionTour(index));
  }

  Future<void> _showSectionTour(int index, {bool force = false}) async {
    final item = destinationData[index];
    final descriptions = [
      _ui(tr: 'Genel durum, hızlı işlemler ve son aktiviteler burada.', ar: 'هنا تجد الملخص العام والإجراءات السريعة وآخر النشاطات.', en: 'See the overview, quick actions and latest activity here.'),
      _ui(tr: 'Ürünleri arayın, filtreleyin, karşılaştırın ve RFQ’ya ekleyin.', ar: 'ابحث عن المنتجات وصنفها وقارنها وأضفها لطلب السعر.', en: 'Search, filter and compare products, then add them to an RFQ.'),
      _ui(tr: 'Partner başvurusu oluşturun ve satış ağınıza katılın.', ar: 'قدّم طلب شراكة وانضم إلى شبكة المبيعات.', en: 'Create a partner application and join the sales network.'),
      _ui(tr: 'Ürün, miktar ve teslimat bilgileriyle profesyonel teklif talebi hazırlayın.', ar: 'أنشئ طلب عرض سعر احترافيًا مع المنتج والكمية والتسليم.', en: 'Build a professional quotation request with product, quantity and delivery details.'),
      _ui(tr: 'Siparişleri, komisyonları, belgeleri ve performansı yönetin.', ar: 'أدر الطلبات والعمولات والمستندات والأداء.', en: 'Manage orders, commissions, documents and performance.'),
      _ui(tr: 'Makineleri, üretimi, kaliteyi ve duruşları canlı takip edin.', ar: 'تابع الآلات والإنتاج والجودة والتوقفات مباشرة.', en: 'Monitor machines, production, quality and downtime live.'),
      _ui(tr: 'KPI, analiz, tahmin ve kritik uyarıları görüntüleyin.', ar: 'شاهد المؤشرات والتحليلات والتوقعات والتنبيهات المهمة.', en: 'Review KPIs, analytics, forecasts and critical alerts.'),
      _ui(tr: 'Kullanıcıları, rolleri, içerikleri ve sistem ayarlarını yönetin.', ar: 'أدر المستخدمين والصلاحيات والمحتوى وإعدادات النظام.', en: 'Manage users, roles, content and system settings.'),
    ];
    await showFeatureTourIfNeeded(
      context: context,
      storageKey: force ? 'eman_section_tour_force_${index}_${DateTime.now().millisecondsSinceEpoch}' : 'eman_section_tour_v2_$index',
      steps: [
        FeatureTourStep(
          title: _label(item.$2),
          body: descriptions[index],
          icon: item.$1,
          accent: item.$3,
        ),
        FeatureTourStep(
          title: _ui(tr: 'Hızlı ve kolay kullanım', ar: 'استخدام واضح وسريع', en: 'Fast and simple to use'),
          body: _ui(
            tr: 'Renkli ikonlar, arama ve çalışan işlemlerle ihtiyacınız olan her şeye hızlıca ulaşın.',
            ar: 'استخدم الأيقونات الملونة والبحث والإجراءات الفعالة للوصول بسرعة إلى كل ما تحتاجه.',
            en: 'Use colored icons, search and working actions to reach everything quickly.',
          ),
          icon: Icons.touch_app_rounded,
          accent: item.$3,
        ),
      ],
      nextLabel: _ui(tr: 'Devam', ar: 'التالي', en: 'Next'),
      finishLabel: _ui(tr: 'Anladım', ar: 'فهمت', en: 'Got it'),
      skipLabel: _ui(tr: 'Atla', ar: 'تخطي', en: 'Skip'),
    );
  }
"""
if old_open not in text:
    raise SystemExit('openDestination block not found')
text = text.replace(old_open, new_open, 1)

# Ensure the first page also has its own tour after the general tour.
text = text.replace(
    "WidgetsBinding.instance.addPostFrameCallback((_) => _showTour());",
    "WidgetsBinding.instance.addPostFrameCallback((_) async {\n      await _showTour();\n      if (mounted) await _showSectionTour(0);\n    });",
    1,
)

# Make search navigation trigger the section tour through the same destination method.
text = text.replace('onOpen: _openDestination,', 'onOpen: _openDestination,')

# Add a replay-help button beside the search button in desktop leading controls.
needle = """                    _LanguageSelector(
                      language: widget.language,
                      onChanged: widget.onLanguageChanged,
                      compact: false,
                    ),
"""
replacement = needle + """                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _showSectionTour(currentIndex, force: true),
                      icon: const Icon(Icons.help_outline_rounded, size: 17),
                      label: Text(_ui(tr: 'Bu bölümü anlat', ar: 'شرح هذا القسم', en: 'Explain this section')),
                    ),
"""
if needle in text and 'Explain this section' not in text:
    text = text.replace(needle, replacement, 1)

path.write_text(text, encoding='utf-8')
print('Modern dashboard and per-section onboarding activated.')
