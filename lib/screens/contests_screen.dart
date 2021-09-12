import 'package:flutter/material.dart';
import 'package:larva/widgets/card.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({Key? key}) : super(key: key);

  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          title: Text("Contests"),
          actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Text('Hot Right Now', style: Theme.of(context).textTheme.headline4),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                ),
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                ),
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                )
              ])),
          SizedBox(
            height: 20,
          ),
          Text('Near You', style: Theme.of(context).textTheme.headline4),
          SizedBox(
            height: 20,
          ),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                ),
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                ),
                ContestCard(
                  color: Colors.red,
                  name: "Weekly Contest 12",
                  prize: "100 £ ",
                )
              ])),
        ]));
  }
}
