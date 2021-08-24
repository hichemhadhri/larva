import 'package:flutter/material.dart';
import 'package:larva/screens/contests_screen.dart';
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
    } else {
      setState(() {
        _selectedIndex = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Wall(
            controller: controller,
          ),
          ContestScreen(),
          Add(),
          Profile()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: onTapItem,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Contests"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ]),
    );
  }
}
