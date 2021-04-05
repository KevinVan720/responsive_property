import 'package:responsive_property/responsive_property.dart';

ScreenScope parseScreenScope(Map<String, dynamic> map) {
  double minWidth = map["minWidth"].toDouble() ?? 0;
  double maxWidth = map["maxWidth"].toDouble() ?? screenMaxDimension;
  double minHeight = map["minHeight"].toDouble() ?? 0;
  double maxHeight = map["maxHeight"].toDouble() ?? screenMaxDimension;
  return ScreenScope(
      minWidth: minWidth,
      minHeight: minHeight,
      maxWidth: maxWidth,
      maxHeight: maxHeight);
}
