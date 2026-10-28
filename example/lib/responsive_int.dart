import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

/// A grid whose number of columns depends on the screen width.
class ResponsiveIntPage extends StatelessWidget {
  const ResponsiveIntPage({super.key, this.title = 'Responsive Int'});

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
        child: GridView.count(
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: Responsive({
                mobileScreenScope: 2,
                tabletScreenScope: 4,
                desktopScreenScope: 6,
              }).resolve(context) ??
              6,
          children: List.generate(
            30,
            (index) =>
                Container(color: Colors.green, child: const Text('SOME TEXT')),
          ),
        ),
      ),
    );
  }
}
