import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/post.dart';
import 'package:larva/models/user.dart';
import 'package:larva/screens/new_post_screen.dart';

class ContestDetails extends StatefulWidget {
  final User user;
  final Contest contest;

  const ContestDetails({
    Key? key,
    required this.user,
    required this.contest,
  }) : super(key: key);

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  Duration deadline = Duration();
  Timer? timer;
  List<Post> bestPosts = [];
  bool isLoading = true;
  final ContestController _contestController = ContestController();

  void countDown() {
    setState(() {
      deadline = Duration(seconds: deadline.inSeconds - 1);
    });
  }

  @override
  void initState() {
    super.initState();
    deadline =
        DateTime.parse(widget.contest.endDate).difference(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (_) => countDown());
    _fetchBestPosts();
  }

  Future<void> _fetchBestPosts() async {
    // Simulate fetching posts
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      bestPosts = []; // Populate with dummy posts if needed
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Contest Ended';
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contest.name, style: textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(
                    fromContest: true,
                    contestId: widget.contest.id,
                    contestName: widget.contest.name,
                  ),
                ),
              );
            },
            child: Text(
              "Join",
              style: textTheme.titleLarge!.copyWith(
                color: Colors.amber,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage:
                    CachedNetworkImageProvider(widget.contest.mediaUrl),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(
                    widget.contest.name,
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Prize: ${widget.contest.prizes}",
                    style: textTheme.bodyMedium!.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Time Left:",
                    style: textTheme.bodyMedium!.copyWith(color: Colors.white),
                  ),
                  Text(
                    _formatDuration(deadline),
                    style: textTheme.bodyMedium!.copyWith(
                      color: deadline.isNegative ? Colors.red : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    "See posts",
                    style: textTheme.bodyMedium!.copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(height: 20),
            Text(
              "Leaderboard",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[900],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    40), // Adjust height as needed
                                            Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.amber,
                                                        width: 3),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage: NetworkImage(
                                                        'https://picsum.photos/200/' +
                                                            Random()
                                                                .nextInt(100)
                                                                .toString()),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -10,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      "2",
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "John",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "356",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    20), // Adjust height as needed
                                            Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.amber,
                                                        width: 3),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius:
                                                        40, // Larger size for the first place
                                                    backgroundImage: NetworkImage(
                                                        'https://picsum.photos/200/' +
                                                            Random()
                                                                .nextInt(100)
                                                                .toString()),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -10,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      "1",
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "samstone",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "438",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                                height:
                                                    60), // Adjust height as needed
                                            Stack(
                                              clipBehavior: Clip.none,
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.amber,
                                                        width: 3),
                                                  ),
                                                  child: CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(widget.user
                                                            .profilePicture),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: -10,
                                                  child: Container(
                                                    padding: EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      "3",
                                                      style: textTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              "sofieee",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              "278",
                                              style:
                                                  textTheme.bodySmall!.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/200/' +
                                  Random(100).nextInt(150).toString()),
                        ),
                        title: Text(
                          "you",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "75",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/200/' +
                                  Random(150).nextInt(100).toString()),
                        ),
                        title: Text(
                          "abdulrahman",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "77",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://picsum.photos/200/' +
                                  Random().nextInt(100).toString()),
                        ),
                        title: Text(
                          "kimmylu",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "65",
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
