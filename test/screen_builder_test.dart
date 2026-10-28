import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:responsive_property/responsive_property.dart';

import 'test_utils.dart';

void main() {
  const mobile = Text('mobile');
  const tablet = Text('tablet');
  const desktop = Text('desktop');

  /// The text of the single [Text] that is shown.
  String shown(WidgetTester tester) =>
      tester.widget<Text>(find.byType(Text)).data!;

  final expected = <double, String>{
    0: 'mobile',
    360: 'mobile',
    480: 'tablet',
    600: 'tablet',
    839.5: 'tablet',
    840: 'desktop',
    1920: 'desktop',
    // No predefined scope contains this width, ScreenBuilder falls back to
    // the desktop widget.
    screenMaxDimension + 1: 'desktop',
  };

  testWidgets('ScreenBuilder shows the widget for the screen width', (
    tester,
  ) async {
    for (final MapEntry(key: width, value: text) in expected.entries) {
      await pumpWithSize(
        tester,
        Size(width, 700),
        ScreenBuilder(mobile: mobile, tablet: tablet, desktop: desktop),
      );
      expect(shown(tester), text, reason: 'width $width');
      expect(find.byType(Text), findsOneWidget);
    }
  });

  testWidgets('ScreenBuilder.builder calls the builder for the screen width', (
    tester,
  ) async {
    for (final MapEntry(key: width, value: text) in expected.entries) {
      final contexts = <String, BuildContext>{};
      WidgetBuilder builder(String name) => (context) {
            contexts[name] = context;
            return Text(name);
          };

      await pumpWithSize(
        tester,
        Size(width, 700),
        ScreenBuilder.builder(
          mobileBuilder: builder('mobile'),
          tabletBuilder: builder('tablet'),
          desktopBuilder: builder('desktop'),
        ),
      );
      expect(shown(tester), text, reason: 'width $width');
      expect(contexts.keys, [text], reason: 'width $width');
      // The builder is called with the context of the ScreenBuilder.
      expect(contexts[text]!.widget, isA<ScreenBuilder>());
    }
  });

  testWidgets('ScreenBuilder.builder can be const and takes a key', (
    tester,
  ) async {
    const key = ValueKey('screen builder');
    await pumpWithSize(
      tester,
      const Size(700, 700),
      const ScreenBuilder.builder(
        key: key,
        mobileBuilder: _mobileBuilder,
        tabletBuilder: _tabletBuilder,
        desktopBuilder: _desktopBuilder,
      ),
    );
    expect(shown(tester), 'tablet');
    expect(find.byKey(key), findsOneWidget);
  });

  testWidgets('ScreenBuilder takes a key', (tester) async {
    const key = ValueKey('screen builder');
    await pumpWithSize(
      tester,
      const Size(300, 700),
      ScreenBuilder(key: key, mobile: mobile, tablet: tablet, desktop: desktop),
    );
    expect(shown(tester), 'mobile');
    expect(tester.widget(find.byKey(key)), isA<ScreenBuilder>());
  });

  testWidgets('ScreenBuilder ignores the orientation', (tester) async {
    await pumpWithSize(
      tester,
      const Size(400, 300),
      ScreenBuilder(mobile: mobile, tablet: tablet, desktop: desktop),
    );
    expect(shown(tester), 'mobile');

    await pumpWithSize(
      tester,
      const Size(1000, 2000),
      ScreenBuilder(mobile: mobile, tablet: tablet, desktop: desktop),
    );
    expect(shown(tester), 'desktop');
  });

  testWidgets('ScreenBuilder updates when the screen size changes', (
    tester,
  ) async {
    final screenBuilder = ScreenBuilder(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
    await pumpWithSize(tester, const Size(300, 700), screenBuilder);
    expect(shown(tester), 'mobile');
    await pumpWithSize(tester, const Size(700, 700), screenBuilder);
    expect(shown(tester), 'tablet');
    await pumpWithSize(tester, const Size(1300, 700), screenBuilder);
    expect(shown(tester), 'desktop');
    await pumpWithSize(tester, const Size(300, 700), screenBuilder);
    expect(shown(tester), 'mobile');
  });

  testWidgets('ScreenBuilder keeps the state of an unchanged child', (
    tester,
  ) async {
    final key = GlobalKey<_CounterState>();
    final counter = _Counter(key: key);
    final screenBuilder = ScreenBuilder(
      mobile: counter,
      tablet: counter,
      desktop: const Text('desktop'),
    );
    await pumpWithSize(tester, const Size(300, 700), screenBuilder);
    key.currentState!.increment();
    await tester.pump();
    expect(find.text('1'), findsOneWidget);

    await pumpWithSize(tester, const Size(700, 700), screenBuilder);
    expect(find.text('1'), findsOneWidget);
  });
}

Widget _mobileBuilder(BuildContext context) => const Text('mobile');
Widget _tabletBuilder(BuildContext context) => const Text('tablet');
Widget _desktopBuilder(BuildContext context) => const Text('desktop');

class _Counter extends StatefulWidget {
  const _Counter({super.key});

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int _count = 0;

  void increment() => setState(() => _count++);

  @override
  Widget build(BuildContext context) => Text('$_count');
}
