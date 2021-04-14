import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

class ResponsiveFlexPage extends StatefulWidget {
  ResponsiveFlexPage({this.title = "Responsive Flex"});

  final String title;

  @override
  _ResponsiveFlexPageState createState() => _ResponsiveFlexPageState();
}

class _ResponsiveFlexPageState extends State<ResponsiveFlexPage> {
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
                Container(color: Colors.green, child: Text("SOME TEXT"))),
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
