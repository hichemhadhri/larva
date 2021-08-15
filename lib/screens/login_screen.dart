import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _username = TextEditingController();

  final _password = TextEditingController();

  String? errorPassword;
  String? errorEmail;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _password.dispose();
    _username.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 9),
                SvgPicture.asset(
                  "lib/assets/images/butterfly.svg",
                  height: 200,
                  color: Colors.white,
                ),
                Center(
                  child: Text("Butterfly",
                      style: Theme.of(context).textTheme.headline5),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 9),
                TextField(
                  controller: _username,
                  decoration:
                      InputDecoration(errorText: null, hintText: 'email'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    errorText: null,
                    hintText: 'Password',
                  ),
                  obscureText: true,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: Text('SIGN UP'),
                      onPressed: () {
                        Navigator.pushNamed(context, "sign");
                      },
                    ),
                    ElevatedButton(
                      child: Text('LOGIN'),
                      onPressed: () {
                        Navigator.pushNamed(context, "nav");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
