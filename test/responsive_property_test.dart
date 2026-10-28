// The examples from the README.

import 'package:flutter/widgets.dart';
import 'package:flutter_class_parser/flutter_class_parser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

import 'test_utils.dart';

void main() {
  testWidgets('responsive grid', (tester) async {
    int crossAxisCount(BuildContext context) =>
        Responsive({
          mobileScreenScope: 2,
          tabletScreenScope: 4,
          desktopScreenScope: 6,
        }).resolve(context) ??
        6;

    final expected = <double, int>{
      320: 2,
      480: 4,
      600: 4,
      840: 6,
      1920: 6,
      screenMaxDimension + 1: 6,
    };
    for (final MapEntry(key: width, value: count) in expected.entries) {
      await pumpWithSize(
        tester,
        Size(width, 800),
        Builder(
          builder: (context) => GridView.count(
            crossAxisCount: crossAxisCount(context),
            children: List.generate(30, (index) => Text('$index')),
          ),
        ),
      );
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, count, reason: 'width $width');
    }
  });

  testWidgets('combined text styles', (tester) async {
    final responsive = Responsive({
      const ScreenScope(): const TextStyle(fontSize: 14),
      desktopScreenScope: const TextStyle(fontWeight: FontWeight.bold),
    });
    TextStyle? resolve(BuildContext context) => responsive.resolve(
          context,
          (previousValue, element) => previousValue?.merge(element) ?? element,
        );

    final mobile = await computeWithSize(
      tester,
      const Size(400, 800),
      resolve,
    );
    expect(mobile?.fontSize, 14);
    expect(mobile?.fontWeight, isNull);

    final desktop = await computeWithSize(
      tester,
      const Size(1200, 800),
      resolve,
    );
    expect(desktop?.fontSize, 14);
    expect(desktop?.fontWeight, FontWeight.bold);
  });

  test('JSON', () {
    final colors = {
      mobileScreenScope: const Color(0xFFF44336),
      desktopScreenScope: const Color(0xFF2196F3),
    };
    final Map<String, dynamic> map = Responsive<Color>(colors).toJson(
      encoder: (color) => color?.toJson(),
    );
    final decoded = Responsive<Color>.fromJson(
      map,
      decoder: (value) => parseColor(value)!,
    );
    expect(decoded.values, colors);

    const scope = ScreenScope(
      minWidth: 600,
      maxWidth: 1200,
      orientation: Orientation.landscape,
    );
    expect(parseScreenScope(scope.toJson()), scope);
  });
}
