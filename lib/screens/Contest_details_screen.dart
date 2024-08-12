import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/post.dart';
import 'package:larva/models/user.dart';
import 'package:larva/screens/new_post_screen.dart';
import 'package:larva/screens/wall_screen.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:preload_page_view/preload_page_view.dart';

class ContestDetails extends StatefulWidget {
  final Contest contest;

  const ContestDetails({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  Duration deadline = Duration();
  Timer? timer;
  List<Post> bestPosts = [];
  Map<String, User> users = {};
  User? creator;
  bool isLoading = true;
  final ContestController _contestController = ContestController();
  final UserController _userController = UserController();

  void countDown() {
    setState(() {
      deadline = Duration(seconds: deadline.inSeconds - 1);
    });
  }

  void reorderTopThree(List<Post> posts) {
    if (posts.length >= 2) {
      final temp = posts[0];
      posts[0] = posts[1];
      posts[1] = temp;
    }
  }

  @override
  void initState() {
    super.initState();
    deadline =
        DateTime.parse(widget.contest.endDate).difference(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (_) => countDown());
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
    });

    // Fetch creator details
    creator = await _userController.getUserDetails(widget.contest.createdBy);

    // Fetch top 10 posts
    bestPosts =
        await _contestController.getTop10Posts(context, widget.contest.id);

    // Fetch details for each post's creator
    for (var post in bestPosts) {
      if (!users.containsKey(post.author)) {
        users[post.author] = await _userController.getUserDetails(post.author);
      }
    }

    setState(() {
      isLoading = false;
      reorderTopThree(bestPosts);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) {
      return 'Finished';
    }
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  String _formatTotalDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);
    return '${days} days ';
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: CachedNetworkImageProvider(
                                    baseURL + widget.contest.mediaUrl),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              capitalizeFirstLetter(widget.contest.name),
                              style: textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Created by: ${creator?.surname ?? 'Loading...'}',
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            Text(
                              'Created on: ${DateTime.parse(widget.contest.createdAt).day}/${DateTime.parse(widget.contest.createdAt).month}/${DateTime.parse(widget.contest.createdAt).year}',
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "🏆 ${widget.contest.prizes}",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "⏰ ${_formatDuration(deadline)}",
                                        style: textTheme.bodyMedium!.copyWith(
                                          color: deadline.isNegative
                                              ? Colors.red
                                              : Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "⭐ ${widget.contest.posts.length}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        "📝 ${widget.contest.posts.length}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        "👥 ${widget.contest.users.length}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                      Text(
                                        "⏳ ${_formatTotalDuration(DateTime.parse(widget.contest.startDate), DateTime.parse(widget.contest.endDate))}",
                                        style: textTheme.bodyMedium!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Wall(
                              controller: PreloadPageController(),
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.visibility,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "View posts",
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Icon(MdiIcons.trophyVariant, color: Colors.amber),
                      SizedBox(width: 10),
                      Text(
                        "Leaderboard",
                        style: textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Leaderboard for top 3 posts
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      border: Border.symmetric(
                        horizontal: BorderSide(
                          color: Colors.grey[800]!,
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: bestPosts.take(3).map((post) {
                        int rank = bestPosts.indexOf(post) + 1;
                        if (rank == 2)
                          rank = 1;
                        else if (rank == 1) rank = 2;
                        return Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.amber, width: 3),
                                  ),
                                  child: CircleAvatar(
                                    radius: rank == 1 ? 40 : 30,
                                    backgroundImage: NetworkImage(baseURL +
                                        users[post.author]!.profilePicture),
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
                                      rank.toString(),
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              users[post.author]?.surname ?? 'Loading...',
                              style: textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              post.title,
                              style: textTheme.bodySmall!.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      post.ratings.length.toString(),
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    Text(
                                      post.fans.length.toString(),
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      Icons.star_half,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      post.averageRating.toStringAsFixed(1),
                                      style: textTheme.bodySmall!.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  // List of other posts
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: bestPosts.skip(3).map((post) {
                        int rank = bestPosts.indexOf(post) + 1;
                        return ListTile(
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "$rank. ",
                                style: textTheme.bodySmall!.copyWith(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.amber, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(baseURL +
                                      users[post.author]!.profilePicture),
                                ),
                              ),
                            ],
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                users[post.author]?.surname ?? 'Loading...',
                                style: textTheme.bodySmall!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                post.title,
                                style: textTheme.bodySmall!.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Text(
                                        post.ratings.length.toString(),
                                        style: textTheme.bodySmall!.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                      Text(
                                        post.fans.length.toString(),
                                        style: textTheme.bodySmall!.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.star_half,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      Text(
                                        post.averageRating.toStringAsFixed(1),
                                        style: textTheme.bodySmall!.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.black,
    );
  }

  String capitalizeFirstLetter(String name) {
    // Capitalize the first letter of each word in the name
    return name.split(" ").map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(" ");
  }
}
