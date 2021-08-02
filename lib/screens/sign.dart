import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/widgets/input.dart';

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  final name = TextEditingController();
  bool nameError = false;
  final surname = TextEditingController();
  bool surnameError = false;
  final email = TextEditingController();
  bool emailError = false;
  final password = TextEditingController();
  bool passwordError = false;
  final confirmPassword = TextEditingController();
  bool confirmError = false;
  final birth = TextEditingController();
  bool birthError = false;
  DateTime seletedBirth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: Padding(
            padding: c_padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Larva", style: Theme.of(context).textTheme.headline3),
                SizedBox(height: 30),
                Input(
                    controller: name,
                    error: nameError,
                    errorText: 'Invalid Name',
                    hint: 'Name'),
                Input(
                    controller: name,
                    error: surnameError,
                    errorText: 'Invalid surname',
                    hint: 'Surname'),
                Input(
                    controller: name,
                    error: surnameError,
                    errorText: 'You must be over 13',
                    hint: 'Birth'),
              ],
            ),
          )),
    );
  }
}
