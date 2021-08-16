import 'dart:async';

import 'package:flutter/material.dart';

class Contest extends StatefulWidget {
  final String name;
  final String img;
  final String prize;
  final int deadline;
  const Contest(
      {Key? key,
      required this.name,
      required this.prize,
      required this.img,
      required this.deadline})
      : super(key: key);

  @override
  _ContestState createState() => _ContestState();
}

class _ContestState extends State<Contest> {
  Duration deadline = Duration();
  Timer? timer;

  void countDown() {
    setState(() {
      deadline = Duration(seconds: deadline.inSeconds - 1);
    });
  }

  @override
  void initState() {
    super.initState();

    deadline = new Duration(seconds: widget.deadline);
    timer = Timer.periodic(Duration(seconds: 1), (_) => countDown());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CircleAvatar(radius: 60, backgroundColor: Colors.red),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.name,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(fixedSize: Size(110, 20)),
                onPressed: () {},
                icon: Icon(Icons.add),
                label: Text("Follow")),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      "1K",
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
                      "100£",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text('Prize')
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              deadline.inSeconds.toString(),
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.amber),
            )
          ],
        ),
      ),
    );
  }
}
