import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        elevation: 0,
        title:
            Text("New Contest", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              "Create",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.amber),
            ),
          ),
        ],
        automaticallyImplyLeading: true, systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Text("hello"),
    );
  }
}
