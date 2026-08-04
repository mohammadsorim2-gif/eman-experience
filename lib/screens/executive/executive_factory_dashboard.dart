import 'package:flutter/material.dart';

class ExecutiveFactoryDashboard extends StatelessWidget {
  const ExecutiveFactoryDashboard({required this.languageCode, super.key});

  final String languageCode;

  String _tx({required String ar, required String tr, required String en}) =>
      switch (languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    final indicators = [
      _Kpi(_tx(ar: 'إنتاج اليوم', tr: 'Bugünkü üretim', en: 'Today production'), '184,000', _tx(ar: 'ظرف', tr: 'saşe', en: 'sachets'), Icons.factory_outlined),
      _Kpi(_tx(ar: 'كفاءة الخطوط', tr: 'Hat verimliliği', en: 'Line efficiency'), '91.4%', _tx(ar: '+2.3% عن أمس', tr: 'düne göre +2.3%', en: '+2.3% vs yesterday'), Icons.speed_rounded),
      _Kpi(_tx(ar: 'طلبات جاهزة', tr: 'Hazır siparişler', en: 'Ready orders'), '28', _tx(ar: '8 للشحن اليوم', tr: '8 bugün sevk', en: '8 ship today'), Icons.local_shipping_outlined),
      _Kpi(_tx(ar: 'تنبيهات حرجة', tr: 'Kritik uyarılar', en: 'Critical alerts'), '3', _tx(ar: 'مخزون وصيانة', tr: 'stok ve bakım', en: 'stock and maintenance'), Icons.warning_amber_rounded),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_tx(ar: 'لوحة المدير التنفيذي', tr: 'Yönetici paneli', en: 'Executive dashboard')),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.refresh_rounded))],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth >= 1200 ? 4 : constraints.maxWidth >= 700 ? 2 : 1;
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: indicators.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.65,
                ),
                itemBuilder: (context, index) => _KpiCard(indicator: indicators[index]),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _ExecutivePanel(
                    width: constraints.maxWidth >= 1000 ? (constraints.maxWidth - 64) * .58 : constraints.maxWidth,
                    title: _tx(ar: 'حالة خطوط الإنتاج', tr: 'Üretim hatları', en: 'Production lines'),
                    child: Column(
                      children: [
                        _LineStatus(name: _tx(ar: 'خط الخلط والتعبئة 1', tr: 'Karıştırma ve dolum hattı 1', en: 'Mixing and filling line 1'), value: .94, status: _tx(ar: 'يعمل', tr: 'Çalışıyor', en: 'Running')),
                        _LineStatus(name: _tx(ar: 'خط التعبئة 2', tr: 'Dolum hattı 2', en: 'Filling line 2'), value: .87, status: _tx(ar: 'يعمل', tr: 'Çalışıyor', en: 'Running')),
                        _LineStatus(name: _tx(ar: 'خط التغليف بالكرتون', tr: 'Karton paketleme hattı', en: 'Carton packing line'), value: .63, status: _tx(ar: 'تنظيف وتعقيم', tr: 'Temizlik', en: 'Cleaning')),
                      ],
                    ),
                  ),
                  _ExecutivePanel(
                    width: constraints.maxWidth >= 1000 ? (constraints.maxWidth - 64) * .38 : constraints.maxWidth,
                    title: _tx(ar: 'أهم التنبيهات', tr: 'Önemli uyarılar', en: 'Top alerts'),
                    child: Column(
                      children: [
                        _AlertTile(icon: Icons.inventory_2_outlined, title: _tx(ar: 'نكهة المانجو تحت حد الطلب', tr: 'Mango aroması düşük stok', en: 'Mango flavor below reorder level')),
                        _AlertTile(icon: Icons.build_outlined, title: _tx(ar: 'معايرة آلة الوزن غدًا', tr: 'Yarın tartım kalibrasyonu', en: 'Weigher calibration due tomorrow')),
                        _AlertTile(icon: Icons.schedule_rounded, title: _tx(ar: 'طلبان متأخران عن الخطة', tr: 'İki sipariş gecikmiş', en: 'Two orders behind plan')),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ExecutivePanel(
                width: constraints.maxWidth,
                title: _tx(ar: 'ملخص الأعمال اليوم', tr: 'Bugünün iş özeti', en: 'Today business summary'),
                child: Wrap(
                  spacing: 32,
                  runSpacing: 16,
                  children: [
                    _SummaryItem(label: _tx(ar: 'المبيعات', tr: 'Satış', en: 'Sales'), value: '₺2.84M'),
                    _SummaryItem(label: _tx(ar: 'تكلفة الإنتاج', tr: 'Üretim maliyeti', en: 'Production cost'), value: '₺1.71M'),
                    _SummaryItem(label: _tx(ar: 'الهامش الإجمالي', tr: 'Brüt marj', en: 'Gross margin'), value: '39.8%'),
                    _SummaryItem(label: _tx(ar: 'دفعات مقبولة', tr: 'Onaylı partiler', en: 'Released batches'), value: '12 / 13'),
                    _SummaryItem(label: _tx(ar: 'العمال الحاضرون', tr: 'Mevcut çalışan', en: 'Workers present'), value: '74 / 79'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Kpi {
  const _Kpi(this.title, this.value, this.caption, this.icon);
  final String title;
  final String value;
  final String caption;
  final IconData icon;
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.indicator});
  final _Kpi indicator;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [CircleAvatar(child: Icon(indicator.icon)), const Spacer(), const Icon(Icons.more_horiz_rounded)]),
              const Spacer(),
              Text(indicator.value, style: Theme.of(context).textTheme.headlineMedium),
              Text(indicator.title, style: Theme.of(context).textTheme.titleMedium),
              Text(indicator.caption),
            ],
          ),
        ),
      );
}

class _ExecutivePanel extends StatelessWidget {
  const _ExecutivePanel({required this.width, required this.title, required this.child});
  final double width;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 16), child]),
          ),
        ),
      );
}

class _LineStatus extends StatelessWidget {
  const _LineStatus({required this.name, required this.value, required this.status});
  final String name;
  final double value;
  final String status;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Expanded(child: Text(name)), Text(status)]), const SizedBox(height: 8), LinearProgressIndicator(value: value), const SizedBox(height: 4), Text('${(value * 100).round()}%')]),
      );
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => ListTile(contentPadding: EdgeInsets.zero, leading: CircleAvatar(child: Icon(icon)), title: Text(title), trailing: const Icon(Icons.chevron_right_rounded));
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => SizedBox(width: 180, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: Theme.of(context).textTheme.headlineSmall), Text(label)]));
}
