import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/screens/new_contest_screen.dart';
import 'package:larva/widgets/AlmostOverCard.dart';
import 'package:larva/widgets/ContestCard.dart';

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
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Almost Over',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: _cc.getContests(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final contests = snapshot.data as List<Contest>;
                    final almostOverContests = contests
                        .where((contest) =>
                            DateTime.parse(contest.endDate)
                                .difference(DateTime.now())
                                .inDays <
                            1)
                        .toList();

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      child: Row(
                        children: almostOverContests
                            .map((contest) =>
                                AlmostOverContestCard(contest: contest))
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
              Text(
                'Trending contests',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                    ),
              ),
              SizedBox(height: 10),
              FutureBuilder(
                future: _cc.getContests(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final contests = snapshot.data as List<Contest>;
                    return Column(
                      children: contests
                          .map((contest) =>
                              TrendingContestCard(contest: contest))
                          .toList(),
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
      ),
    );
  }
}
