## 1.1.0

* **FEATURE**: Keyboard shortcuts now respect the ambient text scaler (`MediaQuery.textScalerOf`), scaling padding, spacing, border width, and shadow dimensions accordingly.
* **FEATURE**: Shortcuts can include a literal `+` key by using consecutive `+` separators (e.g., `"CTRL++"` renders as Ctrl and +).
* **FEATURE**: `LegacyKeyboardShortcutDecoration.getBoxDecoration` now accepts an optional `scale` parameter for use in custom layouts.

## 1.0.0

* **BREAKING**: The `shortcut` property, which accepted a `String`, has been replaced with the `keys` property, which takes a `List<String>`. This allows for more robust key handling and removes the need for string parsing.
* **FEATURE**: Added support for the `SUPER` key.
* **FEATURE**: Exposed more properties for greater customization in `LegacyKeyboardShortcutDecoration`:
  * `keyColor`: Customize the background color of the key.
  * `textColor`: Customize the color of the key label text.
  * `plusSignColor`: Customize the color of the '+' separator.
  * `borderColor`: Customize the color of the border.
  * `borderWidth`: Customize the width of the border.
  * `shadowColor`: Customize the color of the shadow.
  * `shadowOffset`: Customize the offset of the shadow.
  * `shadowBlurRadius`: Customize the blur radius of the shadow.


## 0.0.6

* Complete the dartdoc

## 0.0.5

* Add github action to deploy. Add badges and example to README.md

## 0.0.4

* Add proper screenshot

## 0.0.3

* Prepare for initial release on pub.dev.

## 0.0.2

* Updated example to follow system theme.

## 0.0.1

* Initial release.
