// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tp4/main.dart';

void main() {
  testWidgets('Movie app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text('🎬 Films récents'), findsOneWidget);

    // Verify that the loading indicator or error message is shown
    // (since we don't have a real API key in tests, it will show an error or loading state)
    final loadingIndicator = find.byType(CircularProgressIndicator);
    final errorIcon = find.byIcon(Icons.error_outline);
    
    // Either loading or error should be present initially
    // Check that at least one of them is found
    final hasLoading = tester.any(loadingIndicator);
    final hasError = tester.any(errorIcon);
    expect(
      hasLoading || hasError,
      isTrue,
      reason: 'App should show loading indicator or error message',
    );
  });
}
