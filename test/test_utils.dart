import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a widget below a [MediaQuery] that reports [size], calls [compute]
/// with its [BuildContext] during the build and returns the result.
Future<R> computeWithSize<R>(
  WidgetTester tester,
  Size size,
  R Function(BuildContext context) compute,
) async {
  late R result;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: Builder(
        builder: (context) {
          result = compute(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return result;
}

/// Pumps [child] below a [MediaQuery] that reports [size].
Future<void> pumpWithSize(WidgetTester tester, Size size, Widget child) {
  return tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: size),
      child: Directionality(textDirection: TextDirection.ltr, child: child),
    ),
  );
}
