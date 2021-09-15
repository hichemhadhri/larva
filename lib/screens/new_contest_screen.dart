import 'package:flutter/material.dart';

class NewConstest extends StatefulWidget {
  const NewConstest({Key? key}) : super(key: key);

  @override
  _NewConstestState createState() => _NewConstestState();
}

class _NewConstestState extends State<NewConstest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        title:
            Text("New Contest", style: Theme.of(context).textTheme.headline6),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Create",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  ?.copyWith(color: Colors.amber),
            ),
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Text("hello"),
    );
  }
}
