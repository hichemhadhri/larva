import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';

class Tag extends StatelessWidget {
  final String string;
  final int color;
  const Tag({required this.string, required this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            color: colors.elementAt(color),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text(
            string,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ));
  }
}
