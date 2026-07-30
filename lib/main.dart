import 'package:flutter/material.dart';

void main() {
  runApp(const EmanExperienceApp());
}

class EmanExperienceApp extends StatelessWidget {
  const EmanExperienceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eman Experience',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F3EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14372F),
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
      ),
      home: const ExperienceHomePage(),
    );
  }
}

class ExperienceHomePage extends StatelessWidget {
  const ExperienceHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8F5EF),
                    Color(0xFFEDE3D1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -170,
            right: -120,
            child: _GlowOrb(
              size: 520,
              color: const Color(0xFFB9D3C4).withValues(alpha: .48),
            ),
          ),
          Positioned(
            bottom: -180,
            left: -120,
            child: _GlowOrb(
              size: 430,
              color: const Color(0xFFD5B06E).withValues(alpha: .28),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 900;
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: compact ? 24 : 64,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      _TopBar(compact: compact),
                      SizedBox(height: compact ? 56 : 90),
                      _HeroSection(compact: compact),
                      const SizedBox(height: 56),
                      const _BrandStrip(),
                      const SizedBox(height: 36),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF14372F),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'E',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 14),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EMAN',
              style: TextStyle(
                color: Color(0xFF14372F),
                fontSize: 20,
                height: 1,
                fontWeight: FontWeight.w900,
                letterSpacing: 2.4,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'AGRO EXPERIENCE',
              style: TextStyle(
                color: Color(0xFF6D756F),
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
              ),
            ),
          ],
        ),
        const Spacer(),
        if (!compact) ...[
          const _NavItem('Brands'),
          const _NavItem('Products'),
          const _NavItem('Private Label'),
          const _NavItem('About'),
          const SizedBox(width: 22),
        ],
        FilledButton(
          onPressed: () {},
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF14372F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(compact ? 'Explore' : 'Start the experience'),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF3F4D47),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final copy = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .7),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white),
          ),
          child: const Text(
            'A NEW DIGITAL SHOWROOM',
            style: TextStyle(
              color: Color(0xFF7B6848),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.7,
            ),
          ),
        ),
        const SizedBox(height: 26),
        Text(
          'Taste the future\nof food brands.',
          style: TextStyle(
            color: const Color(0xFF14372F),
            fontSize: compact ? 48 : 74,
            height: .98,
            fontWeight: FontWeight.w900,
            letterSpacing: -2.8,
          ),
        ),
        const SizedBox(height: 26),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: const Text(
            'Explore Eman Agro through an immersive premium catalog built for products, partners and private-label opportunities.',
            style: TextStyle(
              color: Color(0xFF5D6862),
              fontSize: 18,
              height: 1.6,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 34),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('Discover our brands'),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF14372F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_circle_outline_rounded),
              label: const Text('Watch presentation'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF14372F),
                side: const BorderSide(color: Color(0xFFBAC6BE)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    const visual = _ShowroomVisual();

    if (compact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [copy, const SizedBox(height: 48), visual],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 11, child: copy),
        const SizedBox(width: 46),
        const Expanded(flex: 9, child: visual),
      ],
    );
  }
}

class _ShowroomVisual extends StatelessWidget {
  const _ShowroomVisual();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .95,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF14372F),
              borderRadius: BorderRadius.circular(44),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3014372F),
                  blurRadius: 60,
                  offset: Offset(0, 24),
                ),
              ],
            ),
          ),
          Positioned(
            top: 28,
            left: 28,
            right: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'CURATED\nCOLLECTION 01',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.north_east_rounded, color: Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
            left: 34,
            right: 34,
            bottom: 34,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF4E9D6),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VALORI',
                    style: TextStyle(
                      color: Color(0xFF14372F),
                      fontSize: 44,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Refreshing ideas.\nMade for everyday moments.',
                    style: TextStyle(
                      color: Color(0xFF52625B),
                      fontSize: 17,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 116,
            right: 46,
            child: Transform.rotate(
              angle: -.08,
              child: Container(
                width: 170,
                height: 230,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFF2B454), Color(0xFFE26635)],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white54, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 30,
                      offset: Offset(0, 16),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'V',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 54,
                        height: 1,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Spacer(),
                    Text(
                      'JUICE\nDRINK',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.05,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandStrip extends StatelessWidget {
  const _BrandStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .62),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white),
      ),
      child: const Wrap(
        alignment: WrapAlignment.spaceAround,
        spacing: 38,
        runSpacing: 18,
        children: [
          _BrandName('VALORI'),
          _BrandName('FRIO'),
          _BrandName('ROYA'),
          _BrandName('FRESH'),
          _BrandName('PRIVATE LABEL'),
        ],
      ),
    );
  }
}

class _BrandName extends StatelessWidget {
  const _BrandName(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF6A756F),
        fontSize: 13,
        fontWeight: FontWeight.w900,
        letterSpacing: 2.1,
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
