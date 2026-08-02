import 'package:flutter/material.dart';

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  static const blue = Color(0xFF0677C9);
  static const navy = Color(0xFF052A45);
  static const gold = Color(0xFFFFC857);
  static const background = Color(0xFFF5F8FC);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EMAN Global Partner',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue),
        scaffoldBackgroundColor: background,
        fontFamily: 'Arial',
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Color(0xFFE7EDF3)),
          ),
        ),
      ),
      home: const PlatformHome(),
    );
  }
}

class PlatformHome extends StatefulWidget {
  const PlatformHome({super.key});

  @override
  State<PlatformHome> createState() => _PlatformHomeState();
}

class _PlatformHomeState extends State<PlatformHome> {
  int currentIndex = 0;

  final pages = const [
    PublicHome(),
    ProductsPage(),
    BecomePartnerPage(),
    PartnerDashboard(),
    AdminPreviewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final desktop = MediaQuery.sizeOf(context).width >= 900;

    if (desktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: true,
              minExtendedWidth: 225,
              backgroundColor: Colors.white,
              selectedIndex: currentIndex,
              onDestinationSelected: (value) {
                setState(() => currentIndex = value);
              },
              leading: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 35),
                child: Image.asset(
                  'assets/logos/Eman logo.png',
                  height: 55,
                  errorBuilder: (_, __, ___) => const Text(
                    'EMAN',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text('Products'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_add_alt_outlined),
                  selectedIcon: Icon(Icons.person_add_alt),
                  label: Text('Become Partner'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Partner Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.admin_panel_settings_outlined),
                  selectedIcon: Icon(Icons.admin_panel_settings),
                  label: Text('Admin Preview'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: pages[currentIndex]),
          ],
        ),
      );
    }

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() => currentIndex = value);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt),
            label: 'Partner',
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}

class PublicHome extends StatelessWidget {
  const PublicHome({super.key});

  static const products = [
    'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          child: Row(
            children: [
              Image.asset(
                'assets/logos/Eman logo.png',
                height: 54,
                errorBuilder: (_, __, ___) => const Text(
                  'EMAN',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
                ),
              ),
              const Spacer(),
              const Chip(
                avatar: Icon(Icons.public, size: 18),
                label: Text('Global Partner Network'),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 70),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEDF8FF), Color(0xFFFFF6E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1250),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 850;

                  final copy = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'EMAN GLOBAL PARTNER',
                        style: TextStyle(
                          color: EmanExperienceApp.blue,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Turn your network\ninto global income.',
                        style: TextStyle(
                          fontSize: compact ? 46 : 70,
                          height: .98,
                          fontWeight: FontWeight.w500,
                          color: EmanExperienceApp.navy,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Anyone in the world can introduce buyers, distributors '
                        'and wholesalers to EMAN and earn an approved commission '
                        'when a successful deal is completed.',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.6,
                          color: Color(0xFF526B7B),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilledButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.person_add_alt),
                            label: const Text('Become a Sales Partner'),
                          ),
                          OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.play_circle_outline),
                            label: const Text('How it works'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Wrap(
                        spacing: 20,
                        runSpacing: 12,
                        children: [
                          _Proof(
                            icon: Icons.language,
                            text: 'Work from any country',
                          ),
                          _Proof(
                            icon: Icons.link,
                            text: 'Personal referral link',
                          ),
                          _Proof(
                            icon: Icons.payments_outlined,
                            text: 'Track commissions',
                          ),
                        ],
                      ),
                    ],
                  );

                  final visual = Container(
                    height: 500,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 40,
                          color: Color(0x18000000),
                          offset: Offset(0, 18),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 26,
                          right: 26,
                          child: _MiniBadge(
                            icon: Icons.trending_up,
                            title: '+24%',
                            subtitle: 'Partner growth',
                          ),
                        ),
                        Positioned(
                          bottom: 28,
                          left: 28,
                          child: _MiniBadge(
                            icon: Icons.public,
                            title: '38',
                            subtitle: 'Active countries',
                          ),
                        ),
                        Image.asset(
                          products.first,
                          height: 335,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.local_drink,
                            size: 170,
                            color: EmanExperienceApp.blue,
                          ),
                        ),
                      ],
                    ),
                  );

                  if (compact) {
                    return Column(
                      children: [copy, const SizedBox(height: 45), visual],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 65),
                      Expanded(child: visual),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
        const _HowItWorks(),
      ],
    );
  }
}

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  static const products = [
    (
      'Orange',
      'Frio Cups',
      'assets/products/friocups/9g-orange-flavored-powder-drink-friocups.png',
    ),
    (
      'Mango',
      'Frio Cups',
      'assets/products/friocups/9g-mango-flavored-powder-drink-friocups.png',
    ),
    (
      'Berries',
      'Frio Cups',
      'assets/products/friocups/9g-berries-flavored-powder-drink-friocups.png',
    ),
    (
      'Banana',
      'Frio Cups',
      'assets/products/friocups/9g-banana-flavored-powder-drink-friocups.png',
    ),
    (
      'Strawberry',
      'Full Fresh',
      'assets/products/fullfresh/Full-fresh-9g-drink-powder-strawberry.png',
    ),
    (
      'Orange',
      'Valore',
      'assets/products/valore/orange-flavored-powder-drink-valore-10grams.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text(
          'Interactive Product Catalog',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w500,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Share any product using your personal partner link and track resulting leads.',
          style: TextStyle(fontSize: 17, color: Color(0xFF607482)),
        ),
        const SizedBox(height: 28),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search products, flavors or brands',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth >= 1100
                ? 3
                : constraints.maxWidth >= 650
                ? 2
                : 1;

            final width =
                (constraints.maxWidth - ((columns - 1) * 18)) / columns;

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: products.map((product) {
                return SizedBox(
                  width: width,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 245,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7FAFD),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              product.$3,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.local_drink,
                                size: 90,
                                color: EmanExperienceApp.blue,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            product.$2,
                            style: const TextStyle(
                              color: EmanExperienceApp.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${product.$1} Powder Drink',
                            style: const TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.w500,
                              color: EmanExperienceApp.navy,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.share_outlined),
                                  label: const Text('Share'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              IconButton.outlined(
                                onPressed: () {},
                                icon: const Icon(Icons.add_link),
                              ),
                            ],
                          ),
                        ],
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
}

