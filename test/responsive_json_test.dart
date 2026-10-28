import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

import 'json_fixtures.dart';

/// Encodes [responsive] like an app would store it.
String _encode<T>(Responsive<T> responsive, [dynamic Function(T?)? encoder]) =>
    json.encode(responsive.toJson(encoder: encoder));

Map<String, dynamic> _decode(String source) =>
    json.decode(source) as Map<String, dynamic>;

/// The JSON key of a single [scope].
String _key(ScreenScope scope) => json.encode(scope.toJson());

final Map<ScreenScope, int> _intValues = {
  mobileScreenScope: 2,
  tabletScreenScope: 4,
  desktopScreenScope: 6,
};

final Map<ScreenScope, double> _doubleValues = {
  smallScreenScope: 1.5,
  bigScreenScope: 3.0,
};

final Map<ScreenScope, String> _stringValues = {
  mobilePortraitScreenScope: 'mp',
  tabletPortraitScreenScope: 'tp',
  desktopPortraitScreenScope: 'dp',
  mobileLandscapeScreenScope: 'ml',
  tabletLandscapeScreenScope: 'tl',
  desktopLandscapeScreenScope: 'dl',
};

final Map<ScreenScope, bool> _boolValues = {
  const ScreenScope(maxHeight: 500): true,
  const ScreenScope(minHeight: 500, orientation: Orientation.portrait): false,
};

final Map<ScreenScope, dynamic> _dynamicValues = {
  smallPortraitScreenScope: [1, 2.5, 'a'],
  bigPortraitScreenScope: {'k': null, 'n': 1},
};

final Map<ScreenScope, Color> _colorValues = {
  smallLandscapeScreenScope: const Color(0xFF2196F3),
  bigLandscapeScreenScope: const Color(0x80FF0000),
};

final Map<ScreenScope, Axis> _axisValues = {
  mobileScreenScope: Axis.vertical,
  desktopScreenScope: Axis.horizontal,
};

final Map<ScreenScope, EdgeInsets> _edgeInsetsValues = {
  mobileScreenScope: const EdgeInsets.all(8),
  desktopScreenScope: const EdgeInsets.fromLTRB(1, 2, 3, 4),
};

