import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:larva/screens/new_post_screen.dart';

class ContestDetails extends StatefulWidget {
  final String name;
  final String img;
  final String prize;
  final int deadline;
  const ContestDetails(
      {Key? key,
      required this.name,
      required this.prize,
      required this.img,
      required this.deadline})
      : super(key: key);

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
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
  void dispose() {
    super.dispose();
    timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(widget.name),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Add(
                            custom: true,
                            contest: widget.name.replaceAll(" ", "_"))));
              },
              child: Text("join",
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Colors.amber,
                      )))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      child: SvgPicture.asset(
                        "lib/assets/images/butterfly.svg",
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.name,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                ),
                                onPressed: () {},
                                icon: Icon(
                                  Icons.add,
                                  color: Colors.amber,
                                ),
                                label: Text(
                                  "Follow",
                                  style: TextStyle(color: Colors.amber),
                                )),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Text(
                                  "1K",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                Text('Posts')
                              ],
                            ),
                            SizedBox(width: 20),
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
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Time Left : ",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "${deadline.inDays}d ${deadline.inHours % 24}h ${deadline.inMinutes % 60}m ${deadline.inSeconds % 60}s",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.amber),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Center(
                child:
                    ElevatedButton(onPressed: () {}, child: Text("See posts"))),
            Column(
              children: [
                ListTile(
                  title: Text("hichem hadhri"),
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "lib/assets/images/hichem.jpeg",
                      )),
                  trailing: Text("4.9"),
                ),
                ListTile(
                  title: Text("hichem hadhri"),
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "lib/assets/images/hichem.jpeg",
                      )),
                  trailing: Text("4.9"),
                ),
                ListTile(
                  title: Text("hichem hadhri"),
                  leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(
                        "lib/assets/images/hichem.jpeg",
                      )),
                  trailing: Text("4.9"),
                ),
                ListTile(
                  title: Text("hichem hadhri"),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: ResizeImage(
                        AssetImage(
                          "lib/assets/images/hichem.jpeg",
                        ),
                        width: 40,
                        height: 40),
                  ),
                  trailing: Text("4.9"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
