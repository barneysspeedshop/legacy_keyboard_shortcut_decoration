import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';

Future<void> _withPlatform(
  TargetPlatform platform,
  Future<void> Function() body,
) async {
  debugDefaultTargetPlatformOverride = platform;
  try {
    await body();
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

void main() {
  testWidgets('LegacyKeyboardShortcut displays shortcut keys', (
    WidgetTester tester,
  ) async {
    await _withPlatform(TargetPlatform.linux, () async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LegacyKeyboardShortcut(shortcut: 'CTRL + C')),
        ),
      );

      expect(find.text('CTRL'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
    });
  });

  testWidgets('adapts Ctrl to Cmd on macOS', (WidgetTester tester) async {
    await _withPlatform(TargetPlatform.macOS, () async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegacyKeyboardShortcut(shortcut: 'Ctrl+Shift+S'),
          ),
        ),
      );

      expect(find.text('CMD'), findsOneWidget);
      expect(find.text('SHIFT'), findsOneWidget);
      expect(find.text('S'), findsOneWidget);
      expect(find.text('CTRL'), findsNothing);
    });
  });

  testWidgets('keeps Ctrl on Linux', (WidgetTester tester) async {
    await _withPlatform(TargetPlatform.linux, () async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LegacyKeyboardShortcut(shortcut: 'Ctrl+S')),
        ),
      );

      expect(find.text('CTRL'), findsOneWidget);
      expect(find.text('CMD'), findsNothing);
    });
  });

  testWidgets('adaptPrimaryModifier false keeps Ctrl on macOS', (
    WidgetTester tester,
  ) async {
    await _withPlatform(TargetPlatform.macOS, () async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: LegacyKeyboardShortcut(
              shortcut: 'Ctrl+C',
              adaptPrimaryModifier: false,
            ),
          ),
        ),
      );

      expect(find.text('CTRL'), findsOneWidget);
      expect(find.text('CMD'), findsNothing);
    });
  });

  test('formatPlatformShortcut rewrites Ctrl on Apple', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    try {
      expect(formatPlatformShortcut('Ctrl+= / Ctrl+-'), 'Cmd+= / Cmd+-');
      expect(formatPlatformShortcut('Ctrl+Shift+O'), 'Cmd+Shift+O');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test('formatPlatformShortcut leaves Ctrl on non-Apple', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      expect(formatPlatformShortcut('Ctrl+S'), 'Ctrl+S');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
