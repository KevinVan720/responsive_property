import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

/// A Flex whose direction and alignment depend on the screen width.
class ResponsiveFlexPage extends StatelessWidget {
  const ResponsiveFlexPage({super.key, this.title = 'Responsive Flex'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Flex(
          direction: Responsive({
                mobileScreenScope: Axis.vertical,
                tabletScreenScope: Axis.vertical,
              }).resolve(context) ??
              Axis.horizontal,
          mainAxisAlignment: Responsive({
                mobileScreenScope: MainAxisAlignment.start,
                tabletScreenScope: MainAxisAlignment.spaceAround,
              }).resolve(context) ??
              MainAxisAlignment.spaceAround,
          children: List.generate(
            10,
            (index) =>
                Container(color: Colors.green, child: const Text('SOME TEXT')),
          ),
        ),
      ),
    );
  }
}
