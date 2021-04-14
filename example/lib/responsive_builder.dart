import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_property/responsive_property.dart';

class ResponsiveBuilderPage extends StatefulWidget {
  ResponsiveBuilderPage({this.title = "Responsive Builder"});

  final String title;

  @override
  _ResponsiveBuilderPageState createState() => _ResponsiveBuilderPageState();
}

class _ResponsiveBuilderPageState extends State<ResponsiveBuilderPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
          child: ScreenBuilder.builder(
        mobileBuilder: _mobileBuilder,
        tabletBuilder: _tabletBuilder,
        desktopBuilder: _desktopBuilder,
      )),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _mobileBuilder(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Center(child: _widgetOptions.elementAt(_selectedIndex))),
        BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Business',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        )
      ],
    );
  }

  Widget _tabletBuilder(BuildContext context) {
    return ListView(
      children: _widgetOptions
          .map((e) => Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
                child: e,
              ))
          .toList(),
    );
  }

  Widget _desktopBuilder(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: _widgetOptions,
    );
  }
}
