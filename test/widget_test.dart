// Basic smoke test for the News App.

import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/main.dart';

void main() {
  testWidgets('NewsApp smoke test — bottom nav renders', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const NewsApp());

    // Verify the three bottom navigation labels are present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
