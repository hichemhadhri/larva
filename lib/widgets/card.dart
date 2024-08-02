import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/screens/Contest_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:larva/models/contest.dart';

class ContestCard extends StatelessWidget {
  final Contest contest;

  const ContestCard({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deadline =
        DateTime.parse(contest.endDate).difference(DateTime.now());
    final _textTheme = Theme.of(context).textTheme;
    Random _random = Random();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContestDetails(
                      contestId: contest.id,
                      name: contest.name,
                      prize: contest.prizes,
                      img: contest.mediaUrl,
                      deadline: DateTime.parse(contest.endDate)
                          .difference(DateTime.now())
                          .inSeconds,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: colors.elementAt(_random.nextInt(8)).shade300,
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
                    "By ${contest.createdBy}",
                    style: _textTheme.titleMedium!.copyWith(
                      color: Colors.black87,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: c_icons.sublist(0, 3),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Prize: ${contest.prizes}",
                    style: _textTheme.bodyLarge!.copyWith(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                      "Ends in: ${_deadline.inDays}d ${_deadline.inHours % 24}h ${_deadline.inMinutes % 60}m ${_deadline.inSeconds % 60}s",
                      style: _textTheme.bodyLarge!.copyWith(
                        color: Colors.redAccent,
                        fontSize: 10,
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
