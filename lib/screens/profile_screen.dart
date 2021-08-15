import 'dart:math';

import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<MaterialColor> _colors = [
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.blue,
    Colors.pink,
    Colors.indigo,
    Colors.deepPurple,
    Colors.lightGreen
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text("user_name"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: Text("U"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Username Dummy ",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                    alignment: Alignment.center,
                    child: Text(
                        """This is a dummy username\nI am fond of app developing and saying nimporte quoi mainteneant follow me for more
                      """,
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "13",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('Post')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "1K",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('Followers')
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "1M",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text('Following')
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              child: Wrap(
                children: <Widget>[
                  for (int i = 0; i < 9; i++)
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          height: MediaQuery.of(context).size.width / 3,
                          width: MediaQuery.of(context).size.width / 3,
                          color: _colors.elementAt(new Random().nextInt(8))),
                    )
                ],
              ),
            )
          ]),
        ));
  }
}
