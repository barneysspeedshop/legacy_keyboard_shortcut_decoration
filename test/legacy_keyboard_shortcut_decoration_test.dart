import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';

void main() {
  testWidgets('LegacyKeyboardShortcut displays shortcut keys', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: LegacyKeyboardShortcut(shortcut: 'CTRL + C')),
      ),
    );

    // Verify that the shortcut keys are displayed.
    expect(find.text('CTRL'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
  });
}
