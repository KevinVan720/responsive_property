import 'package:flutter/cupertino.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:responsive_property/responsive_property.dart';

ScreenScope parseScreenScope(Map<String, dynamic> map) {
  double minWidth = map["minWidth"].toDouble() ?? 0;
  double maxWidth = map["maxWidth"].toDouble() ?? screenMaxDimension;
  double minHeight = map["minHeight"].toDouble() ?? 0;
  double maxHeight = map["maxHeight"].toDouble() ?? screenMaxDimension;
  Orientation? orientation = parseOrientation(map["orientation"]);
  return ScreenScope(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      orientation: orientation);
}
