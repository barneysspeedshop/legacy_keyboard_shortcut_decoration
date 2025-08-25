import 'package:flutter/material.dart';
import 'package:legacy_keyboard_shortcut_decoration/legacy_keyboard_shortcut_decoration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LegacyKeyboardShortcutDecoration Example',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
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
  bool _showIndividualKeys = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LegacyKeyboardShortcutDecoration Example'),
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
            Row(
              children: [
                const Text('Show individual keys'),
                Switch(
                  value: _showIndividualKeys,
                  onChanged: (value) {
                    setState(() {
                      _showIndividualKeys = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_textController.text.isNotEmpty)
              LegacyKeyboardShortcut(
                key: const Key('shortcut_from_textfield'),
                shortcut: _textController.text,
                showIndividualKeys: _showIndividualKeys,
              ),
            const SizedBox(height: 20),
            const Text('Examples:'),
            const SizedBox(height: 10),
            const LegacyKeyboardShortcut(shortcut: 'F+ctrl'),
            const SizedBox(height: 10),
            const LegacyKeyboardShortcut(shortcut: 'ALT+SHIFT+T'),
            const SizedBox(height: 10),
            const LegacyKeyboardShortcut(shortcut: 'F11+ALT'),
          ],
        ),
      ),
    );
  }
}
