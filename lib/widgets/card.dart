import 'dart:math';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/screens/Contest_details_screen.dart';

class ContestCard extends StatelessWidget {
  final Color color;
  final String name;

  final String prize;
  const ContestCard(
      {required this.color, Key? key, required this.name, required this.prize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    Random _random = Random();
    return Container(
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
            name.replaceAll(" ", "_"),
            style: _textTheme.headline5!.copyWith(color: Colors.black),
          ),
          Text(
            "hichem hadhri ",
            style: _textTheme.subtitle1!.copyWith(color: Colors.black87),
          ),
          Row(
            children: c_icons.sublist(0, 3),
          ),
          Text(
            "Prize : ${prize}",
            style: _textTheme.bodyText1!.copyWith(color: Colors.black),
          ),
          Text("Deadline: 1h 3 m 0s",
              style: _textTheme.bodyText1!.copyWith(color: Colors.black))
        ],
      ),
    );
  }
}