void main() {
  group('toJson matches the established format', () {
    test('JSON values', () {
      expect(_encode(Responsive(_intValues)), intMobileTabletDesktopJson);
      expect(_encode(Responsive(_doubleValues)), doubleSmallBigJson);
      expect(_encode(Responsive(_stringValues)), stringOrientationJson);
      expect(_encode(Responsive(_boolValues)), boolHeightJson);
      expect(_encode(Responsive(_dynamicValues)), listMapJson);
    });

    test('values converted by an encoder', () {
      expect(
        _encode(Responsive(_colorValues), (color) => color?.toJson()),
        colorEncodedJson,
      );
      expect(
        _encode(Responsive(_axisValues), (axis) => axis?.toJson()),
        axisEncodedJson,
      );
      expect(
        _encode(Responsive(_edgeInsetsValues), (insets) => insets?.toJson()),
        edgeInsetsEncodedJson,
      );
    });

    test('keys are the JSON encoded scopes, in map order', () {
      final encoded = Responsive(_intValues).toJson() as Map;
      expect(encoded.keys, [
        _key(mobileScreenScope),
        _key(tabletScreenScope),
        _key(desktopScreenScope),
      ]);
      expect(encoded.values, [2, 4, 6]);
    });

    test('the encoder is called with every value', () {
      final seen = <int?>[];
      final encoded = Responsive(_intValues).toJson(
        encoder: (value) {
          seen.add(value);
          return '#$value';
        },
      );
      expect(seen, [2, 4, 6]);
      expect((encoded as Map).values, ['#2', '#4', '#6']);
    });

    test('an empty Responsive encodes to an empty object', () {
      expect(_encode(Responsive<int>({})), '{}');
    });
  });

  group('fromJson reads the established format', () {
    test('JSON values', () {
      expect(
        Responsive<int>.fromJson(_decode(intMobileTabletDesktopJson)).values,
        _intValues,
      );
      expect(
        Responsive<double>.fromJson(_decode(doubleSmallBigJson)).values,
        _doubleValues,
      );
      expect(
        Responsive<String>.fromJson(_decode(stringOrientationJson)).values,
        _stringValues,
      );
      expect(
        Responsive<bool>.fromJson(_decode(boolHeightJson)).values,
        _boolValues,
      );
      expect(
        Responsive<dynamic>.fromJson(_decode(listMapJson)).values,
        _dynamicValues,
      );
    });

    test('values converted by a decoder', () {
      expect(
        Responsive<Color>.fromJson(
          _decode(colorEncodedJson),
          decoder: (value) => parseColor(value)!,
        ).values,
        _colorValues,
      );
      expect(
        Responsive<Axis>.fromJson(
          _decode(axisEncodedJson),
          decoder: (value) => parseAxis(value)!,
        ).values,
        _axisValues,
      );
      expect(
        Responsive<EdgeInsets>.fromJson(
          _decode(edgeInsetsEncodedJson),
          decoder: (value) => parseEdgeInsets(value)!,
        ).values,
        _edgeInsetsValues,
      );
    });

    test('keeps the order of the keys', () {
      final responsive = Responsive<int>.fromJson(
        _decode(intMobileTabletDesktopJson),
      );
      expect(responsive.values.keys, [
        mobileScreenScope,
        tabletScreenScope,
        desktopScreenScope,
      ]);
    });

    test('the decoder is called with the raw JSON values', () {
      final seen = <dynamic>[];
      final responsive = Responsive<String>.fromJson(
        _decode(intMobileTabletDesktopJson),
        decoder: (value) {
          seen.add(value);
          return 'v$value';
        },
      );
      expect(seen, [2, 4, 6]);
      expect(responsive.values.values, ['v2', 'v4', 'v6']);
    });

    test('an empty object decodes to an empty Responsive', () {
      expect(Responsive<int>.fromJson({}).values, isEmpty);
    });
  });

  group('round trips', () {
    void expectRoundTrip<T>(
      Map<ScreenScope, T> values, {
      dynamic Function(T? element)? encoder,
      T Function(dynamic element)? decoder,
    }) {
      final decoded = Responsive<T>.fromJson(
        _decode(_encode(Responsive(values), encoder)),
        decoder: decoder,
      );
      expect(decoded.values, values);
      expect(decoded.values.keys, values.keys);
    }

    test('JSON values', () {
      expectRoundTrip(_intValues);
      expectRoundTrip(_doubleValues);
      expectRoundTrip(_stringValues);
      expectRoundTrip(_boolValues);
      expectRoundTrip(_dynamicValues);
      expectRoundTrip(<ScreenScope, int?>{
        mobileScreenScope: null,
        desktopScreenScope: 1,
      });
      expectRoundTrip(<ScreenScope, num>{
        mobileScreenScope: 1,
        desktopScreenScope: 1.5,
      });
    });

    test('values converted by an encoder and a decoder', () {
      expectRoundTrip(
        _colorValues,
        encoder: (color) => color?.toJson(),
        decoder: (value) => parseColor(value)!,
      );
      expectRoundTrip(
        _axisValues,
        encoder: (axis) => axis?.toJson(),
        decoder: (value) => parseAxis(value)!,
      );
      expectRoundTrip(
        _edgeInsetsValues,
        encoder: (insets) => insets?.toJson(),
        decoder: (value) => parseEdgeInsets(value)!,
      );
      // parseTextStyle always sets a font style.
      expectRoundTrip(
        {
          mobileScreenScope: const TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.normal,
          ),
          desktopScreenScope: const TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Color(0xFF123456),
          ),
        },
        encoder: (style) => style?.toJson(),
        decoder: (value) => parseTextStyle(value)!,
      );
    });

    test('custom scopes', () {
      expectRoundTrip({
        const ScreenScope(
          minWidth: 0.5,
          maxWidth: 300.25,
          minHeight: 10,
          maxHeight: 20,
          orientation: Orientation.landscape,
        ): 'custom',
        const ScreenScope(): 'any',
      });
    });
  });

  group('fromJson leniency', () {
    test('accepts int JSON values for doubles', () {
      final responsive = Responsive<double>.fromJson({
        _key(smallScreenScope): 1,
        _key(bigScreenScope): 3.5,
      });
      expect(responsive.values, {smallScreenScope: 1.0, bigScreenScope: 3.5});
      expect(responsive.values[smallScreenScope], isA<double>());
    });

    test('accepts int JSON values for nullable doubles', () {
      final responsive = Responsive<double?>.fromJson({
        _key(smallScreenScope): 1,
        _key(bigScreenScope): null,
      });
      expect(responsive.values, {smallScreenScope: 1.0, bigScreenScope: null});
    });

    test('keeps ints for num and dynamic values', () {
      expect(
        Responsive<num>.fromJson({_key(smallScreenScope): 1})
            .values[smallScreenScope],
        isA<int>(),
      );
      expect(
        Responsive<dynamic>.fromJson({_key(smallScreenScope): 1})
            .values[smallScreenScope],
        isA<int>(),
      );
    });

    test('accepts scope keys with int values', () {
      final responsive = Responsive<int>.fromJson({
        '{"minWidth":480,"maxWidth":840,"minHeight":0,"maxHeight":999999}': 4,
      });
      expect(responsive.values, {tabletScreenScope: 4});
    });

    test('accepts scope keys with missing values', () {
      final responsive = Responsive<int>.fromJson({
        '{"maxWidth":480}': 2,
        '{"minWidth":480,"maxWidth":840}': 4,
        '{"minWidth":840,"orientation":"portrait"}': 6,
        '{}': 8,
      });
      expect(responsive.values, {
        mobileScreenScope: 2,
        tabletScreenScope: 4,
        desktopPortraitScreenScope: 6,
        const ScreenScope(): 8,
      });
    });

    test('rejects values of the wrong type without a decoder', () {
      expect(
        () => Responsive<int>.fromJson({_key(smallScreenScope): 'text'}),
        throwsA(isA<Error>()),
      );
      expect(
        () => Responsive<String>.fromJson({_key(smallScreenScope): 1}),
        throwsA(isA<Error>()),
      );
    });
  });
}
