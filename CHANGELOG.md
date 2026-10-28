## 0.0.1

Initial release. The responsive feature originally from the animated_styled_widget package is now move
to this package.

## 0.0.2

Update README

## 0.0.3

Update example

## 0.0.4

Update README

## 0.0.5

Update comments

## 0.0.6

Update license.

## 0.0.7

Update dependency.

## 0.0.8

* Support the latest Flutter stable. Requires Dart 3.6 and Flutter 3.27 or
  newer.
* Fix the compile error on Flutter 3.27 and newer, where `hashValues` was
  removed (fix deprecation).
* No longer depend on Flutter's Material library, only on the widgets library.
* Fix `parseScreenScope` and `Responsive.fromJson` crashing when a screen scope
  in the JSON has missing or null bounds. They now get the `ScreenScope`
  defaults.
* Fix `Responsive<double>.fromJson` (without a decoder) rejecting JSON integers
  like `2`.
* `ScreenBuilder` constructors take an optional `key`, and
  `ScreenBuilder.builder` is now `const`.
* Add `ScreenScope.toString`.
* Update `flutter_class_parser` to ^0.2.6.
* Add API documentation, tests and lints, and update the README and example.
  The JSON format is unchanged.
