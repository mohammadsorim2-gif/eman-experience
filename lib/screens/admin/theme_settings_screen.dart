import 'package:flutter/material.dart';

import '../../core/theme/app_theme_controller.dart';

class ThemeSettingsScreen extends StatelessWidget {
  const ThemeSettingsScreen({required this.languageCode, super.key});

  final String languageCode;

  String _tx({required String tr, required String ar, required String en}) {
    return switch (languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  @override
  Widget build(BuildContext context) {
    final controller = AppThemeController.instance;
    const accents = <Color>[
      Color(0xFF0879B8),
      Color(0xFF7657D9),
      Color(0xFF159776),
      Color(0xFFE87A35),
      Color(0xFFD94F70),
      Color(0xFF536773),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Görünüm ayarları',
            ar: 'إعدادات المظهر',
            en: 'Appearance settings',
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _Header(
                title: _tx(
                  tr: 'Uygulamayı çalışma tarzınıza göre kişiselleştirin',
                  ar: 'خصص التطبيق بما يناسب أسلوب عملك',
                  en: 'Personalize the app for your workflow',
                ),
                subtitle: _tx(
                  tr: 'Tema, vurgu rengi ve arayüz yoğunluğunu anında değiştirin.',
                  ar: 'غيّر الثيم واللون الرئيسي وكثافة الواجهة مباشرة.',
                  en: 'Change theme, accent color and interface density instantly.',
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _tx(tr: 'Tema modu', ar: 'وضع الثيم', en: 'Theme mode'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              SegmentedButton<AppThemePreference>(
                segments: [
                  ButtonSegment(
                    value: AppThemePreference.system,
                    icon: const Icon(Icons.brightness_auto_rounded),
                    label: Text(
                      _tx(tr: 'Sistem', ar: 'تلقائي', en: 'System'),
                    ),
                  ),
                  ButtonSegment(
                    value: AppThemePreference.light,
                    icon: const Icon(Icons.light_mode_rounded),
                    label: Text(
                      _tx(tr: 'Açık', ar: 'فاتح', en: 'Light'),
                    ),
                  ),
                  ButtonSegment(
                    value: AppThemePreference.dark,
                    icon: const Icon(Icons.dark_mode_rounded),
                    label: Text(
                      _tx(tr: 'Koyu', ar: 'داكن', en: 'Dark'),
                    ),
                  ),
                ],
                selected: {controller.preference},
                onSelectionChanged: (selection) {
                  controller.setPreference(selection.first);
                },
              ),
              const SizedBox(height: 28),
              Text(
                _tx(tr: 'Vurgu rengi', ar: 'اللون الرئيسي', en: 'Accent color'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final color in accents)
                    _AccentChoice(
                      color: color,
                      selected: controller.accent.toARGB32() == color.toARGB32(),
                      onTap: () => controller.setAccent(color),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              Card(
                child: SwitchListTile(
                  value: controller.compactDensity,
                  onChanged: controller.setCompactDensity,
                  secondary: const Icon(Icons.density_medium_rounded),
                  title: Text(
                    _tx(
                      tr: 'Kompakt görünüm',
                      ar: 'واجهة مضغوطة',
                      en: 'Compact interface',
                    ),
                  ),
                  subtitle: Text(
                    _tx(
                      tr: 'Ekranda daha fazla bilgi gösterir',
                      ar: 'يعرض معلومات أكثر ضمن الشاشة',
                      en: 'Show more information on screen',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              Text(
                _tx(tr: 'Önizleme', ar: 'معاينة', en: 'Preview'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: controller.accent.withValues(alpha: .14),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          Icons.dashboard_customize_rounded,
                          color: controller.accent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tx(
                                tr: 'EMAN ONE arayüzü',
                                ar: 'واجهة EMAN ONE',
                                en: 'EMAN ONE interface',
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _tx(
                                tr: 'Değişiklikler otomatik olarak kaydedilir.',
                                ar: 'يتم حفظ التغييرات تلقائيًا.',
                                en: 'Changes are saved automatically.',
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        onPressed: () {},
                        child: Text(
                          _tx(tr: 'Örnek', ar: 'مثال', en: 'Sample'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer,
            Theme.of(context).colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const Icon(Icons.palette_rounded, size: 34),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentChoice extends StatelessWidget {
  const _AccentChoice({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.white : Colors.transparent,
            width: 3,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: .35),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: selected
            ? const Icon(Icons.check_rounded, color: Colors.white)
            : null,
      ),
    );
  }
}
