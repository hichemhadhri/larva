import 'package:flutter/material.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/screens/new_contest_screen.dart';
import 'package:larva/widgets/card.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({Key? key}) : super(key: key);

  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  final ContestController _cc = ContestController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          automaticallyImplyLeading: false,
          title: Text("Contests"),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => NewConstest()));
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.amber,
                ),
                label: Text(
                  "New Contest",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.amber),
                )),
          ],
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20,
          ),
          Text('Hot Right Now', style: Theme.of(context).textTheme.headline4),
          SizedBox(
            height: 20,
          ),
          FutureBuilder(
              future: _cc.getContests(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contests = snapshot.data as List<Contest>;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        children: contests
                            .map((e) => ContestCard(
                                  title: e.title,
                                  prize: e.prize,
                                  creatorName: e.creatorName,
                                  creatorRef: e.creatorRef,
                                  deadline: e.deadline,
                                  description: e.description,
                                  domaines: e.domaines,
                                  id: e.id,
                                  maximumCapacity: e.maximumCapacity,
                                  mediaUrl: e.mediaUrl,
                                  posts: e.posts,
                                ))
                            .toList()),
                  );
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.amber,
                  ));
                }
              }),
          SizedBox(
            height: 20,
          ),
          Text('Near You', style: Theme.of(context).textTheme.headline4),
          SizedBox(
            height: 20,
          ),
        ]));
  }
}
