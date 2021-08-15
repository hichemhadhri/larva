import 'package:flutter/material.dart';

class ContestCard extends StatelessWidget {
  final Color color;
  final String name;

  final String prize;
  const ContestCard(
      {required this.color, Key? key, required this.name, required this.prize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      onTap: () {},
      tileColor: Colors.black,
      focusColor: Colors.amber,
      leading: CircleAvatar(
          backgroundColor: color, child: Text(name.substring(0, 1))),
      title: Text(
        name,
        style: Theme.of(context).textTheme.headline6,
      ),
      subtitle: Text(
        "prize : " + prize,
        style: Theme.of(context).textTheme.overline,
      ),
      trailing: Wrap(
        children: [
          Text(
            "7 Days ",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.amber),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}
