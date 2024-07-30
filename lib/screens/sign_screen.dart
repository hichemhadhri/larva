import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:larva/constants/constants.dart';

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
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: c_padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Larva", style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: 40),
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                    errorText: nameError ? 'Invalid Name' : null,
                    hintText: 'Name',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: surname,
                  decoration: InputDecoration(
                    errorText: surnameError ? 'Invalid surname' : null,
                    hintText: 'Surname',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: birth,
                  decoration: InputDecoration(
                    errorText: birthError ? 'You must be over 13' : null,
                    hintText: 'Birth',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: email,
                  decoration: InputDecoration(
                    errorText: emailError ? 'Invalid email' : null,
                    hintText: 'Email',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: password,
                  decoration: InputDecoration(
                    errorText: passwordError
                        ? 'Password must be over 8 characters'
                        : null,
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmPassword,
                  decoration: InputDecoration(
                    errorText: confirmError ? 'Passwords do not match' : null,
                    hintText: 'Confirm password',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: Text("Sign up"),
                      onPressed: () {
                        Navigator.pushNamed(context, "nav");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
