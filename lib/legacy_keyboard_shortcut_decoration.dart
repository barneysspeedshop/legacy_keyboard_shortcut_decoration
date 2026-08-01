import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// True when the platform's primary accelerator is Cmd (macOS / iOS).
bool get usesMetaPrimaryModifier =>
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.iOS;

/// Rewrites authored `Ctrl` / `Control` tokens for display on the current
/// platform.
///
/// On Apple platforms those tokens become `Cmd`. Elsewhere the string is
/// returned unchanged. Works for single shortcuts (`Ctrl+S`) and free text
/// that embeds them (`Ctrl+= / Ctrl+-`).
///
/// Set [adaptPrimaryModifier] to `false` to skip the Ctrl→Cmd rewrite.
String formatPlatformShortcut(
  String shortcut, {
  bool adaptPrimaryModifier = true,
}) {
  if (!adaptPrimaryModifier || !usesMetaPrimaryModifier) return shortcut;
  return shortcut.replaceAllMapped(
    RegExp(r'\bControl\b|\bCtrl\b', caseSensitive: false),
    (_) => 'Cmd',
  );
}

List<String> _splitShortcutParts(String shortcut) {
  final parts = shortcut.split('+');
  final keys = <String>[];
  for (var i = 0; i < parts.length; i++) {
    final part = parts[i].trim();
    if (part.isNotEmpty) {
      keys.add(part);
    } else if (i < parts.length - 1) {
      // Consecutive `+` separators encode a literal `+` key (e.g. `Ctrl++`).
      keys.add('+');
    }
  }
  return keys;
}

/// A widget that displays a keyboard shortcut combination with a visual
/// representation of keyboard keys.
///
/// It takes a [shortcut] string like `"CTRL + C"` and renders it as a row
/// of styled widgets that look like keyboard keys.
///
/// On macOS and iOS, when [adaptPrimaryModifier] is true (the default), `Ctrl`
/// and `Control` are displayed as `Cmd` so menus match Apple conventions while
/// call sites can keep authoring shortcuts with Ctrl.
class LegacyKeyboardShortcut extends StatelessWidget {
  /// The string representation of the keyboard shortcut, e.g., "CTRL + C".
  /// The keys should be separated by '+'.
  final String shortcut;

  /// The decoration of the key.
  final LegacyKeyboardShortcutDecoration decoration;

  /// Whether to show the shortcut as individual keys or as a single block.
  final bool showIndividualKeys;

  /// When true (default), replaces Ctrl with Cmd on Apple platforms.
  final bool adaptPrimaryModifier;

  /// Creates a widget to display a keyboard shortcut.
  ///
  /// The [shortcut] string is parsed by splitting on '+'. Each part is trimmed
  /// and displayed as a separate key.
  const LegacyKeyboardShortcut({
    super.key,
    required this.shortcut,
    this.decoration = const LegacyKeyboardShortcutDecoration(),
    this.showIndividualKeys = true,
    this.adaptPrimaryModifier = true,
  });

  /// A list of modifier keys in a specific order for sorting.
  ///
  /// Includes both Ctrl (non-Apple primary) and Cmd (Apple primary) so mixed
  /// authored strings sort correctly after platform adaptation.
  static const _modifierKeys = [
    'CTRL',
    'ALT',
    'SHIFT',
    'CMD',
    'META',
    'SUPER',
  ];

  /// A list of function keys in a specific order for sorting.
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
    final textScaler =
        MediaQuery.maybeTextScalerOf(context) ?? TextScaler.noScaling;
    final scale = textScaler.scale(1.0);

    if (keys.isEmpty) {
      return const SizedBox.shrink();
    }

