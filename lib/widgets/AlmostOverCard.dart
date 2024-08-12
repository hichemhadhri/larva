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
    final days = duration.inDays;
    final hours = twoDigits(duration.inHours.remainder(24));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    return days > 0 ? '$days d $hours h $minutes m' : '$hours h $minutes m';
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme =
        GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme);
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
        width: screenWidth * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          gradient: LinearGradient(
            colors: [Colors.grey[900]!, Colors.grey[800]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -30,
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
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
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
                        style: _textTheme.bodyMedium!.copyWith(
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
          ],
        ),
      ),
    );
  }
}
