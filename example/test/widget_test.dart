import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Makes the test screen [size] logical pixels large.
  void setScreenSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  Future<void> openExample(WidgetTester tester, String name) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text(name));
    await tester.pumpAndSettle();
  }

  Future<void> goBack(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(find.text('Responsive Examples'), findsOneWidget);
  }

  testWidgets('the home page lists the examples', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Responsive Examples'), findsOneWidget);
    expect(find.text('Responsive Int'), findsOneWidget);
    expect(find.text('Responsive Flex'), findsOneWidget);
    expect(find.text('Responsive Builder'), findsOneWidget);
  });

  group('Responsive Int', () {
    int crossAxisCount(WidgetTester tester) {
      final grid = tester.widget<GridView>(find.byType(GridView));
      final delegate =
          grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      return delegate.crossAxisCount;
    }

    const expected = [(400.0, 2), (700.0, 4), (1200.0, 6)];
    for (final (width, count) in expected) {
      testWidgets('shows $count columns on a $width pixels wide screen', (
        tester,
      ) async {
        setScreenSize(tester, Size(width, 900));
        await openExample(tester, 'Responsive Int');

        expect(crossAxisCount(tester), count);
        await goBack(tester);
      });
    }
  });

  group('Responsive Flex', () {
    Flex flex(WidgetTester tester) => tester.widget<Flex>(find.byType(Flex));

    testWidgets('is vertical on mobile screens', (tester) async {
      setScreenSize(tester, const Size(400, 900));
      await openExample(tester, 'Responsive Flex');

      expect(flex(tester).direction, Axis.vertical);
      expect(flex(tester).mainAxisAlignment, MainAxisAlignment.start);
      await goBack(tester);
    });

    testWidgets('is vertical on tablet screens', (tester) async {
      setScreenSize(tester, const Size(700, 900));
      await openExample(tester, 'Responsive Flex');

      expect(flex(tester).direction, Axis.vertical);
      expect(flex(tester).mainAxisAlignment, MainAxisAlignment.spaceAround);
    });

    testWidgets('is horizontal on desktop screens', (tester) async {
      setScreenSize(tester, const Size(1400, 900));
      await openExample(tester, 'Responsive Flex');

      expect(flex(tester).direction, Axis.horizontal);
      expect(flex(tester).mainAxisAlignment, MainAxisAlignment.spaceAround);
    });
  });

  group('Responsive Builder', () {
    testWidgets('uses a bottom navigation bar on mobile screens', (
      tester,
    ) async {
      setScreenSize(tester, const Size(400, 900));
      await openExample(tester, 'Responsive Builder');

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Index 0: Home'), findsOneWidget);
      expect(find.text('Index 1: Business'), findsNothing);

      await tester.tap(find.text('Business'));
      await tester.pumpAndSettle();
      expect(find.text('Index 0: Home'), findsNothing);
      expect(find.text('Index 1: Business'), findsOneWidget);
      await goBack(tester);
    });

    testWidgets('uses a list on tablet screens', (tester) async {
      setScreenSize(tester, const Size(700, 900));
      await openExample(tester, 'Responsive Builder');

      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(
        find.descendant(
          of: find.byType(ListView),
          matching: find.text('Index 0: Home'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows everything in a row on desktop screens', (
      tester,
    ) async {
      setScreenSize(tester, const Size(1600, 900));
      await openExample(tester, 'Responsive Builder');

      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(find.byType(ListView), findsNothing);
      expect(find.text('Index 0: Home'), findsOneWidget);
      expect(find.text('Index 1: Business'), findsOneWidget);
      expect(find.text('Index 2: School'), findsOneWidget);
    });
  });
}
