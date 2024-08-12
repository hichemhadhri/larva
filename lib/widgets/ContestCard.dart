import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/user.dart';
import 'package:larva/screens/Contest_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:larva/models/contest.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class DiscoverContestCard extends StatelessWidget {
  final Contest contest;

  const DiscoverContestCard({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deadline =
        DateTime.parse(contest.endDate).difference(DateTime.now());
    final _textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContestDetails(
                      contest: Contest.createDummyContest(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (contest.mediaUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: baseURL + contest.mediaUrl,
                  height: 80,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contest.name.replaceAll(" ", "_"),
                    style: _textTheme.headlineSmall!.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Golden touch",
                    style: _textTheme.titleMedium!.copyWith(
                      color: Colors.grey,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrendingContestCard extends StatefulWidget {
  final Contest contest;

  const TrendingContestCard({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  _TrendingContestCardState createState() => _TrendingContestCardState();
}

class _TrendingContestCardState extends State<TrendingContestCard> {
  late Future<User> _creator;

  @override
  void initState() {
    super.initState();
    _creator = UserController().getUserDetails(widget.contest.createdBy);
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

  @override
  Widget build(BuildContext context) {
    final _textTheme = GoogleFonts.latoTextTheme(Theme.of(context).textTheme);
    final remainingTime =
        DateTime.parse(widget.contest.endDate).difference(DateTime.now());

    final _color = Colors.grey[850]!;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContestDetails(
              contest: widget.contest,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          color: _color,
          boxShadow: [
            BoxShadow(
              color: _color.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            FutureBuilder<User>(
              future: _creator,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade300,
                  );
                } else if (snapshot.hasError) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.error, color: Colors.white),
                  );
                } else if (!snapshot.hasData) {
                  return CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                  );
                } else {
                  final creator = snapshot.data!;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(
                            baseURL + creator.profilePicture),
                        backgroundColor: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent
                              ],
                              stops: [0.0, 0.7],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(
                              color: Colors.amber,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundImage: CachedNetworkImageProvider(
                            baseURL + widget.contest.mediaUrl,
                          ),
                          backgroundColor: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<User>(
                    future: _creator,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error loading creator',
                          style: _textTheme.bodySmall!.copyWith(
                            color: Colors.red,
                            fontSize: screenWidth * 0.03,
                          ),
                        );
                      } else if (!snapshot.hasData) {
                        return Text(
                          'Creator not found',
                          style: _textTheme.bodySmall!.copyWith(
                            color: Colors.grey,
                            fontSize: screenWidth * 0.03,
                          ),
                        );
                      } else {
                        final creator = snapshot.data!;
                        return Text(
                          creator.surname,
                          style: _textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold),
                        );
                      }
                    },
                  ),
                  Text(
                    '#${widget.contest.name.replaceAll(" ", "_")}',
                    style: _textTheme.bodySmall!.copyWith(
                      fontSize: screenWidth * 0.03,
                      color: Colors.grey[400],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(MdiIcons.timer,
                          color: remainingTime.isNegative
                              ? Colors.red
                              : Colors.green,
                          size: screenWidth * 0.05),
                      SizedBox(width: 4),
                      Text(
                        _formatDuration(remainingTime),
                        style: _textTheme.bodySmall!.copyWith(
                          color: remainingTime.isNegative
                              ? Colors.red
                              : Colors.white,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(MdiIcons.folder,
                              color: Colors.white, size: screenWidth * 0.05),
                          SizedBox(width: 4),
                          Text(
                            widget.contest.posts.length.toString(),
                            style: _textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth * 0.03,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(Icons.star,
                              color: Colors.amber, size: screenWidth * 0.05),
                          SizedBox(width: 4),
                          Text(
                            widget.contest.users.length.toString(),
                            style: _textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                              fontSize: screenWidth * 0.03,
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
    );
  }
}
