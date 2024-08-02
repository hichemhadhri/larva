import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Contests"),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateContestScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.add,
              color: Colors.amber,
            ),
            label: Text(
              "New Contest",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.amber),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Contests by Your Followed Creators',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.amber,
                    ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _cc.getContests(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contests = snapshot.data as List<Contest>;
                  // Filter contests by followed creators
                  final followedCreatorContests = contests
                      .where((contest) =>
                          contest.createdBy !=
                          null) // Add your own filter condition
                      .toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: followedCreatorContests
                          .map((contest) => ContestCard(contest: contest))
                          .toList(),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'All',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.amber,
                    ),
              ),
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: _cc.getContests(context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final contests = snapshot.data as List<Contest>;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: contests
                          .map((contest) => ContestCard(contest: contest))
                          .toList(),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
