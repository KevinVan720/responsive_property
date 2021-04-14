import 'package:flutter/material.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';

const double screenMaxDimension = 999999;

class ScreenScope {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;
  final Orientation? orientation;

  const ScreenScope({
    this.minWidth = 0.0,
    this.maxWidth = screenMaxDimension,
    this.minHeight = 0.0,
    this.maxHeight = screenMaxDimension,
    this.orientation,
  }) : assert(minWidth >= 0.0 &&
            minWidth <= maxWidth &&
            maxWidth <= screenMaxDimension &&
            minHeight >= 0.0 &&
            minHeight <= maxHeight &&
            maxHeight <= screenMaxDimension);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> rst = {};
    rst["minWidth"] = minWidth;
    rst["maxWidth"] = maxWidth;
    rst["minHeight"] = minHeight;
    rst["maxHeight"] = maxHeight;
    rst.updateNotNull("orientation", orientation?.toJson());

    return rst;
  }

  bool isOfScreenScope(MediaQueryData data) {
    Size size = data.size;
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
    if (other is ScreenScope) {
      if (this.minWidth == other.minWidth &&
          this.maxWidth == other.maxWidth &&
          this.minHeight == other.minHeight &&
          this.maxHeight == other.maxHeight &&
          this.orientation == other.orientation) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode =>
      hashValues(minWidth, maxWidth, minHeight, maxHeight, orientation);
}
