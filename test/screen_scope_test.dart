import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

import 'json_fixtures.dart';

MediaQueryData _data(double width, double height) =>
    MediaQueryData(size: Size(width, height));

void main() {
  group('ScreenScope defaults', () {
    test('cover every size and orientation', () {
      const scope = ScreenScope();
      expect(scope.minWidth, 0.0);
      expect(scope.maxWidth, screenMaxDimension);
      expect(scope.minHeight, 0.0);
      expect(scope.maxHeight, screenMaxDimension);
      expect(scope.orientation, isNull);
      expect(screenMaxDimension, 999999.0);

      expect(scope.isOfScreenScope(_data(0, 0)), isTrue);
      expect(scope.isOfScreenScope(_data(320, 640)), isTrue);
      expect(scope.isOfScreenScope(_data(1920, 1080)), isTrue);
      expect(
        scope.isOfScreenScope(_data(screenMaxDimension, screenMaxDimension)),
        isTrue,
      );
    });

    test('do not cover sizes above screenMaxDimension', () {
      const scope = ScreenScope();
      expect(scope.isOfScreenScope(_data(screenMaxDimension + 1, 10)), isFalse);
      expect(scope.isOfScreenScope(_data(10, screenMaxDimension + 1)), isFalse);
    });
  });

  group('ScreenScope.isOfScreenScope width', () {
    const scope = ScreenScope(minWidth: 100, maxWidth: 200);

    test('matches widths inside the range', () {
      expect(scope.isOfScreenScope(_data(150, 500)), isTrue);
    });

    test('is inclusive on both ends', () {
      expect(scope.isOfScreenScope(_data(100, 500)), isTrue);
      expect(scope.isOfScreenScope(_data(200, 500)), isTrue);
    });

    test('rejects widths outside the range', () {
      expect(scope.isOfScreenScope(_data(99.999, 500)), isFalse);
      expect(scope.isOfScreenScope(_data(200.001, 500)), isFalse);
      expect(scope.isOfScreenScope(_data(0, 500)), isFalse);
      expect(scope.isOfScreenScope(_data(5000, 500)), isFalse);
    });

    test('a zero-width range matches exactly one width', () {
      const point = ScreenScope(minWidth: 300, maxWidth: 300);
      expect(point.isOfScreenScope(_data(300, 10)), isTrue);
      expect(point.isOfScreenScope(_data(299.9, 10)), isFalse);
      expect(point.isOfScreenScope(_data(300.1, 10)), isFalse);
    });
  });

  group('ScreenScope.isOfScreenScope height', () {
    const scope = ScreenScope(minHeight: 400, maxHeight: 800);

    test('matches heights inside the range, inclusive', () {
      expect(scope.isOfScreenScope(_data(10, 400)), isTrue);
      expect(scope.isOfScreenScope(_data(10, 600)), isTrue);
      expect(scope.isOfScreenScope(_data(10, 800)), isTrue);
    });

    test('rejects heights outside the range', () {
      expect(scope.isOfScreenScope(_data(10, 399.9)), isFalse);
      expect(scope.isOfScreenScope(_data(10, 800.1)), isFalse);
    });

    test('width and height must both match', () {
      const both = ScreenScope(
        minWidth: 100,
        maxWidth: 200,
        minHeight: 400,
        maxHeight: 800,
      );
      expect(both.isOfScreenScope(_data(150, 600)), isTrue);
      expect(both.isOfScreenScope(_data(250, 600)), isFalse);
      expect(both.isOfScreenScope(_data(150, 900)), isFalse);
      expect(both.isOfScreenScope(_data(250, 900)), isFalse);
    });
  });

  group('ScreenScope.isOfScreenScope orientation', () {
    const portrait = ScreenScope(orientation: Orientation.portrait);
    const landscape = ScreenScope(orientation: Orientation.landscape);
    const any = ScreenScope();

    test('portrait screens (height > width)', () {
      expect(portrait.isOfScreenScope(_data(400, 800)), isTrue);
      expect(landscape.isOfScreenScope(_data(400, 800)), isFalse);
      expect(any.isOfScreenScope(_data(400, 800)), isTrue);
    });

    test('landscape screens (width > height)', () {
      expect(portrait.isOfScreenScope(_data(800, 400)), isFalse);
      expect(landscape.isOfScreenScope(_data(800, 400)), isTrue);
      expect(any.isOfScreenScope(_data(800, 400)), isTrue);
    });

    test('square screens count as portrait', () {
      expect(portrait.isOfScreenScope(_data(500, 500)), isTrue);
      expect(landscape.isOfScreenScope(_data(500, 500)), isFalse);
    });

    test('orientation and size must both match', () {
      const scope = ScreenScope(
        maxWidth: 480,
        orientation: Orientation.portrait,
      );
      expect(scope.isOfScreenScope(_data(400, 800)), isTrue);
      expect(scope.isOfScreenScope(_data(470, 400)), isFalse);
      expect(scope.isOfScreenScope(_data(600, 800)), isFalse);
    });
  });

  test('only the size of the MediaQueryData is taken into account', () {
    const scope = ScreenScope(maxWidth: 480);
    const data = MediaQueryData(
      size: Size(400, 800),
      devicePixelRatio: 3,
      textScaler: TextScaler.linear(2),
      padding: EdgeInsets.all(50),
      viewInsets: EdgeInsets.only(bottom: 300),
      platformBrightness: Brightness.dark,
    );
    expect(scope.isOfScreenScope(data), isTrue);
    expect(
      scope.isOfScreenScope(data.copyWith(size: const Size(500, 800))),
      isFalse,
    );
  });

  group('ScreenScope assertions', () {
    // Non-constant values, so that the assertions run at runtime.
    double value(double v) => v;

    test('reject inverted or out of range bounds', () {
      expect(
        () => ScreenScope(minWidth: value(10), maxWidth: value(5)),
        throwsAssertionError,
      );
      expect(
        () => ScreenScope(minHeight: value(10), maxHeight: value(5)),
        throwsAssertionError,
      );
      expect(() => ScreenScope(minWidth: value(-1)), throwsAssertionError);
      expect(() => ScreenScope(minHeight: value(-1)), throwsAssertionError);
      expect(
        () => ScreenScope(maxWidth: value(screenMaxDimension + 1)),
        throwsAssertionError,
      );
      expect(
        () => ScreenScope(maxHeight: value(screenMaxDimension + 1)),
        throwsAssertionError,
      );
    });

    test('accept valid bounds', () {
      expect(
        ScreenScope(minWidth: value(5), maxWidth: value(5)).maxWidth,
        5.0,
      );
    });
  });

  group('ScreenScope equality', () {
    const a = ScreenScope(
      minWidth: 1,
      maxWidth: 2,
      minHeight: 3,
      maxHeight: 4,
      orientation: Orientation.portrait,
    );

    test('scopes with the same values are equal', () {
      // Built at runtime, so that it is not the same constant instance.
      final b = ScreenScope(
        minWidth: double.parse('1'),
        maxWidth: 2,
        minHeight: 3,
        maxHeight: 4,
        orientation: Orientation.portrait,
      );
      expect(identical(a, b), isFalse);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('int and double literals give equal scopes', () {
      expect(
        const ScreenScope(minWidth: 480),
        const ScreenScope(minWidth: 480.0),
      );
    });

    test('scopes differing in any value are not equal', () {
      const others = [
        ScreenScope(
          minWidth: 0,
          maxWidth: 2,
          minHeight: 3,
          maxHeight: 4,
          orientation: Orientation.portrait,
        ),
        ScreenScope(
          minWidth: 1,
          maxWidth: 3,
          minHeight: 3,
          maxHeight: 4,
          orientation: Orientation.portrait,
        ),
        ScreenScope(
          minWidth: 1,
          maxWidth: 2,
          minHeight: 2,
          maxHeight: 4,
          orientation: Orientation.portrait,
        ),
        ScreenScope(
          minWidth: 1,
          maxWidth: 2,
          minHeight: 3,
          maxHeight: 5,
          orientation: Orientation.portrait,
        ),
        ScreenScope(
          minWidth: 1,
          maxWidth: 2,
          minHeight: 3,
          maxHeight: 4,
          orientation: Orientation.landscape,
        ),
        ScreenScope(minWidth: 1, maxWidth: 2, minHeight: 3, maxHeight: 4),
      ];
      for (final other in others) {
        expect(a == other, isFalse, reason: '$other');
        expect(other == a, isFalse, reason: '$other');
      }
    });

    test('is not equal to other types', () {
      expect(const ScreenScope() == Object(), isFalse);
    });

    test('works as a map key and in sets', () {
      final map = {mobileScreenScope: 'mobile', desktopScreenScope: 'desktop'};
      expect(map[const ScreenScope(maxWidth: 480)], 'mobile');
      expect(map[const ScreenScope(minWidth: 840)], 'desktop');
      expect(map[const ScreenScope(minWidth: 840, maxWidth: 841)], isNull);

      final scopes = [
        mobileScreenScope,
        const ScreenScope(maxWidth: mobileScreenWidthLimit),
        const ScreenScope(minWidth: 0, maxWidth: 480),
      ];
      expect(scopes.toSet(), hasLength(1));
    });

    test('negative zero equals zero, with the same hash code', () {
      final negativeZero = ScreenScope(minWidth: -0.0, minHeight: -0.0);
      expect(negativeZero, const ScreenScope());
      expect(negativeZero.hashCode, const ScreenScope().hashCode);
    });
  });

  group('ScreenScope JSON', () {
    test('toJson matches the established format', () {
      expect(json.encode(const ScreenScope().toJson()), scopeDefaultJson);
      expect(
        json.encode(
          const ScreenScope(
            minWidth: 100,
            maxWidth: 200.5,
            minHeight: 300,
            maxHeight: 400,
            orientation: Orientation.landscape,
          ).toJson(),
        ),
        scopeFullJson,
      );
    });

    test('toJson omits a null orientation', () {
      expect(const ScreenScope().toJson().containsKey('orientation'), isFalse);
      expect(
        const ScreenScope(orientation: Orientation.portrait).toJson(),
        containsPair('orientation', 'portrait'),
      );
    });

    test('parseScreenScope reads the established format', () {
      expect(
          parseScreenScope(json.decode(scopeDefaultJson)), const ScreenScope());
      expect(
        parseScreenScope(json.decode(scopeFullJson)),
        const ScreenScope(
          minWidth: 100,
          maxWidth: 200.5,
          minHeight: 300,
          maxHeight: 400,
          orientation: Orientation.landscape,
        ),
      );
    });

    test('toJson and parseScreenScope round trip', () {
      const scopes = [
        ScreenScope(),
        mobileScreenScope,
        tabletScreenScope,
        desktopScreenScope,
        smallScreenScope,
        bigScreenScope,
        mobilePortraitScreenScope,
        tabletPortraitScreenScope,
        desktopPortraitScreenScope,
        smallPortraitScreenScope,
        bigPortraitScreenScope,
        mobileLandscapeScreenScope,
        tabletLandscapeScreenScope,
        desktopLandscapeScreenScope,
        smallLandscapeScreenScope,
        bigLandscapeScreenScope,
        ScreenScope(minWidth: 0.5, maxWidth: 1.25, minHeight: 7, maxHeight: 9),
      ];
      for (final scope in scopes) {
        final decoded = parseScreenScope(
          json.decode(json.encode(scope.toJson())),
        );
        expect(decoded, scope);
        expect(decoded.hashCode, scope.hashCode);
      }
    });

    test('parseScreenScope accepts int values', () {
      expect(
        parseScreenScope({
          'minWidth': 480,
          'maxWidth': 840,
          'minHeight': 0,
          'maxHeight': 999999,
        }),
        tabletScreenScope,
      );
    });

    test('parseScreenScope falls back to the defaults for missing keys', () {
      expect(parseScreenScope({}), const ScreenScope());
      expect(
        parseScreenScope({'maxWidth': 480}),
        const ScreenScope(maxWidth: 480),
      );
      expect(
        parseScreenScope({'minWidth': 840.0, 'orientation': 'portrait'}),
        desktopPortraitScreenScope,
      );
      expect(
        parseScreenScope({'minHeight': 10, 'maxHeight': 20}),
        const ScreenScope(minHeight: 10, maxHeight: 20),
      );
    });

    test('parseScreenScope treats null values as missing', () {
      expect(
        parseScreenScope({
          'minWidth': null,
          'maxWidth': null,
          'minHeight': null,
          'maxHeight': null,
          'orientation': null,
        }),
        const ScreenScope(),
      );
    });

    test('parseScreenScope ignores unknown orientations', () {
      expect(
        parseScreenScope({'orientation': 'diagonal'}).orientation,
        isNull,
      );
    });
  });
}
