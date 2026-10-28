import 'package:flutter/widgets.dart';

import 'predefined_screen_scopes.dart';
import 'responsive_property.dart';

/// A widget that shows a different child on mobile, tablet and desktop
/// screens.
///
/// The child is picked with [mobileScreenScope], [tabletScreenScope] and
/// [desktopScreenScope], based on the screen width only:
///
///  * mobile: narrower than 480 logical pixels,
///  * tablet: from 480 up to, but not including, 840 logical pixels,
///  * desktop: 840 logical pixels and wider.
///
/// ```dart
/// ScreenBuilder(
///   mobile: const Text('mobile'),
///   tablet: const Text('tablet'),
///   desktop: const Text('desktop'),
/// )
/// ```
///
/// Use [ScreenBuilder.builder] to build the child lazily, with access to the
/// [BuildContext].
class ScreenBuilder extends StatelessWidget {
  /// Creates a widget that shows [mobile], [tablet] or [desktop], depending
  /// on the screen width.
  ScreenBuilder({
    super.key,
    required Widget mobile,
    required Widget tablet,
    required Widget desktop,
  })  : mobileBuilder = _makeBuilder(mobile),
        tabletBuilder = _makeBuilder(tablet),
        desktopBuilder = _makeBuilder(desktop);

  /// Creates a widget that calls [mobileBuilder], [tabletBuilder] or
  /// [desktopBuilder], depending on the screen width.
  const ScreenBuilder.builder({
    super.key,
    required this.mobileBuilder,
    required this.tabletBuilder,
    required this.desktopBuilder,
  });

  /// Builds the child on mobile screens.
  final WidgetBuilder mobileBuilder;

  /// Builds the child on tablet screens.
  final WidgetBuilder tabletBuilder;

  /// Builds the child on desktop screens, and on screens that are wider than
  /// [screenMaxDimension].
  final WidgetBuilder desktopBuilder;

  static WidgetBuilder _makeBuilder(Widget widget) => (context) => widget;

  @override
  Widget build(BuildContext context) {
    final WidgetBuilder builder = Responsive<WidgetBuilder>({
          mobileScreenScope: mobileBuilder,
          tabletScreenScope: tabletBuilder,
          desktopScreenScope: desktopBuilder,
        }).resolve(context) ??
        desktopBuilder;
    return builder(context);
  }
}
