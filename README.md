# Legacy Keyboard Shortcut Decoration

A Flutter package to display keyboard shortcuts with a nice, key-like decoration.
Pass a string like `"CTRL + C"` and get a widget that visually represents the key combination.

![Legacy Keyboard Shortcut Decoration](https://github.com/barneysspeedshop/legacy_keyboard_shortcut_decoration/raw/main/assets/example.png)

## Features

*   Display keyboard shortcuts from a string.
*   Theme-aware: Adapts to light and dark mode.
*   Customize border radius, spacing, and more.
*   Simple and lightweight.
*   Handles multiple key combinations (e.g., "CTRL + ALT + DEL").

## Getting started

Add the package to your `pubspec.yaml`:
```yaml
dependencies:
  legacy_keyboard_shortcut_decoration: ^0.0.2
```

Then import the package in your Dart code:
```dart
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';

void main() {
  runApp(const MyApp());
}

final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'LegacyKeyboardShortcutDecoration Example',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LegacyKeyboardShortcutDecoration Example'),
        actions: [
          Switch(
            value: _themeNotifier.value == ThemeMode.dark,
            onChanged: (value) {
              _themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Enter shortcut',
                hintText: 'e.g. Ctrl+S',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            if (_textController.text.isNotEmpty)
              LegacyKeyboardShortcut(
                shortcut: _textController.text,
              ),
          ],
        ),
      ),
    );
  }
}
```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
