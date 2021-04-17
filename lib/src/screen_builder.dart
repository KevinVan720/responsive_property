import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

///A predefined widget that accepts mobile, tablet and desktop widgets

class ScreenBuilder extends StatelessWidget {
  final WidgetBuilder mobileBuilder;
  final WidgetBuilder tabletBuilder;
  final WidgetBuilder desktopBuilder;

  ScreenBuilder({
    required Widget mobile,
    required Widget tablet,
    required Widget desktop,
  })  : mobileBuilder = _makeBuilder(mobile),
        tabletBuilder = _makeBuilder(tablet),
        desktopBuilder = _makeBuilder(desktop);

  ScreenBuilder.builder({
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
  });

  static WidgetBuilder _makeBuilder(Widget? widget) {
    return (context) {
      return widget ?? Container();
    };
  }

  @override
  Widget build(BuildContext context) {
    WidgetBuilder builder = Responsive<WidgetBuilder?>({
          mobileScreenScope: mobileBuilder,
          tabletScreenScope: tabletBuilder,
          desktopScreenScope: desktopBuilder
        }).resolve(context) ??
        desktopBuilder;
    return builder(context);
  }
}
