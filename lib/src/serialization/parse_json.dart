import 'package:flutter_class_parser/flutter_class_parser.dart';

import '../screen_scope.dart';

/// Creates a [ScreenScope] from a JSON map created by [ScreenScope.toJson].
///
/// The bounds can be ints or doubles. Missing or null bounds get the defaults
/// of the [ScreenScope] constructor, and a missing, null or unknown
/// `orientation` means any orientation.
ScreenScope parseScreenScope(Map<String, dynamic> map) {
  return ScreenScope(
    minWidth: _toDouble(map['minWidth']) ?? 0.0,
    maxWidth: _toDouble(map['maxWidth']) ?? screenMaxDimension,
    minHeight: _toDouble(map['minHeight']) ?? 0.0,
    maxHeight: _toDouble(map['maxHeight']) ?? screenMaxDimension,
    orientation: parseOrientation(map['orientation']),
  );
}

/// Reads a JSON number, which can be an int or a double, as a double.
double? _toDouble(Object? value) => (value as num?)?.toDouble();
