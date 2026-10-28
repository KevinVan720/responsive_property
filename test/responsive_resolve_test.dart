import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

import 'test_utils.dart';

final Responsive<int> _mobileTabletDesktop = Responsive({
  mobileScreenScope: 2,
  tabletScreenScope: 4,
  desktopScreenScope: 6,
});

/// Records every value it resolves from [_mobileTabletDesktop].
class _Probe extends StatelessWidget {
  const _Probe(this.log);

  final List<int?> log;

  @override
  Widget build(BuildContext context) {
    log.add(_mobileTabletDesktop.resolve(context));
    return const SizedBox.shrink();
  }
}

void main() {
  Future<T?> resolveAt<T>(
    WidgetTester tester,
    Size size,
    Responsive<T> responsive, [
    T? Function(T? previousValue, T? element)? combine,
  ]) {
    return computeWithSize(
      tester,
      size,
      (context) => responsive.resolve(context, combine),
    );
  }

  test('values holds the given map', () {
    final values = {mobileScreenScope: 1, desktopScreenScope: 2};
    final responsive = Responsive(values);
    expect(responsive.values, same(values));

    responsive.values = {tabletScreenScope: 3};
    expect(responsive.values, {tabletScreenScope: 3});
  });

  group('resolve', () {
    testWidgets('picks the value of the matching scope', (tester) async {
      final expected = <double, int>{
        0: 2,
        320: 2,
        479.9: 2,
        480.1: 4,
        600: 4,
        839.9: 4,
        840.1: 6,
        1920: 6,
        screenMaxDimension: 6,
      };
      for (final MapEntry(key: width, value: value) in expected.entries) {
        expect(
          await resolveAt(tester, Size(width, 800), _mobileTabletDesktop),
          value,
          reason: 'width $width',
        );
      }
    });

    testWidgets('when several scopes match, the last one in the map wins', (
      tester,
    ) async {
      // On a breakpoint both neighbouring scopes match.
      expect(
        await resolveAt(tester, const Size(480, 800), _mobileTabletDesktop),
        4,
      );
      expect(
        await resolveAt(tester, const Size(840, 800), _mobileTabletDesktop),
        6,
      );

      final reversed = Responsive({
        desktopScreenScope: 6,
        tabletScreenScope: 4,
        mobileScreenScope: 2,
      });
      expect(await resolveAt(tester, const Size(480, 800), reversed), 2);
      expect(await resolveAt(tester, const Size(840, 800), reversed), 4);
      expect(await resolveAt(tester, const Size(300, 800), reversed), 2);
      expect(await resolveAt(tester, const Size(1000, 800), reversed), 6);

      final overlapping = Responsive({
        const ScreenScope(): 'any',
        smallScreenScope: 'small',
        mobileScreenScope: 'mobile',
      });
      expect(
          await resolveAt(tester, const Size(300, 800), overlapping), 'mobile');
      expect(
          await resolveAt(tester, const Size(500, 800), overlapping), 'small');
      expect(await resolveAt(tester, const Size(900, 800), overlapping), 'any');
    });

    testWidgets('returns null when no scope matches', (tester) async {
      final mobileOnly = Responsive({mobileScreenScope: 1});
      expect(await resolveAt(tester, const Size(300, 800), mobileOnly), 1);
      expect(
          await resolveAt(tester, const Size(1000, 800), mobileOnly), isNull);

      final empty = Responsive<int>({});
      expect(await resolveAt(tester, const Size(300, 800), empty), isNull);

      // Sizes above screenMaxDimension are not covered by any scope.
      expect(
        await resolveAt(
          tester,
          const Size(screenMaxDimension + 1, 800),
          _mobileTabletDesktop,
        ),
        isNull,
      );
    });

    testWidgets('a matching null value overrides earlier values', (
      tester,
    ) async {
      final responsive = Responsive<int?>({
        const ScreenScope(): 1,
        mobileScreenScope: null,
      });
      expect(await resolveAt(tester, const Size(300, 800), responsive), isNull);
      expect(await resolveAt(tester, const Size(600, 800), responsive), 1);
    });

    testWidgets('uses the orientation of the screen', (tester) async {
      final responsive = Responsive({
        mobilePortraitScreenScope: 'mobile portrait',
        tabletPortraitScreenScope: 'tablet portrait',
        desktopPortraitScreenScope: 'desktop portrait',
        mobileLandscapeScreenScope: 'mobile landscape',
        tabletLandscapeScreenScope: 'tablet landscape',
        desktopLandscapeScreenScope: 'desktop landscape',
      });
      final expected = <Size, String>{
        const Size(360, 780): 'mobile portrait',
        const Size(780, 360): 'mobile landscape',
        const Size(600, 1000): 'tablet portrait',
        const Size(1000, 600): 'tablet landscape',
        const Size(1000, 1400): 'desktop portrait',
        const Size(1400, 1000): 'desktop landscape',
        const Size(700, 700): 'tablet portrait',
      };
      for (final MapEntry(key: size, value: value) in expected.entries) {
        expect(
          await resolveAt(tester, size, responsive),
          value,
          reason: '$size',
        );
      }
    });

    testWidgets('uses the height of the screen', (tester) async {
      final responsive = Responsive({
        const ScreenScope(maxHeight: 500): 'short',
        const ScreenScope(minHeight: 500.001): 'tall',
      });
      expect(
          await resolveAt(tester, const Size(400, 300), responsive), 'short');
      expect(
          await resolveAt(tester, const Size(400, 500), responsive), 'short');
      expect(await resolveAt(tester, const Size(400, 900), responsive), 'tall');
    });

    testWidgets('uses the closest MediaQuery', (tester) async {
      int? result;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(size: Size(1920, 1080)),
          child: MediaQuery(
            data: const MediaQueryData(size: Size(300, 600)),
            child: Builder(
              builder: (context) {
                result = _mobileTabletDesktop.resolve(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, 2);
    });

    testWidgets('rebuilds the caller when the screen size changes', (
      tester,
    ) async {
      final log = <int?>[];
      // The same widget instance, so it only rebuilds because it depends on
      // the MediaQuery.
      final probe = _Probe(log);
      await pumpWithSize(tester, const Size(300, 800), probe);
      await pumpWithSize(tester, const Size(700, 800), probe);
      await pumpWithSize(tester, const Size(1200, 800), probe);
      expect(log, [2, 4, 6]);
    });
  });

  group('resolve with combine', () {
    final responsive = Responsive({
      const ScreenScope(): 1,
      smallScreenScope: 10,
      mobileScreenScope: 100,
    });

    int? sum(int? previousValue, int? element) =>
        (previousValue ?? 0) + (element ?? 0);

    testWidgets('combines all matching values in map order', (tester) async {
      expect(
          await resolveAt(tester, const Size(300, 800), responsive, sum), 111);
      expect(
          await resolveAt(tester, const Size(500, 800), responsive, sum), 11);
      expect(await resolveAt(tester, const Size(900, 800), responsive, sum), 1);
    });

    testWidgets('starts with null and passes the values in order', (
      tester,
    ) async {
      final calls = <(int?, int?)>[];
      final result = await resolveAt(tester, const Size(300, 800), responsive, (
        previousValue,
        element,
      ) {
        calls.add((previousValue, element));
        return element! * 2;
      });
      expect(calls, [(null, 1), (2, 10), (20, 100)]);
      expect(result, 200);
    });

    testWidgets('is not called when nothing matches', (tester) async {
      var called = false;
      final result = await resolveAt(
        tester,
        const Size(300, 800),
        Responsive({desktopScreenScope: 1}),
        (previousValue, element) {
          called = true;
          return element;
        },
      );
      expect(result, isNull);
      expect(called, isFalse);
    });

    testWidgets('can merge objects like CSS styles', (tester) async {
      final style = Responsive({
        const ScreenScope():
            const TextStyle(fontSize: 12, color: Color(0xFF000000)),
        bigScreenScope: const TextStyle(fontSize: 20),
      });
      TextStyle? merge(TextStyle? previousValue, TextStyle? element) =>
          previousValue?.merge(element) ?? element;

      final small = await resolveAt(tester, const Size(300, 800), style, merge);
      expect(small?.fontSize, 12);
      expect(small?.color, const Color(0xFF000000));

      final big = await resolveAt(tester, const Size(900, 800), style, merge);
      expect(big?.fontSize, 20);
      expect(big?.color, const Color(0xFF000000));
    });
  });

  testWidgets('works with widgets and builders as values', (tester) async {
    const mobile = Text('mobile', textDirection: TextDirection.ltr);
    const desktop = Text('desktop', textDirection: TextDirection.ltr);
    await pumpWithSize(
      tester,
      const Size(300, 800),
      Builder(
        builder: (context) =>
            Responsive<Widget>({
              mobileScreenScope: mobile,
              desktopScreenScope: desktop,
            }).resolve(context) ??
            const SizedBox.shrink(),
      ),
    );
    expect(find.text('mobile'), findsOneWidget);
    expect(find.text('desktop'), findsNothing);
  });
}
