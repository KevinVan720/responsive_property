import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

const Map<String, ScreenScope> _scopes = {
  'mobile': mobileScreenScope,
  'tablet': tabletScreenScope,
  'desktop': desktopScreenScope,
  'small': smallScreenScope,
  'big': bigScreenScope,
  'mobilePortrait': mobilePortraitScreenScope,
  'tabletPortrait': tabletPortraitScreenScope,
  'desktopPortrait': desktopPortraitScreenScope,
  'smallPortrait': smallPortraitScreenScope,
  'bigPortrait': bigPortraitScreenScope,
  'mobileLandscape': mobileLandscapeScreenScope,
  'tabletLandscape': tabletLandscapeScreenScope,
  'desktopLandscape': desktopLandscapeScreenScope,
  'smallLandscape': smallLandscapeScreenScope,
  'bigLandscape': bigLandscapeScreenScope,
};

/// The names of the predefined scopes that contain a screen of [size].
Set<String> _matching(Size size) => {
      for (final entry in _scopes.entries)
        if (entry.value.isOfScreenScope(MediaQueryData(size: size))) entry.key,
    };

void main() {
  test('breakpoint values', () {
    expect(mobileScreenWidthLimit, 480.0);
    expect(tabletScreenWidthLimit, 840.0);
    expect(desktopScreenWidthLimit, 1200.0);
    expect(smallScreenWidthLimit, 600.0);
    expect(smallScreenHeightLimit, 1000.0);
  });

  test('scope definitions', () {
    expect(mobileScreenScope, const ScreenScope(minWidth: 0, maxWidth: 480));
    expect(tabletScreenScope, const ScreenScope(minWidth: 480, maxWidth: 840));
    expect(desktopScreenScope, const ScreenScope(minWidth: 840));
    expect(smallScreenScope, const ScreenScope(maxWidth: 600));
    expect(bigScreenScope, const ScreenScope(minWidth: 600));
    expect(
      mobilePortraitScreenScope,
      const ScreenScope(maxWidth: 480, orientation: Orientation.portrait),
    );
    expect(
      tabletPortraitScreenScope,
      const ScreenScope(
        minWidth: 480,
        maxWidth: 840,
        orientation: Orientation.portrait,
      ),
    );
    expect(
      desktopPortraitScreenScope,
      const ScreenScope(minWidth: 840, orientation: Orientation.portrait),
    );
    expect(
      smallPortraitScreenScope,
      const ScreenScope(maxWidth: 600, orientation: Orientation.portrait),
    );
    expect(
      bigPortraitScreenScope,
      const ScreenScope(minWidth: 600, orientation: Orientation.portrait),
    );
    expect(
      mobileLandscapeScreenScope,
      const ScreenScope(maxWidth: 840, orientation: Orientation.landscape),
    );
    expect(
      tabletLandscapeScreenScope,
      const ScreenScope(
        minWidth: 840,
        maxWidth: 1200,
        orientation: Orientation.landscape,
      ),
    );
    expect(
      desktopLandscapeScreenScope,
      const ScreenScope(minWidth: 1200, orientation: Orientation.landscape),
    );
    expect(
      smallLandscapeScreenScope,
      const ScreenScope(maxWidth: 1000, orientation: Orientation.landscape),
    );
    expect(
      bigLandscapeScreenScope,
      const ScreenScope(minWidth: 1000, orientation: Orientation.landscape),
    );
  });

  group('portrait screens', () {
    // Height is always larger than the width.
    Size portrait(double width) => Size(width, width * 2);

    test('below the first breakpoint', () {
      expect(_matching(portrait(0)), {
        'mobile',
        'small',
        'mobilePortrait',
        'smallPortrait',
      });
      expect(_matching(portrait(360)), {
        'mobile',
        'small',
        'mobilePortrait',
        'smallPortrait',
      });
    });

    test('on the mobile/tablet breakpoint both scopes match', () {
      expect(_matching(portrait(480)), {
        'mobile',
        'tablet',
        'small',
        'mobilePortrait',
        'tabletPortrait',
        'smallPortrait',
      });
    });

    test('between the breakpoints', () {
      expect(_matching(portrait(480.5)), {
        'tablet',
        'small',
        'tabletPortrait',
        'smallPortrait',
      });
      expect(_matching(portrait(600)), {
        'tablet',
        'small',
        'big',
        'tabletPortrait',
        'smallPortrait',
        'bigPortrait',
      });
      expect(_matching(portrait(700)), {
        'tablet',
        'big',
        'tabletPortrait',
        'bigPortrait',
      });
    });

    test('on the tablet/desktop breakpoint both scopes match', () {
      expect(_matching(portrait(840)), {
        'tablet',
        'desktop',
        'big',
        'tabletPortrait',
        'desktopPortrait',
        'bigPortrait',
      });
    });

    test('above the last breakpoint', () {
      expect(_matching(portrait(1300)), {
        'desktop',
        'big',
        'desktopPortrait',
        'bigPortrait',
      });
    });
  });

  group('landscape screens', () {
    // Width is always larger than the height.
    Size landscape(double width) => Size(width, width / 2);

    test('small landscape screens', () {
      expect(_matching(landscape(400)), {
        'mobile',
        'small',
        'mobileLandscape',
        'smallLandscape',
      });
      expect(_matching(landscape(800)), {
        'tablet',
        'big',
        'mobileLandscape',
        'smallLandscape',
      });
    });

    test('on the mobile/tablet landscape breakpoint both scopes match', () {
      expect(_matching(landscape(840)), {
        'tablet',
        'desktop',
        'big',
        'mobileLandscape',
        'tabletLandscape',
        'smallLandscape',
      });
    });

    test('on the small/big landscape breakpoint both scopes match', () {
      expect(_matching(landscape(1000)), {
        'desktop',
        'big',
        'tabletLandscape',
        'smallLandscape',
        'bigLandscape',
      });
    });

    test('on the tablet/desktop landscape breakpoint both scopes match', () {
      expect(_matching(landscape(1200)), {
        'desktop',
        'big',
        'tabletLandscape',
        'desktopLandscape',
        'bigLandscape',
      });
    });

    test('large landscape screens', () {
      expect(_matching(landscape(1920)), {
        'desktop',
        'big',
        'desktopLandscape',
        'bigLandscape',
      });
    });
  });

  test('a square screen counts as portrait', () {
    expect(_matching(const Size(500, 500)), {
      'tablet',
      'small',
      'tabletPortrait',
      'smallPortrait',
    });
  });
}
