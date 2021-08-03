import 'package:flutter/material.dart';
import 'package:larva/screens/new_post_screen.dart';
import 'package:larva/screens/profile_screen.dart';
import 'package:larva/screens/wall_screen.dart';

class Nav extends StatefulWidget {
  const Nav({Key? key}) : super(key: key);

  @override
  _NavState createState() => _NavState();
}

class _NavState extends State<Nav> {
  //index in bottomBar
  int _selectedIndex = 0;

  //handle routing on tapping on item
  void onTapItem(int i) {
    setState(() {
      _selectedIndex = i;
    });
  }

  List<Widget> pages = [Wall(), Add(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTapItem,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}
