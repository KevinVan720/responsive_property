import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

/// The largest screen width or height, in logical pixels, that a
/// [ScreenScope] can describe.
///
/// It is the default [ScreenScope.maxWidth] and [ScreenScope.maxHeight].
/// Screens that are wider or taller than this are not in any scope.
const double screenMaxDimension = 999999;

/// A range of screen sizes and, optionally, a screen orientation.
///
/// Like [BoxConstraints], a scope has a [minWidth], [maxWidth], [minHeight]
/// and [maxHeight]. A screen is in the scope if its width and height are in
/// these ranges, bounds included, and, if [orientation] is not null, it has
/// that orientation. See [isOfScreenScope].
///
/// Because the bounds are inclusive, two scopes that share a breakpoint, like
/// [mobileScreenScope] and [tabletScreenScope] at 480 pixels, both contain a
/// screen whose width is exactly the breakpoint. [Responsive.resolve] then
/// picks the scope that comes last in its map.
///
/// Scopes are compared by value, so they can be used as map keys.
///
/// See also:
///
///  * The predefined scopes, like [mobileScreenScope], [tabletScreenScope]
///    and [desktopScreenScope].
///  * [Responsive], which maps scopes to values.
@immutable
class ScreenScope {
  /// Creates a screen scope.
  ///
  /// The defaults cover every screen size and orientation. The minimums must
  /// not be negative or larger than the corresponding maximums, and the
  /// maximums must not be larger than [screenMaxDimension].
  const ScreenScope({
    this.minWidth = 0.0,
    this.maxWidth = screenMaxDimension,
    this.minHeight = 0.0,
    this.maxHeight = screenMaxDimension,
    this.orientation,
  }) : assert(
          minWidth >= 0.0 &&
              minWidth <= maxWidth &&
              maxWidth <= screenMaxDimension &&
              minHeight >= 0.0 &&
              minHeight <= maxHeight &&
              maxHeight <= screenMaxDimension,
        );

  /// The smallest screen width in this scope, in logical pixels.
  final double minWidth;

  /// The largest screen width in this scope, in logical pixels.
  final double maxWidth;

  /// The smallest screen height in this scope, in logical pixels.
  final double minHeight;

  /// The largest screen height in this scope, in logical pixels.
  final double maxHeight;

  /// The orientation of the screens in this scope, or null for any
  /// orientation.
  ///
  /// Like [MediaQueryData.orientation], a square screen is
  /// [Orientation.portrait].
  final Orientation? orientation;

  /// Converts this scope to a JSON map.
  ///
  /// The map always has the `minWidth`, `maxWidth`, `minHeight` and
  /// `maxHeight` keys and has an `orientation` key unless [orientation] is
  /// null. Use [parseScreenScope] to convert it back.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {
      'minWidth': minWidth,
      'maxWidth': maxWidth,
      'minHeight': minHeight,
      'maxHeight': maxHeight,
    };
    result.updateNotNull('orientation', orientation?.toJson());
    return result;
  }

  /// Whether a screen described by [data] is in this scope.
  ///
  /// Only the [MediaQueryData.size] of [data] and the
  /// [MediaQueryData.orientation] derived from it are used.
  bool isOfScreenScope(MediaQueryData data) {
    final Size size = data.size;
    if (minWidth > size.width ||
        minHeight > size.height ||
        maxWidth < size.width ||
        maxHeight < size.height) {
      return false;
    }
    if (orientation != null && data.orientation != orientation) {
      return false;
    }
    return true;
  }

  @override
  bool operator ==(Object other) {
    return other is ScreenScope &&
        minWidth == other.minWidth &&
        maxWidth == other.maxWidth &&
        minHeight == other.minHeight &&
        maxHeight == other.maxHeight &&
        orientation == other.orientation;
  }

  @override
  int get hashCode =>
      Object.hash(minWidth, maxWidth, minHeight, maxHeight, orientation);

  @override
  String toString() {
    final String orientationText =
        orientation == null ? '' : ', orientation: ${orientation!.name}';
    return 'ScreenScope(minWidth: $minWidth, maxWidth: $maxWidth, '
        'minHeight: $minHeight, maxHeight: $maxHeight$orientationText)';
  }
}
