import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  PageController controller = PageController();

  //handle routing on tapping on item
  void onTapItem(int i) {
    if (_selectedIndex == i && i == 0) //refresh home screen
    {
      controller.animateToPage(0,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
    }
    setState(() {
      _selectedIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark, // status bar brightness
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: [
        Wall(
          controller: controller,
        ),
        Add(),
        Profile()
      ].elementAt(_selectedIndex),
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
