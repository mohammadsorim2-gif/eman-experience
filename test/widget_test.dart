import 'package:eman_experience/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the premium B2B homepage', (tester) async {
    await tester.pumpWidget(const EmanExperienceApp());

    expect(find.text('From bold idea\nto global shelf.'), findsOneWidget);
    expect(find.text('Get in touch'), findsOneWidget);
    expect(find.text('Build your product'), findsOneWidget);
  });

  testWidgets('opens and validates the partnership form', (tester) async {
    await tester.pumpWidget(const EmanExperienceApp());

    await tester.tap(find.text('Get in touch'));
    await tester.pumpAndSettle();

    expect(find.text('Start a conversation'), findsOneWidget);
    final submit = find.text('Send partnership brief');
    await tester.ensureVisible(submit);
    await tester.tap(submit);
    await tester.pump();
    expect(find.text('Please complete this field'), findsNWidgets(3));
  });
}
