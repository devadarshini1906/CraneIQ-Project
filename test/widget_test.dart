// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart'; // Matches your project name

void main() {
  testWidgets('CraneIQApp loads dashboard successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CraneIQApp());

    // Wait for frames to settle
    await tester.pumpAndSettle();

    // Verify that the dashboard page loads and shows the app title
    expect(find.text('CraneIQ'), findsOneWidget); // Checks for the app bar title
    expect(find.byType(Scaffold), findsOneWidget); // Ensures a scaffold is present

    // Optional: Verify a specific route or content (e.g., DashboardPage)
    // Adjust based on DashboardPage content
    // expect(find.text('Dashboard Content'), findsOneWidget); // Update with actual text
  });
}