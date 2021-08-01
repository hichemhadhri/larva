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

  String? errorPassword = null;
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
    return SafeArea(
      child: Scaffold(
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
                    child: Text("Larva",
                        style: Theme.of(context).textTheme.headline6),
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
                    height: MediaQuery.of(context).size.height / 30,
                  ),
                  ButtonBar(
                    children: [
                      TextButton(
                        child: Text('SIGN UP'),
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        child: Text('LOGIN'),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
