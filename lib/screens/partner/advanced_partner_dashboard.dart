import 'package:flutter/material.dart';

import '../../app.dart';
import '../../core/app_i18n.dart';

class AdvancedPartnerDashboard extends StatelessWidget {
  const AdvancedPartnerDashboard({super.key});

  String _t(BuildContext context, String key) {
    const values = <String, Map<String, String>>{
      'title': {
        'tr': 'Satış Ortağı Kontrol Merkezi',
        'en': 'Sales Partner Command Center',
        'ar': 'مركز تحكم شريك المبيعات',
        'es': 'Centro de control del socio comercial',
        'pt': 'Central do parceiro de vendas',
        'ru': 'Центр управления партнёра',
        'fr': 'Centre de pilotage partenaire',
        'de': 'Partner-Kontrollzentrum',
      },
      'subtitle': {
        'tr':
            'Potansiyel müşterilerinizi, fırsatlarınızı, siparişlerinizi ve komisyonlarınızı tek ekrandan yönetin.',
        'en':
            'Manage leads, opportunities, orders and commissions from one workspace.',
        'ar': 'أدر العملاء المحتملين والفرص والطلبات والعمولات من شاشة واحدة.',
        'es':
            'Gestione prospectos, oportunidades, pedidos y comisiones desde un solo lugar.',
        'pt':
            'Gerencie leads, oportunidades, pedidos e comissões em um só lugar.',
        'ru':
            'Управляйте лидами, сделками, заказами и комиссиями в одном месте.',
        'fr':
            'Gérez prospects, opportunités, commandes et commissions depuis un seul espace.',
        'de': 'Leads, Chancen, Bestellungen und Provisionen zentral verwalten.',
      },
      'certified': {
        'tr': 'Onaylı Global Partner',
        'en': 'Certified Global Partner',
        'ar': 'شريك عالمي معتمد',
        'es': 'Socio global certificado',
        'pt': 'Parceiro global certificado',
        'ru': 'Сертифицированный партнёр',
        'fr': 'Partenaire mondial certifié',
        'de': 'Zertifizierter globaler Partner',
      },
      'leads': {
        'tr': 'Toplam Lead',
        'en': 'Total Leads',
        'ar': 'إجمالي العملاء',
        'es': 'Prospectos',
        'pt': 'Leads',
        'ru': 'Лиды',
        'fr': 'Prospects',
        'de': 'Leads',
      },
      'pipeline': {
        'tr': 'Aktif Fırsatlar',
        'en': 'Active Pipeline',
        'ar': 'الفرص النشطة',
        'es': 'Oportunidades',
        'pt': 'Oportunidades',
        'ru': 'Активные сделки',
        'fr': 'Opportunités',
        'de': 'Aktive Chancen',
      },
      'orders': {
        'tr': 'Onaylı Siparişler',
        'en': 'Confirmed Orders',
        'ar': 'الطلبات المؤكدة',
        'es': 'Pedidos confirmados',
        'pt': 'Pedidos confirmados',
        'ru': 'Подтверждённые заказы',
        'fr': 'Commandes confirmées',
        'de': 'Bestätigte Bestellungen',
      },
      'commission': {
        'tr': 'Toplam Komisyon',
        'en': 'Total Commission',
        'ar': 'إجمالي العمولة',
        'es': 'Comisión total',
        'pt': 'Comissão total',
        'ru': 'Общая комиссия',
        'fr': 'Commission totale',
        'de': 'Gesamtprovision',
      },
      'referral': {
        'tr': 'Kişisel Referans Bağlantınız',
        'en': 'Your Personal Referral Link',
        'ar': 'رابط الإحالة الخاص بك',
        'es': 'Su enlace de referencia',
        'pt': 'Seu link de indicação',
        'ru': 'Ваша реферальная ссылка',
        'fr': 'Votre lien de parrainage',
        'de': 'Ihr Empfehlungslink',
      },
      'copy': {
        'tr': 'Kopyala',
        'en': 'Copy',
        'ar': 'نسخ',
        'es': 'Copiar',
        'pt': 'Copiar',
        'ru': 'Копировать',
        'fr': 'Copier',
        'de': 'Kopieren',
      },
      'share': {
        'tr': 'Paylaş',
        'en': 'Share',
        'ar': 'مشاركة',
        'es': 'Compartir',
        'pt': 'Compartilhar',
        'ru': 'Поделиться',
        'fr': 'Partager',
        'de': 'Teilen',
      },
      'pipelineTitle': {
        'tr': 'Satış Fırsatları',
        'en': 'Sales Opportunities',
        'ar': 'فرص المبيعات',
        'es': 'Oportunidades de venta',
        'pt': 'Oportunidades de vendas',
        'ru': 'Продажи',
        'fr': 'Opportunités commerciales',
        'de': 'Verkaufschancen',
      },
      'company': {
        'tr': 'Şirket',
        'en': 'Company',
        'ar': 'الشركة',
        'es': 'Empresa',
        'pt': 'Empresa',
        'ru': 'Компания',
        'fr': 'Entreprise',
        'de': 'Unternehmen',
      },
      'market': {
        'tr': 'Pazar',
        'en': 'Market',
        'ar': 'السوق',
        'es': 'Mercado',
        'pt': 'Mercado',
        'ru': 'Рынок',
        'fr': 'Marché',
        'de': 'Markt',
      },
      'stage': {
        'tr': 'Aşama',
        'en': 'Stage',
        'ar': 'المرحلة',
        'es': 'Etapa',
        'pt': 'Etapa',
        'ru': 'Этап',
        'fr': 'Étape',
        'de': 'Phase',
      },
      'value': {
        'tr': 'Değer',
        'en': 'Value',
        'ar': 'القيمة',
        'es': 'Valor',
        'pt': 'Valor',
        'ru': 'Сумма',
        'fr': 'Valeur',
        'de': 'Wert',
      },
      'activity': {
        'tr': 'Son Aktiviteler',
        'en': 'Recent Activity',
        'ar': 'أحدث النشاطات',
        'es': 'Actividad reciente',
        'pt': 'Atividade recente',
        'ru': 'Последняя активность',
        'fr': 'Activité récente',
        'de': 'Letzte Aktivitäten',
      },
      'academy': {
        'tr': 'Partner Akademisi',
        'en': 'Partner Academy',
        'ar': 'أكاديمية الشركاء',
        'es': 'Academia de socios',
        'pt': 'Academia de parceiros',
        'ru': 'Академия партнёров',
        'fr': 'Académie partenaire',
        'de': 'Partner-Akademie',
      },
      'academyText': {
        'tr': 'Ürün, ihracat ve satış eğitimlerinizi tamamlayın.',
        'en': 'Complete product, export and sales training.',
        'ar': 'أكمل تدريبات المنتجات والتصدير والمبيعات.',
        'es': 'Complete la formación de producto, exportación y ventas.',
        'pt': 'Conclua os treinamentos de produto, exportação e vendas.',
        'ru': 'Пройдите обучение по продукту, экспорту и продажам.',
        'fr': 'Terminez les formations produit, export et vente.',
        'de': 'Produkt-, Export- und Verkaufsschulungen abschließen.',
      },
      'continue': {
        'tr': 'Eğitime Devam Et',
        'en': 'Continue Training',
        'ar': 'متابعة التدريب',
        'es': 'Continuar formación',
        'pt': 'Continuar treinamento',
        'ru': 'Продолжить обучение',
        'fr': 'Continuer la formation',
        'de': 'Training fortsetzen',
      },
      'newLead': {
        'tr': 'Yeni Lead Ekle',
        'en': 'Add New Lead',
        'ar': 'إضافة عميل جديد',
        'es': 'Añadir prospecto',
        'pt': 'Adicionar lead',
        'ru': 'Добавить лид',
        'fr': 'Ajouter un prospect',
        'de': 'Neuen Lead hinzufügen',
      },
    };
    final code = AppLocaleScope.of(context).languageCode;
    final map = values[key];
    return map?[code] ?? map?['tr'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Wrap(
          spacing: 18,
          runSpacing: 18,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 760,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _t(context, 'title'),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: EmanExperienceApp.navy,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _t(context, 'subtitle'),
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.55,
                      color: Color(0xFF617684),
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              avatar: const Icon(
                Icons.verified,
                size: 18,
                color: Color(0xFF12855B),
              ),
              label: Text(_t(context, 'certified')),
            ),
          ],
        ),
        const SizedBox(height: 26),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1080
                ? 4
                : constraints.maxWidth >= 620
                ? 2
                : 1;
            final width =
                (constraints.maxWidth - ((columns - 1) * 18)) / columns;
            final metrics = [
              (_t(context, 'leads'), '128', '+18%', Icons.groups_outlined),
              (_t(context, 'pipeline'), r'$284K', '+12%', Icons.trending_up),
              (_t(context, 'orders'), '17', '+4', Icons.verified_outlined),
              (
                _t(context, 'commission'),
                r'$18,450',
                r'$4,200 pending',
                Icons.payments_outlined,
              ),
            ];
            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: metrics
                  .map(
                    (item) => SizedBox(
                      width: width,
                      child: _MetricCard(
                        title: item.$1,
                        value: item.$2,
                        note: item.$3,
                        icon: item.$4,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _t(context, 'referral'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F7FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      const SelectableText(
                        'https://emanagro.com/p/EMAN-TR-2026',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.copy_outlined),
                        label: Text(_t(context, 'copy')),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined),
                        label: Text(_t(context, 'share')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            final stacked = constraints.maxWidth < 980;
            final pipeline = _PipelineCard(t: _t);
            final side = Column(
              children: [
                _AcademyCard(t: _t),
                const SizedBox(height: 18),
                _ActivityCard(t: _t),
              ],
            );
            if (stacked) {
              return Column(
                children: [pipeline, const SizedBox(height: 18), side],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: pipeline),
                const SizedBox(width: 18),
                Expanded(flex: 2, child: side),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        Align(
          alignment: rtl ? Alignment.centerRight : Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(_t(context, 'newLead')),
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.note,
    required this.icon,
  });
  final String title;
  final String value;
  final String note;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFE9F6FF),
              child: Icon(icon, color: EmanExperienceApp.blue),
            ),
            const SizedBox(height: 18),
            Text(title, style: const TextStyle(color: Color(0xFF687A86))),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: EmanExperienceApp.navy,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              note,
              style: const TextStyle(
                color: Color(0xFF14845C),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PipelineCard extends StatelessWidget {
  const _PipelineCard({required this.t});
  final String Function(BuildContext, String) t;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ('Atlas Distribution', 'Morocco', 'Quotation', r'$24,000'),
      ('Nova Market Group', 'Brazil', 'Negotiation', r'$41,500'),
      ('Golden Foods', 'Saudi Arabia', 'Sample', r'$18,900'),
      ('EuroDrink GmbH', 'Germany', 'New lead', r'$32,600'),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t(context, 'pipelineTitle'),
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 18),
            ...rows.map(
              (row) => Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.business_outlined),
                    ),
                    title: Text(
                      row.$1,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text('${row.$2} • ${row.$3}'),
                    trailing: Text(
                      row.$4,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: EmanExperienceApp.navy,
                      ),
                    ),
                  ),
                  if (row != rows.last) const Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AcademyCard extends StatelessWidget {
  const _AcademyCard({required this.t});
  final String Function(BuildContext, String) t;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t(context, 'academy'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              t(context, 'academyText'),
              style: const TextStyle(height: 1.5, color: Color(0xFF667985)),
            ),
            const SizedBox(height: 16),
            const LinearProgressIndicator(value: .72, minHeight: 9),
            const SizedBox(height: 8),
            const Text('72%', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.school_outlined),
                label: Text(t(context, 'continue')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.t});
  final String Function(BuildContext, String) t;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t(context, 'activity'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const _Activity(
              icon: Icons.request_quote_outlined,
              text: 'RFQ-2026-041 updated',
              time: '12 min',
            ),
            const Divider(),
            const _Activity(
              icon: Icons.payments_outlined,
              text: 'Commission approved',
              time: '2 h',
            ),
            const Divider(),
            const _Activity(
              icon: Icons.local_shipping_outlined,
              text: 'Shipment EX-2048 dispatched',
              time: 'Yesterday',
            ),
          ],
        ),
      ),
    );
  }
}

class _Activity extends StatelessWidget {
  const _Activity({required this.icon, required this.text, required this.time});
  final IconData icon;
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFFEAF6FF),
        child: Icon(icon, color: EmanExperienceApp.blue),
      ),
      title: Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(time),
    );
  }
}
