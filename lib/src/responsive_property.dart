import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'predefined_screen_scopes.dart';
import 'screen_scope.dart';
import 'serialization/parse_json.dart';

/// A value that adapts to the screen size and orientation.
///
/// Inspired by Flutter's [WidgetStateProperty] (formerly
/// `MaterialStateProperty`), which resolves to a value based on the state of
/// a widget, a [Responsive] resolves to a value based on the screen. It maps
/// [ScreenScope]s to values, and [resolve] picks the value for the current
/// screen:
///
/// ```dart
/// GridView.count(
///   crossAxisCount: Responsive({
///         mobileScreenScope: 2,
///         tabletScreenScope: 4,
///         desktopScreenScope: 6,
///       }).resolve(context) ??
///       6,
///   children: children,
/// )
/// ```
///
/// Any type can be responsive, from numbers to whole widgets.
class Responsive<T> {
  /// Creates a responsive value from a map of screen scopes to values.
  ///
  /// The order of the map matters, see [resolve].
  Responsive(this.values);

  /// Creates a responsive value from a JSON map created by [toJson].
  ///
  /// The keys of [map] are JSON encoded [ScreenScope]s, see
  /// [parseScreenScope]. The values are converted with [decoder] when it is
  /// given, otherwise they must already be of type [T]. Without a [decoder],
  /// JSON integers are accepted for `double` values.
  ///
  /// ```dart
  /// final color = Responsive<Color>.fromJson(
  ///   map,
  ///   decoder: (value) => parseColor(value)!,
  /// );
  /// ```
  Responsive.fromJson(
    Map<String, dynamic> map, {
    T Function(dynamic element)? decoder,
  }) : values = map.map(
          (key, value) => MapEntry(
            parseScreenScope(json.decode(key) as Map<String, dynamic>),
            decoder == null ? _castJsonValue<T>(value) : decoder(value),
          ),
        );

  /// The value for each screen scope.
  ///
  /// When several scopes contain the screen, the one that comes last wins,
  /// see [resolve].
  Map<ScreenScope, T> values;

  /// Returns the value for the screen of [context].
  ///
  /// Uses the closest [MediaQuery] around [context], and registers [context]
  /// as a dependency of it, so a widget that calls this method in its build
  /// method rebuilds when the screen changes.
  ///
  /// The scopes in [values] are checked in order with
  /// [ScreenScope.isOfScreenScope]. Without [combine], the value of the last
  /// scope that contains the screen is returned. Put general scopes before
  /// more specific ones, and smaller screens before bigger ones, so the
  /// bigger screen wins on a shared breakpoint, like [tabletScreenScope] for
  /// a screen exactly 480 logical pixels wide in:
  ///
  /// ```dart
  /// Responsive({
  ///   mobileScreenScope: 2,
  ///   tabletScreenScope: 4,
  ///   desktopScreenScope: 6,
  /// })
  /// ```
  ///
  /// With [combine], all the values whose scopes contain the screen are
  /// combined in order, like CSS styles. The first call gets null as
  /// `previousValue`, and each next call gets the result of the previous one.
  /// For example, to merge text styles:
  ///
  /// ```dart
  /// style.resolve(
  ///   context,
  ///   (previousValue, element) => previousValue?.merge(element) ?? element,
  /// );
  /// ```
  ///
  /// Returns null if no scope contains the screen.
  T? resolve(
    BuildContext context, [
    T? Function(T? previousValue, T? element)? combine,
  ]) {
    if (values.isEmpty) return null;
    final MediaQueryData data = MediaQuery.of(context);
    T? result;
    for (final MapEntry(key: scope, :value) in values.entries) {
      if (scope.isOfScreenScope(data)) {
        result = combine == null ? value : combine(result, value);
      }
    }
    return result;
  }

  /// Converts this responsive value to a JSON map.
  ///
  /// The keys are the JSON encoded [ScreenScope.toJson] of the scopes, in
  /// the order of [values]. The values are converted with [encoder] when it is
  /// given, otherwise they are used as they are and must be JSON encodable.
  ///
  /// ```dart
  /// final map = Responsive<Color>(colors).toJson(
  ///   encoder: (color) => color?.toJson(),
  /// );
  /// ```
  ///
  /// Use [Responsive.fromJson] to convert it back.
  dynamic toJson({dynamic Function(T? element)? encoder}) {
    if (encoder != null) {
      return values.map(
        (key, value) => MapEntry(json.encode(key.toJson()), encoder(value)),
      );
    }
    return values.map(
      (key, value) => MapEntry(json.encode(key.toJson()), value),
    );
  }
}

/// Casts a decoded JSON [value] to [T].
///
/// JSON does not tell integers and doubles apart, so an integer is converted
/// to a double when [T] needs one.
T _castJsonValue<T>(dynamic value) {
  if (value is int && value is! T && 0.0 is T) return value.toDouble() as T;
  return value as T;
}
