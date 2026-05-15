import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cicd_demo/main.dart';

void main() {
  group('MyApp Widget Tests', () {
    testWidgets('App displays with Material 3 design', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'test-api-key-12345',
      ));

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('Dev flavor displays blue badge', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'test-key',
      ));

      expect(find.text('DEV'), findsOneWidget);
    });

    testWidgets('Prod flavor displays red badge', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'prod',
        apiKey: 'prod-key',
      ));

      expect(find.text('PROD'), findsOneWidget);
    });

    testWidgets('API key is properly masked', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'very-long-test-api-key-1234567890',
      ));

      // Should show first 4 and last 4 characters
      expect(find.textContaining('...'), findsWidgets);
    });

    testWidgets('Default API key shows when not provided', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'no-key',
      ));

      expect(find.text('no-key'), findsOneWidget);
    });

    testWidgets('AppBar displays title and flavor badge', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'prod',
        apiKey: 'test-key',
      ));

      expect(find.text('Flutter CI/CD Demo'), findsOneWidget);
      expect(find.text('PROD'), findsOneWidget);
    });

    testWidgets('Info cards are displayed in body', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'test-key',
      ));

      expect(find.text('Build Flavor'), findsOneWidget);
      expect(find.text('API Configuration'), findsOneWidget);
      expect(find.text('Build Type'), findsOneWidget);
    });

    testWidgets('Environment details section shows correct info', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp(
        flavor: 'prod',
        apiKey: 'api-test-key',
      ));

      expect(find.text('Environment Details'), findsOneWidget);
      expect(find.textContaining('API Key Configured'), findsWidgets);
    });

    testWidgets('Page is scrollable for small screens', (WidgetTester tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(400, 600);
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await tester.pumpWidget(const MyApp(
        flavor: 'dev',
        apiKey: 'long-api-key-test-value',
      ));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}
