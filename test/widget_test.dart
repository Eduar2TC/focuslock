// This is a basic Flutter widget test.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focuslock/app/app.dart';

void main() {
  testWidgets('App loads without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FocusLockApp()));

    // Verify the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
