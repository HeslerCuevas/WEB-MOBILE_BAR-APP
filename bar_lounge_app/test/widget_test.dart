import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bar_lounge_app/app.dart';

void main() {
  testWidgets('App should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(const NocturnalApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
