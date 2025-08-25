import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_example/main.dart';
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';

void main() {
  testWidgets('LegacyKeyboardShortcut example smoke test', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the initial UI is as expected.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);
    expect(find.byType(LegacyKeyboardShortcut), findsNWidgets(3));

    // Enter a shortcut in the text field.
    await tester.enterText(find.byType(TextField), 'CTRL+ALT+DEL');
    await tester.pump();

    // Verify that the new shortcut is displayed.
    final shortcutFinder = find.byKey(const Key('shortcut_from_textfield'));
    expect(shortcutFinder, findsOneWidget);

    expect(
      find.descendant(of: shortcutFinder, matching: find.text('CTRL')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shortcutFinder, matching: find.text('ALT')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: shortcutFinder, matching: find.text('DEL')),
      findsOneWidget,
    );
  });
}
