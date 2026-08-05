import 'package:flutter/material.dart';

import '../../core/dashboard/dashboard_layout_controller.dart';

class DashboardLayoutSettingsScreen extends StatefulWidget {
  const DashboardLayoutSettingsScreen({
    required this.languageCode,
    super.key,
  });

  final String languageCode;

  @override
  State<DashboardLayoutSettingsScreen> createState() =>
      _DashboardLayoutSettingsScreenState();
}

class _DashboardLayoutSettingsScreenState
    extends State<DashboardLayoutSettingsScreen> {
  final controller = DashboardLayoutController.instance;

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  String _tx({required String tr, required String ar, required String en}) {
    return switch (widget.languageCode) {
      'tr' => tr,
      'ar' => ar,
      _ => en,
    };
  }

  String _title(String id) {
    return switch (id) {
      'sales' => _tx(tr: 'Satışlar', ar: 'المبيعات', en: 'Sales'),
      'production' => _tx(tr: 'Üretim', ar: 'الإنتاج', en: 'Production'),
      'orders' => _tx(tr: 'Siparişler', ar: 'الطلبات', en: 'Orders'),
      'inventory' => _tx(tr: 'Stok', ar: 'المخزون', en: 'Inventory'),
      'machines' => _tx(tr: 'Makineler', ar: 'الآلات', en: 'Machines'),
      'employees' => _tx(tr: 'Çalışanlar', ar: 'الموظفون', en: 'Employees'),
      'shipments' => _tx(tr: 'Sevkiyat', ar: 'الشحن', en: 'Shipments'),
      'delays' => _tx(tr: 'Gecikmeler', ar: 'التأخيرات', en: 'Delays'),
      _ => id,
    };
  }

  IconData _icon(String id) {
    return switch (id) {
      'sales' => Icons.trending_up_rounded,
      'production' => Icons.precision_manufacturing_rounded,
      'orders' => Icons.receipt_long_rounded,
      'inventory' => Icons.inventory_2_rounded,
      'machines' => Icons.settings_suggest_rounded,
      'employees' => Icons.groups_rounded,
      'shipments' => Icons.local_shipping_rounded,
      'delays' => Icons.warning_amber_rounded,
      _ => Icons.widgets_rounded,
    };
  }

  Color _color(String id) {
    return switch (id) {
      'sales' => const Color(0xFF159776),
      'production' => const Color(0xFF0879B8),
      'orders' => const Color(0xFFE87A35),
      'inventory' => const Color(0xFF7657D9),
      'machines' => const Color(0xFF3B68D9),
      'employees' => const Color(0xFF536773),
      'shipments' => const Color(0xFF22A0A8),
      'delays' => const Color(0xFFD94F70),
      _ => Theme.of(context).colorScheme.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _tx(
            tr: 'Kontrol paneli düzeni',
            ar: 'تخصيص لوحة التحكم',
            en: 'Dashboard layout',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: controller.reset,
            icon: const Icon(Icons.restart_alt_rounded),
            label: Text(_tx(tr: 'Sıfırla', ar: 'إعادة ضبط', en: 'Reset')),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final widgets = controller.widgets;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Theme.of(context).colorScheme.secondaryContainer,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.dashboard_customize_rounded, size: 34),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _tx(
                                tr: 'Panelinizi çalışma şeklinize göre düzenleyin',
                                ar: 'رتّب لوحة التحكم حسب أسلوب عملك',
                                en: 'Arrange the dashboard around your workflow',
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _tx(
                                tr: 'Kartları sürükleyin, gösterin veya gizleyin. Değişiklikler otomatik kaydedilir.',
                                ar: 'اسحب البطاقات لترتيبها، وأظهر أو أخفِ ما تحتاجه. يتم الحفظ تلقائيًا.',
                                en: 'Drag cards to reorder them and show or hide what you need. Changes save automatically.',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  itemCount: widgets.length,
                  onReorder: controller.reorder,
                  proxyDecorator: (child, index, animation) {
                    return Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(20),
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final item = widgets[index];
                    final color = _color(item.id);
                    return Card(
                      key: ValueKey(item.id),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: SwitchListTile(
                        value: item.visible,
                        onChanged: (value) =>
                            controller.setVisibility(item.id, value),
                        secondary: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: .13),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(_icon(item.id), color: color),
                        ),
                        title: Text(
                          _title(item.id),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        subtitle: Text(
                          item.visible
                              ? _tx(
                                  tr: 'Panelde görünür',
                                  ar: 'ظاهرة في لوحة التحكم',
                                  en: 'Visible on dashboard',
                                )
                              : _tx(
                                  tr: 'Panelden gizli',
                                  ar: 'مخفية من لوحة التحكم',
                                  en: 'Hidden from dashboard',
                                ),
                        ),
                        controlAffinity: ListTileControlAffinity.trailing,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
