# responsive_property

Inspired by Flutter's MaterialProperty, gives you a responsive value based on the current screen dimension.

When a built-in Material component (like a ElevatedButton) builds itself based on some internal states (hovered, pressed, selected), it will call resolve() on some MaterialProperty and get the appropriate value. This package uses a similar interface, but the states are now screen scopes.

Most responsive packages is at the Widget level, but we can (and should) make anything responsive, from a single integer to a full Widget.

## The ScreenScope class

The ScreenScope is very similar to the BoxConstraint with minWidth, maxWidth, minHeight, and maxHeight, plus orientation. This defines the scope of the screen you want to target. It is named ScreenScope as there might be more properties we care about in addtion to the size of the screen in the future.

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
smallPortraitScreenScope (0px - 1000px width, landscape)
bigPortraitScreenScope (1000px - width, landscape)
```

But you can define ScreenScopes however you like.

## The Responsive class

Responsive<T> is the main class to use. It stores a map of Map<ScreenScope, T>. For example:

```dart
var responsive = Responsive({
  typicalMobileScreenScope: 2,
  typicalTabletScreenScope: 4,
  typicalDesktopScreenScope: 6
});
```

then you determines the actual value to use:
```dart
int value = responsive.resolve(context);
```

Internally, the resovle scans through the map and pick the last valid value. You can also provide a custom funtion:
```dart
T? combine(T? previousValue, T? element)
```
that will combine all valid values into a final value (e.g. something similar to CSS styles).

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

This gives you a responsive GridView with different cross axis count. Mobile:2, tablet:4, desktop:6, and 8 for even wider screens.

![responsive_int](https://i.imgur.com/2ULrZ7Z.gif)

## Responsive widget example

You can also directly build different widgets for different screen sizes.
```dart
Responsive({
    typicalMobileScreenScope: mobileWidget,
    typicalTabletScreenScope: tabletWidget,
    typicalDesktopScreenScope: desktopWidget,
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

The second one has access to the BuildContext.



