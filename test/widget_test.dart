import 'package:eman_experience/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('renders the international manufacturer homepage', (
    tester,
  ) async {
    await tester.pumpWidget(const EmanExperienceApp());
    await tester.pumpAndSettle();

    expect(find.text('EMAN'), findsWidgets);
    expect(find.text('Quality beverages. Made for the world.'), findsOneWidget);
    expect(find.text('Explore Products'), findsOneWidget);
  });

  testWidgets('switches to Arabic with RTL layout', (tester) async {
    await tester.pumpWidget(const EmanExperienceApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('العربية').last);
    await tester.pumpAndSettle();

    expect(find.text('مشروبات عالية الجودة. صُنعت للعالم.'), findsOneWidget);
    final hasRtl = tester
        .widgetList<Directionality>(find.byType(Directionality))
        .any((widget) => widget.textDirection == TextDirection.rtl);
    expect(hasRtl, isTrue);
  });

  testWidgets('persists the selected language', (tester) async {
    SharedPreferences.setMockInitialValues({'eman_language': 'tr'});
    await tester.pumpWidget(const EmanExperienceApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Kaliteli içecekler. Dünya için üretildi.'),
      findsOneWidget,
    );
  });
}
