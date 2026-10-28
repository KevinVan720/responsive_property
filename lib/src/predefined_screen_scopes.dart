// Predefined screen scopes.
//
// With two breakpoints the screens are split into mobile, tablet and desktop
// screens, with one breakpoint into small and big screens. Each split is also
// available for portrait and for landscape screens only.
//
// Adjacent scopes share their breakpoint, and both contain a screen exactly as
// wide as the breakpoint, see ScreenScope.

import 'package:flutter/widgets.dart';

import 'screen_scope.dart';

/// The breakpoint, in logical pixels, between [mobileScreenScope] and
/// [tabletScreenScope], and between their portrait versions.
const double mobileScreenWidthLimit = 480.0;

/// The breakpoint, in logical pixels, between [tabletScreenScope] and
/// [desktopScreenScope], between their portrait versions, and between
/// [mobileLandscapeScreenScope] and [tabletLandscapeScreenScope].
const double tabletScreenWidthLimit = 840.0;

/// The breakpoint, in logical pixels, between [tabletLandscapeScreenScope]
/// and [desktopLandscapeScreenScope].
const double desktopScreenWidthLimit = 1200.0;

/// The breakpoint, in logical pixels, between [smallScreenScope] and
/// [bigScreenScope], and between their portrait versions.
const double smallScreenWidthLimit = 600;

/// The breakpoint, in logical pixels, between [smallLandscapeScreenScope] and
/// [bigLandscapeScreenScope].
///
/// Like all breakpoints, it is compared with the screen width, which is the
/// longer side of a landscape screen.
const double smallScreenHeightLimit = 1000.0;

/// Screens up to [mobileScreenWidthLimit] (480) logical pixels wide.
const mobileScreenScope = ScreenScope(maxWidth: mobileScreenWidthLimit);

/// Screens from [mobileScreenWidthLimit] (480) to [tabletScreenWidthLimit]
/// (840) logical pixels wide.
const tabletScreenScope = ScreenScope(
  minWidth: mobileScreenWidthLimit,
  maxWidth: tabletScreenWidthLimit,
);

/// Screens at least [tabletScreenWidthLimit] (840) logical pixels wide.
const desktopScreenScope = ScreenScope(minWidth: tabletScreenWidthLimit);

/// Screens up to [smallScreenWidthLimit] (600) logical pixels wide.
const smallScreenScope = ScreenScope(maxWidth: smallScreenWidthLimit);

/// Screens at least [smallScreenWidthLimit] (600) logical pixels wide.
const bigScreenScope = ScreenScope(minWidth: smallScreenWidthLimit);

/// Portrait screens up to [mobileScreenWidthLimit] (480) logical pixels wide.
const mobilePortraitScreenScope = ScreenScope(
  maxWidth: mobileScreenWidthLimit,
  orientation: Orientation.portrait,
);

/// Portrait screens from [mobileScreenWidthLimit] (480) to
/// [tabletScreenWidthLimit] (840) logical pixels wide.
const tabletPortraitScreenScope = ScreenScope(
  minWidth: mobileScreenWidthLimit,
  maxWidth: tabletScreenWidthLimit,
  orientation: Orientation.portrait,
);

/// Portrait screens at least [tabletScreenWidthLimit] (840) logical pixels
/// wide.
const desktopPortraitScreenScope = ScreenScope(
  minWidth: tabletScreenWidthLimit,
  orientation: Orientation.portrait,
);

/// Portrait screens up to [smallScreenWidthLimit] (600) logical pixels wide.
const smallPortraitScreenScope = ScreenScope(
  maxWidth: smallScreenWidthLimit,
  orientation: Orientation.portrait,
);

/// Portrait screens at least [smallScreenWidthLimit] (600) logical pixels
/// wide.
const bigPortraitScreenScope = ScreenScope(
  minWidth: smallScreenWidthLimit,
  orientation: Orientation.portrait,
);

/// Landscape screens up to [tabletScreenWidthLimit] (840) logical pixels
/// wide.
const mobileLandscapeScreenScope = ScreenScope(
  maxWidth: tabletScreenWidthLimit,
  orientation: Orientation.landscape,
);

/// Landscape screens from [tabletScreenWidthLimit] (840) to
/// [desktopScreenWidthLimit] (1200) logical pixels wide.
const tabletLandscapeScreenScope = ScreenScope(
  minWidth: tabletScreenWidthLimit,
  maxWidth: desktopScreenWidthLimit,
  orientation: Orientation.landscape,
);

/// Landscape screens at least [desktopScreenWidthLimit] (1200) logical pixels
/// wide.
const desktopLandscapeScreenScope = ScreenScope(
  minWidth: desktopScreenWidthLimit,
  orientation: Orientation.landscape,
);

/// Landscape screens up to [smallScreenHeightLimit] (1000) logical pixels
/// wide.
const smallLandscapeScreenScope = ScreenScope(
  maxWidth: smallScreenHeightLimit,
  orientation: Orientation.landscape,
);

/// Landscape screens at least [smallScreenHeightLimit] (1000) logical pixels
/// wide.
const bigLandscapeScreenScope = ScreenScope(
  minWidth: smallScreenHeightLimit,
  orientation: Orientation.landscape,
);
