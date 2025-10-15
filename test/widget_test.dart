import 'package:flutter_test/flutter_test.dart';
import 'package:project_2/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CookAndSpinApp());
    expect(find.text('Sweet Spin \'n\' Cook'), findsOneWidget);
  });
}
