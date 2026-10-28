# responsive_property

Inspired by Flutter's MaterialStateProperty (now WidgetStateProperty), gives you a responsive value based on the current screen dimension.

When a built-in Material component (like an ElevatedButton) builds itself based on some internal states (hovered, pressed, selected), it will call resolve() on some WidgetStateProperty and get the appropriate value. This package uses a similar interface, but the states are now screen scopes.

Most responsive packages work at the Widget level, but we can (and should) make anything responsive, from a single integer to a full Widget.

The package only depends on Flutter's widgets library, so it works with Material, Cupertino or any other design system.

## The ScreenScope class

The ScreenScope is very similar to the BoxConstraints with minWidth, maxWidth, minHeight, and maxHeight, plus orientation. This defines the scope of the screen you want to target. It is named ScreenScope as there might be more properties we care about in addition to the size of the screen in the future.

```dart
const scope = ScreenScope(
  minWidth: 600,
  maxWidth: 1200,
  orientation: Orientation.landscape,
);
```

All values are in logical pixels and, like BoxConstraints, the bounds are inclusive. A screen is in the scope if its width is between minWidth and maxWidth, its height is between minHeight and maxHeight, and, if an orientation is given, it has that orientation (a square screen counts as portrait). The default ScreenScope() contains every screen.

There are some predefined ScreenScopes that you can use. If you want to target three screen types, use:
```
mobileScreenScope (0px - 480px width)
tabletScreenScope (480px - 840px width)
desktopScreenScope (840px -  width)
```
```
mobilePortraitScreenScope (0px - 480px width, portrait)
tabletPortraitScreenScope (480px - 840px width, portrait)
desktopPortraitScreenScope (840px - width, portrait)
```
```
mobileLandscapeScreenScope (0px - 840px width, landscape)
tabletLandscapeScreenScope (840px - 1200px width, landscape)
desktopLandscapeScreenScope (1200px - width, landscape)
```
Below is a simple demonstration of how the screen categorization works:
![screen_scope](https://i.imgur.com/jbqQxxJ.png)

If you want to target just two screen types, use:
```
smallScreenScope (0px - 600px width)
bigScreenScope (600px -  width)
```
```
smallPortraitScreenScope (0px - 600px width, portrait)
bigPortraitScreenScope (600px - width, portrait)
```
```
smallLandscapeScreenScope (0px - 1000px width, landscape)
bigLandscapeScreenScope (1000px - width, landscape)
```

Neighboring scopes share their breakpoint: a screen that is exactly 480px wide is in both mobileScreenScope and tabletScreenScope. See below for which value wins.

But you can define ScreenScopes however you like.

## The Responsive class

Responsive<T> is the main class to use. It stores a Map<ScreenScope, T>. For example:

```dart
var responsive = Responsive({
  mobileScreenScope: 2,
  tabletScreenScope: 4,
  desktopScreenScope: 6
});
```

then you determine the actual value to use:
```dart
int? value = responsive.resolve(context);
```

Internally, resolve scans through the map in order and picks the last valid value, so on a shared breakpoint the later scope wins (with the map above, a 480px wide screen gets 4 and an 840px wide screen gets 6). It returns null if no scope matches. resolve uses the closest MediaQuery, so a widget that calls it in its build method rebuilds when the screen size changes.

You can also provide a custom function:
```dart
T? combine(T? previousValue, T? element)
```
that will combine all valid values, in order, into a final value (e.g. something similar to CSS styles). The first call gets null as previousValue:
```dart
TextStyle? style = Responsive({
  const ScreenScope(): const TextStyle(fontSize: 14),
  desktopScreenScope: const TextStyle(fontWeight: FontWeight.bold),
}).resolve(
  context,
  (previousValue, element) => previousValue?.merge(element) ?? element,
);
```

## Responsive value example

```dart
GridView.count(
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  crossAxisCount: Responsive({
    mobileScreenScope: 2,
    tabletScreenScope: 4,
    desktopScreenScope: 6
  }).resolve(context) ??
  6,
  children: List.generate(30,
    (index) => Container(color: Colors.green, child: Text("TAP ME"))),
  )
```

This gives you a responsive GridView with different cross axis count. Mobile: 2, tablet: 4, desktop: 6.

![responsive_int](https://i.imgur.com/2ULrZ7Z.gif)

## Responsive widget example

You can also directly build different widgets for different screen sizes.
```dart
Responsive({
    mobileScreenScope: mobileWidget,
    tabletScreenScope: tabletWidget,
    desktopScreenScope: desktopWidget,
  }).resolve(context) ??
  desktopWidget;
```

I have also created a helper Widget called ScreenBuilder that can save you some time:
```dart
ScreenBuilder(
  mobile: mobile,
  tablet: tablet,
  desktop: desktop,
  );
```
```dart
ScreenBuilder.builder(
  mobileBuilder: mobileBuilder,
  tabletBuilder: tabletBuilder,
  desktopBuilder: desktopBuilder,
  )
```

The second one has access to the BuildContext. ScreenBuilder only looks at the screen width: below 480px it shows mobile, from 480px to below 840px tablet, and desktop otherwise.

![responsive_widget](https://i.imgur.com/VyivaXL.gif)

## JSON

A Responsive can be converted to and from JSON. The keys are the JSON encoded ScreenScopes. Values that are not JSON values themselves need an encoder and a decoder, for example the ones from the [flutter_class_parser](https://pub.dev/packages/flutter_class_parser) package:

```dart
Map<String, dynamic> map = Responsive<Color>({
  mobileScreenScope: Colors.red,
  desktopScreenScope: Colors.blue,
}).toJson(encoder: (color) => color?.toJson());

Responsive<Color> colors = Responsive<Color>.fromJson(
  map,
  decoder: (value) => parseColor(value)!,
);
```

A single ScreenScope is converted with toJson() and parseScreenScope().

