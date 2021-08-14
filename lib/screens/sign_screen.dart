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
  DateTime selectedBirth = DateTime.now();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    name.dispose();
    surname.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    birth.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: c_padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Larva", style: Theme.of(context).textTheme.headline3),
                SizedBox(height: 100),
                Input(
                    controller: name,
                    error: nameError,
                    errorText: 'Invalid Name',
                    hint: 'Name'),
                Input(
                    controller: surname,
                    error: surnameError,
                    errorText: 'Invalid surname',
                    hint: 'Surname'),
                Input(
                    controller: birth,
                    error: surnameError,
                    errorText: 'You must be over 13',
                    hint: 'Birth'),
                Input(
                    controller: email,
                    error: surnameError,
                    errorText: 'Invalid email',
                    hint: 'Email'),
                Input(
                  controller: password,
                  error: surnameError,
                  errorText: 'Password must be over 8 characters',
                  hint: 'Password',
                  obscure: true,
                ),
                Input(
                    controller: confirmPassword,
                    error: surnameError,
                    errorText: 'Ppasswords do not much',
                    hint: 'Confirm password',
                    obscure: true),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        child: Text("Sign up"),
                        onPressed: () {
                          Navigator.pushNamed(context, "nav");
                        }),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
