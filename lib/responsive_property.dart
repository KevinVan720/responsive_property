/// Values that adapt to the screen size and orientation.
///
/// A [Responsive] maps [ScreenScope]s, ranges of screen sizes with an
/// optional orientation, to values, and [Responsive.resolve] picks the value
/// for the current screen:
///
/// ```dart
/// final columns = Responsive({
///   mobileScreenScope: 2,
///   tabletScreenScope: 4,
///   desktopScreenScope: 6,
/// }).resolve(context);
/// ```
///
/// [ScreenBuilder] shows a different widget on mobile, tablet and desktop
/// screens.
library;

export 'src/predefined_screen_scopes.dart';
export 'src/responsive_property.dart';
export 'src/screen_builder.dart';
export 'src/screen_scope.dart';
export 'src/serialization/parse_json.dart';
