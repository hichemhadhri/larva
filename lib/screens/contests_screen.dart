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
        appBar: AppBar(
            brightness: Brightness.dark,
            automaticallyImplyLeading: false,
            title: Text("Contests")),
        body: ListView(
          children: [
            ContestCard(
              color: Colors.red,
              name: "Weekly Contest 12",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.blue,
              name: "Discover Tunisia",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.brown,
              name: "Bourguiba got Talent",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.teal,
              name: "best Shots",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.indigo,
              name: "Arab Music",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.blueAccent,
              name: "weekly contest 12",
              prize: "",
            ),
            ContestCard(
              color: Colors.black,
              name: "weekly contest 12",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.lightGreen,
              name: "weekly contest 12",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.deepOrange,
              name: "weekly contest 12",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.green,
              name: "weekly contest 12",
              prize: "100 £ ",
            ),
            ContestCard(
              color: Colors.yellow,
              name: "weekly contest 12",
              prize: "100 £ ",
            ),
          ],
        ));
  }
}
