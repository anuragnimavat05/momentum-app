import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/main.dart';

void main() {
  testWidgets('Momentum app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MomentumApp(showOnboarding: false));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
