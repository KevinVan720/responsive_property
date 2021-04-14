import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

class ResponsiveIntPage extends StatefulWidget {
  ResponsiveIntPage({this.title = "Responsive Int"});

  final String title;

  @override
  _ResponsiveIntPageState createState() => _ResponsiveIntPageState();
}

class _ResponsiveIntPageState extends State<ResponsiveIntPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
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
          desktopScreenScope: 6
        }).resolve(context)!,
        children: List.generate(
            30,
            (index) =>
                Container(color: Colors.green, child: Text("SOME TEXT"))),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
