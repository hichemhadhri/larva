import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/screens/Contest_details_screen.dart';

class ContestCard extends StatelessWidget {
  final String description;
  final String title;

  final String creatorName;

  final String creatorRef;
  final String mediaUrl;

  final List<dynamic> posts;
  final List<dynamic> domaines;
  final String deadline;
  final String prize;
  final int maximumCapacity;
  final String id;
  const ContestCard({
    Key? key,
    required this.deadline,
    required this.prize,
    required this.maximumCapacity,
    required this.posts,
    required this.id,
    required this.description,
    required this.title,
    required this.domaines,
    required this.creatorName,
    required this.creatorRef,
    required this.mediaUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deadline = DateTime.parse(deadline).difference(DateTime.now());
    final _textTheme = Theme.of(context).textTheme;
    Random _random = Random();
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContestDetails(
                      name: title,
                      prize: prize,
                      img: mediaUrl,
                      deadline: DateTime.parse(deadline)
                          .difference(DateTime.now())
                          .inSeconds,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: colors.elementAt(_random.nextInt(8)).shade300,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.replaceAll(" ", "_"),
              style: _textTheme.headline5!.copyWith(color: Colors.black),
            ),
            Text(
              creatorName,
              style: _textTheme.subtitle1!.copyWith(color: Colors.black87),
            ),
            Row(
              children: c_icons.sublist(0, 3),
            ),
            Text(
              "Prize : $prize",
              style: _textTheme.bodyText1!.copyWith(color: Colors.black),
            ),
            Text(
                "Deadline: ${_deadline.inDays}d ${_deadline.inHours % 24}h ${_deadline.inMinutes % 60}m ${_deadline.inSeconds % 60}s",
                style: _textTheme.bodyText1!.copyWith(color: Colors.black))
          ],
        ),
      ),
    );
  }
}