class BecomePartnerPage extends StatefulWidget {
  const BecomePartnerPage({super.key});

  @override
  State<BecomePartnerPage> createState() => _BecomePartnerPageState();
}

class _BecomePartnerPageState extends State<BecomePartnerPage> {
  final formKey = GlobalKey<FormState>();
  String country = 'Türkiye';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Become an EMAN Sales Partner',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: EmanExperienceApp.navy,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Register your profile, complete the short academy and receive '
                  'a personal referral link to start introducing qualified buyers.',
                  style: TextStyle(fontSize: 17, height: 1.6),
                ),
                const SizedBox(height: 28),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Full name',
                              prefixIcon: Icon(Icons.person_outline),
                            ),
                            validator: (value) =>
                                value == null || value.trim().isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              prefixIcon: Icon(Icons.email_outlined),
                            ),
                            validator: (value) =>
                                value == null || !value.contains('@')
                                ? 'Enter a valid email'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Phone / WhatsApp',
                              prefixIcon: Icon(Icons.phone_outlined),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            initialValue: country,
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              prefixIcon: Icon(Icons.public),
                            ),
                            items:
                                const [
                                  'Türkiye',
                                  'Germany',
                                  'Spain',
                                  'Portugal',
                                  'Brazil',
                                  'Russia',
                                  'Saudi Arabia',
                                  'United Arab Emirates',
                                  'Other',
                                ].map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  );
                                }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => country = value);
                              }
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Tell us about your market or network',
                              alignLabelWithHint: true,
                              prefixIcon: Icon(Icons.business_center_outlined),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Application submitted successfully',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.send),
                              label: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('Submit Partner Application'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PartnerDashboard extends StatelessWidget {
  const PartnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text(
          'Partner Dashboard',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome, Certified EMAN Partner',
          style: TextStyle(fontSize: 17, color: Color(0xFF627684)),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 900
                ? (constraints.maxWidth - 54) / 4
                : constraints.maxWidth >= 520
                ? (constraints.maxWidth - 18) / 2
                : constraints.maxWidth;

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                _DashboardStat(
                  width: width,
                  title: 'Total Leads',
                  value: '27',
                  icon: Icons.groups_outlined,
                  trend: '+8 this month',
                ),
                _DashboardStat(
                  width: width,
                  title: 'Open Deals',
                  value: '9',
                  icon: Icons.handshake_outlined,
                  trend: '3 awaiting response',
                ),
                _DashboardStat(
                  width: width,
                  title: 'Closed Deals',
                  value: '4',
                  icon: Icons.verified_outlined,
                  trend: '+1 this month',
                ),
                _DashboardStat(
                  width: width,
                  title: 'Commission',
                  value: '\$3,850',
                  icon: Icons.payments_outlined,
                  trend: '\$1,200 pending',
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Referral Link',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F7FC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: SelectableText(
                          'https://emanagro.com/partner/EMAN-MH-2026',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.copy),
                      ),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.share),
                        label: const Text('Share'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 26),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recent Leads',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                const _LeadRow(
                  company: 'Atlas Distribution',
                  country: 'Morocco',
                  stage: 'Quotation',
                  value: '\$24,000',
                ),
                const Divider(),
                const _LeadRow(
                  company: 'Nova Market Group',
                  country: 'Brazil',
                  stage: 'Negotiation',
                  value: '\$41,500',
                ),
                const Divider(),
                const _LeadRow(
                  company: 'Golden Foods',
                  country: 'Saudi Arabia',
                  stage: 'New lead',
                  value: 'Pending',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class AdminPreviewPage extends StatelessWidget {
  const AdminPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const Text(
          'EMAN Administration Preview',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w500,
            color: EmanExperienceApp.navy,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Management overview for global partners, leads, deals and commissions.',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth >= 900
                ? (constraints.maxWidth - 36) / 3
                : constraints.maxWidth;

            return Wrap(
              spacing: 18,
              runSpacing: 18,
              children: [
                _AdminCard(
                  width: width,
                  title: 'Active Partners',
                  value: '1,284',
                  subtitle: 'Across 38 countries',
                  icon: Icons.public,
                ),
                _AdminCard(
                  width: width,
                  title: 'Qualified Leads',
                  value: '342',
                  subtitle: 'This quarter',
                  icon: Icons.business_center_outlined,
                ),
                _AdminCard(
                  width: width,
                  title: 'Partner Revenue',
                  value: '\$2.4M',
                  subtitle: 'Closed partner deals',
                  icon: Icons.trending_up,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 26),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Commission Approvals',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 18),
                _ApprovalRow(
                  partner: 'Maria Silva',
                  country: 'Brazil',
                  deal: '\$41,500',
                  commission: '\$1,245',
                ),
                const Divider(),
                _ApprovalRow(
                  partner: 'Ahmed Karim',
                  country: 'Morocco',
                  deal: '\$24,000',
                  commission: '\$720',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _HowItWorks extends StatelessWidget {
  const _HowItWorks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 85),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'How the partner network works',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w500,
                  color: EmanExperienceApp.navy,
                ),
              ),
              const SizedBox(height: 30),
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth >= 900
                      ? (constraints.maxWidth - 54) / 4
                      : constraints.maxWidth >= 520
                      ? (constraints.maxWidth - 18) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      _StepCard(
                        width: width,
                        number: '01',
                        icon: Icons.person_add_alt,
                        title: 'Register',
                        text: 'Create your free global sales partner profile.',
                      ),
                      _StepCard(
                        width: width,
                        number: '02',
                        icon: Icons.school_outlined,
                        title: 'Learn',
                        text: 'Complete the product and sales academy.',
                      ),
                      _StepCard(
                        width: width,
                        number: '03',
                        icon: Icons.share_outlined,
                        title: 'Refer buyers',
                        text:
                            'Share your personal link with qualified companies.',
                      ),
                      _StepCard(
                        width: width,
                        number: '04',
                        icon: Icons.payments_outlined,
                        title: 'Earn',
                        text:
                            'Receive approved commission after a completed deal.',
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Proof extends StatelessWidget {
  const _Proof({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: EmanExperienceApp.blue),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: EmanExperienceApp.navy,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: EmanExperienceApp.gold),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.width,
    required this.number,
    required this.icon,
    required this.title,
    required this.text,
  });

  final double width;
  final String number;
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFFE8F5FF),
                    child: Icon(icon, color: EmanExperienceApp.blue),
                  ),
                  const Spacer(),
                  Text(
                    number,
                    style: const TextStyle(
                      color: Color(0xFFB8C5CE),
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  color: EmanExperienceApp.navy,
                ),
              ),
              const SizedBox(height: 9),
              Text(text, style: const TextStyle(height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardStat extends StatelessWidget {
  const _DashboardStat({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
    required this.trend,
  });

  final double width;
  final String title;
  final String value;
  final IconData icon;
  final String trend;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: EmanExperienceApp.blue, size: 29),
              const SizedBox(height: 22),
              Text(title, style: const TextStyle(color: Color(0xFF6D7D88))),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: EmanExperienceApp.navy,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                trend,
                style: const TextStyle(
                  color: Color(0xFF149567),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeadRow extends StatelessWidget {
  const _LeadRow({
    required this.company,
    required this.country,
    required this.stage,
    required this.value,
  });

  final String company;
  final String country;
  final String stage;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.business)),
      title: Text(company, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(country),
      trailing: Wrap(
        spacing: 16,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Chip(label: Text(stage)),
          SizedBox(
            width: 90,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  const _AdminCard({
    required this.width,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final double width;
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFEAF6FF),
                child: Icon(icon, color: EmanExperienceApp.blue),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Color(0xFF6D7D88)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApprovalRow extends StatelessWidget {
  const _ApprovalRow({
    required this.partner,
    required this.country,
    required this.deal,
    required this.commission,
  });

  final String partner;
  final String country;
  final String deal;
  final String commission;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(partner, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text('$country · Deal $deal'),
      trailing: Wrap(
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(commission, style: const TextStyle(fontWeight: FontWeight.w500)),
          FilledButton(onPressed: () {}, child: const Text('Approve')),
        ],
      ),
    );
  }
}
