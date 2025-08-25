import 'package:flutter/material.dart';

/// A widget that displays a keyboard shortcut combination with a visual
/// representation of keyboard keys.
///
/// It takes a [shortcut] string like `"CTRL + C"` and renders it as a row
/// of styled widgets that look like keyboard keys.
class LegacyKeyboardShortcut extends StatelessWidget {
  /// The string representation of the keyboard shortcut, e.g., "CTRL + C".
  /// The keys should be separated by '+'.
  final String shortcut;

  /// The decoration of the key.
  final LegacyKeyboardShortcutDecoration decoration;

  /// Whether to show the shortcut as individual keys or as a single block.
  final bool showIndividualKeys;

  /// Creates a widget to display a keyboard shortcut.
  ///
  /// The [shortcut] string is parsed by splitting on '+'. Each part is trimmed
  /// and displayed as a separate key.
  const LegacyKeyboardShortcut({
    super.key,
    required this.shortcut,
    this.decoration = const LegacyKeyboardShortcutDecoration(),
    this.showIndividualKeys = true,
  });

  static const _modifierKeys = ['CTRL', 'ALT', 'SHIFT', 'META'];
  static const _functionKeys = [
    'F1',
    'F2',
    'F3',
    'F4',
    'F5',
    'F6',
    'F7',
    'F8',
    'F9',
    'F10',
    'F11',
    'F12',
  ];

  @override
  Widget build(BuildContext context) {
    // Split the shortcut string into individual key strings,
    // trimming whitespace and removing any empty parts.
    final keys = _sortKeys(shortcut);

    if (keys.isEmpty) {
      return const SizedBox.shrink();
    }

    if (showIndividualKeys) {
      return _buildIndividualKeys(context, keys);
    } else {
      return _buildSingleBlock(context, keys);
    }
  }

  List<String> _sortKeys(String shortcut) {
    final keys = shortcut
        .split('+')
        .map((e) => e.trim().toUpperCase())
        .where((e) => e.isNotEmpty)
        .toList();

    final List<String> modifierKeys = [];
    final List<String> functionKeys = [];
    final List<String> otherKeys = [];

    for (final key in keys) {
      if (_modifierKeys.contains(key)) {
        modifierKeys.add(key);
      } else if (_functionKeys.contains(key)) {
        functionKeys.add(key);
      } else {
        otherKeys.add(key);
      }
    }

    modifierKeys.sort(
      (a, b) => _modifierKeys.indexOf(a).compareTo(_modifierKeys.indexOf(b)),
    );
    functionKeys.sort(
      (a, b) => _functionKeys.indexOf(a).compareTo(_functionKeys.indexOf(b)),
    );
    otherKeys.sort();

    return [...modifierKeys, ...functionKeys, ...otherKeys];
  }

  Widget _buildSingleBlock(BuildContext context, List<String> keys) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: decoration.padding,
      decoration: decoration.getBoxDecoration(context),
      child: Text(
        keys.join(' + ').toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: decoration.fontSize,
          fontWeight: decoration.fontWeight,
        ),
      ),
    );
  }

  Widget _buildIndividualKeys(BuildContext context, List<String> keys) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    final List<Widget> children = [];
    for (int i = 0; i < keys.length; i++) {
      children.add(_buildKey(context, keys[i]));

      // Add a separator if it's not the last key.
      if (i < keys.length - 1) {
        children.add(SizedBox(width: decoration.spacing / 2));
        children.add(
          Text(
            '+',
            style: TextStyle(
              fontSize: decoration.fontSize,
              fontWeight: FontWeight.normal,
              color: textColor.withAlpha(204),
            ),
          ),
        );
        children.add(SizedBox(width: decoration.spacing / 2));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  /// Builds a single key widget.
  Widget _buildKey(BuildContext context, String keyLabel) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      padding: decoration.padding,
      decoration: decoration.getBoxDecoration(context),
      child: Text(
        keyLabel.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontSize: decoration.fontSize,
          fontWeight: decoration.fontWeight,
        ),
      ),
    );
  }
}

class LegacyKeyboardShortcutDecoration {
  /// The border radius of the key.
  final BorderRadius borderRadius;

  /// The padding inside the key.
  final EdgeInsets padding;

  /// The spacing between keys and the '+' separator.
  final double spacing;

  /// The font size of the key label.
  final double fontSize;

  /// The font weight of the key label.
  final FontWeight fontWeight;

  const LegacyKeyboardShortcutDecoration({
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.spacing = 8.0,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.bold,
  });

  BoxDecoration getBoxDecoration(BuildContext context) {
    final theme = Theme.of(context);
    final keyColor = theme.colorScheme.surface;
    final borderColor = theme.colorScheme.onSurface.withAlpha(51);
    final shadowColor = theme.colorScheme.onSurface.withAlpha(51);

    return BoxDecoration(
      color: keyColor,
      borderRadius: borderRadius,
      border: Border.all(color: borderColor),
      boxShadow: [
        BoxShadow(
          color: shadowColor,
          offset: const Offset(0, 1),
          blurRadius: 1.0,
        ),
      ],
    );
  }
}
