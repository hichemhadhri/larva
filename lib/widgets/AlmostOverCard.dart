import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/user.dart';
import 'package:larva/screens/Contest_details_screen.dart';
import 'package:larva/controllers/userController.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AlmostOverContestCard extends StatefulWidget {
  final Contest contest;

  const AlmostOverContestCard({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  _AlmostOverContestCardState createState() => _AlmostOverContestCardState();
}

class _AlmostOverContestCardState extends State<AlmostOverContestCard> {
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
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
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
              user: User.createDummyUser(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(8.0),
        width: screenWidth * 0.4, // Responsive width
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: _color,
          boxShadow: [
            BoxShadow(
              color: _color.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -30, // Move avatars up
              left: 0,
              right: 0,
              child: Center(
                child: FutureBuilder<User>(
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
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                                baseURL + creator.profilePicture),
                          ),
                          Positioned(
                            bottom: -5,
                            right: -5,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundImage: CachedNetworkImageProvider(
                                baseURL + widget.contest.mediaUrl,
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50), // Add space for avatars
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
                          fontSize: screenWidth * 0.03, // Responsive font size
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Text(
                        'Creator not found',
                        style: _textTheme.bodySmall!.copyWith(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.03, // Responsive font size
                        ),
                      );
                    } else {
                      final creator = snapshot.data!;
                      return Text(
                        creator.surname,
                        style: _textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.04, // Responsive font size
                            fontWeight: FontWeight.bold),
                      );
                    }
                  },
                ),

                Text(
                  '#${widget.contest.name.replaceAll(" ", "_")}',
                  style: _textTheme.bodySmall!.copyWith(
                    fontSize: screenWidth * 0.03, // Responsive font size
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(MdiIcons.timer,
                        color: Colors.red,
                        size: screenWidth * 0.04), // Responsive icon size
                    SizedBox(width: 4),
                    Text(
                      _formatDuration(remainingTime),
                      style: _textTheme.bodySmall!.copyWith(
                        color: remainingTime.isNegative
                            ? Colors.red
                            : Colors.white,
                        fontSize: screenWidth * 0.03, // Responsive font size
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Icon(MdiIcons.folder,
                            color: Color.fromARGB(255, 255, 255, 255),
                            size: screenWidth * 0.04), // Responsive icon size
                        SizedBox(width: 4),
                        Text(
                          widget.contest.posts.length.toString(),
                          style: _textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.03, // Responsive font size
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.star,
                            color: Colors.amber,
                            size: screenWidth * 0.04), // Responsive icon size
                        SizedBox(width: 4),
                        Text(
                          widget.contest.users.length.toString(),
                          style: _textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                            fontSize:
                                screenWidth * 0.03, // Responsive font size
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