    if (showIndividualKeys) {
      return _buildIndividualKeys(context, keys, scale);
    } else {
      return _buildSingleBlock(context, keys, scale);
    }
  }

  /// Normalizes a single key token for sorting / display.
  String _normalizeKey(String key) {
    final upper = key.toUpperCase();
    switch (upper) {
      case 'CONTROL':
        return 'CTRL';
      case 'COMMAND':
      case 'CMD':
      case '⌘':
        return 'CMD';
      case 'OPTION':
      case 'OPT':
      case '⌥':
        return 'ALT';
      default:
        return upper;
    }
  }

  /// Sorts the keys in the shortcut string.
  ///
  /// Modifier keys are sorted first, then function keys, then other keys alphabetically.
  List<String> _sortKeys(String shortcut) {
    final adapted = formatPlatformShortcut(
      shortcut,
      adaptPrimaryModifier: adaptPrimaryModifier,
    );
    final parts = _splitShortcutParts(adapted);
    final keys = parts.map(_normalizeKey).toList();

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

  /// Builds the shortcut as a single visual block.
  Widget _buildSingleBlock(
    BuildContext context,
    List<String> keys,
    double scale,
  ) {
    final theme = Theme.of(context);
    final textColor = decoration.textColor ?? theme.colorScheme.onSurface;

    return Container(
      padding: decoration.padding * scale,
      decoration: decoration.getBoxDecoration(context, scale: scale),
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

  /// Builds the shortcut as a series of individual key widgets.
  Widget _buildIndividualKeys(
    BuildContext context,
    List<String> keys,
    double scale,
  ) {
    final theme = Theme.of(context);
    final plusSignColor = decoration.plusSignColor ??
        (decoration.textColor ?? theme.colorScheme.onSurface).withAlpha(204);

    final List<Widget> children = [];
    for (int i = 0; i < keys.length; i++) {
      children.add(_buildKey(context, keys[i], scale));

      // Add a separator if it's not the last key.
      if (i < keys.length - 1) {
        children.add(SizedBox(width: (decoration.spacing / 2) * scale));
        children.add(
          Text(
            '+',
            style: TextStyle(
              fontSize: decoration.fontSize,
              fontWeight: FontWeight.normal,
              color: plusSignColor,
            ),
          ),
        );
        children.add(SizedBox(width: (decoration.spacing / 2) * scale));
      }
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  /// Builds a single key widget.
  Widget _buildKey(BuildContext context, String keyLabel, double scale) {
    final theme = Theme.of(context);
    final textColor = decoration.textColor ?? theme.colorScheme.onSurface;

    return Container(
      padding: decoration.padding * scale,
      decoration: decoration.getBoxDecoration(context, scale: scale),
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

/// Defines the visual appearance of the [LegacyKeyboardShortcut] widget.
class LegacyKeyboardShortcutDecoration {
  /// The background color of the key.
  ///
  /// If null, `Theme.of(context).colorScheme.surface` is used.
  final Color? keyColor;

  /// The color of the key label text.
  ///
  /// If null, `Theme.of(context).colorScheme.onSurface` is used.
  final Color? textColor;

  /// The color of the '+' separator between keys.
  ///
  /// If null, it defaults to `textColor` with an alpha of 204.
  final Color? plusSignColor;

  /// The color of the border around the key.
  final Color? borderColor;

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

  /// The width of the border.
  final double borderWidth;

  /// The color of the shadow.
  final Color? shadowColor;

  /// The offset of the shadow.
  final Offset shadowOffset;

  /// The blur radius of the shadow.
  final double shadowBlurRadius;

  /// Creates a decoration for the [LegacyKeyboardShortcut] widget.
  const LegacyKeyboardShortcutDecoration({
    this.keyColor,
    this.textColor,
    this.plusSignColor,
    this.borderColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
    this.spacing = 8.0,
    this.fontSize = 14.0,
    this.fontWeight = FontWeight.bold,
    this.borderWidth = 1.0,
    this.shadowColor,
    this.shadowOffset = const Offset(0, 1),
    this.shadowBlurRadius = 1.0,
  });

  /// Creates a [BoxDecoration] for the keys based on the current theme.
  BoxDecoration getBoxDecoration(BuildContext context, {double scale = 1.0}) {
    final theme = Theme.of(context);
    final finalKeyColor = keyColor ?? theme.colorScheme.surface;
    final finalBorderColor =
        borderColor ?? theme.colorScheme.onSurface.withAlpha(51);
    final finalShadowColor =
        shadowColor ?? theme.colorScheme.onSurface.withAlpha(51);

    return BoxDecoration(
      color: finalKeyColor,
      borderRadius: borderRadius,
      border: Border.all(
        color: finalBorderColor,
        width: borderWidth * scale,
      ),
      boxShadow: [
        BoxShadow(
          color: finalShadowColor,
          offset: shadowOffset * scale,
          blurRadius: shadowBlurRadius * scale,
        ),
      ],
    );
  }
}
