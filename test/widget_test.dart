import 'package:flutter_test/flutter_test.dart';
import 'package:hyperwash_app/main.dart';

void main() {
  testWidgets('HyperWash app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const HyperWashApp());

    expect(find.text('HyperWash'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
