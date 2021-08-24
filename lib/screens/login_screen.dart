import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:larva/controllers/authentificationController.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _username = TextEditingController();

  final _password = TextEditingController();
  Auth _auth = Auth();

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
                  keyboardType: TextInputType.emailAddress,
                  controller: _username,
                  decoration:
                      InputDecoration(errorText: errorEmail, hintText: 'email'),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    errorText: errorPassword,
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
                      onPressed: () async {
                        int result = await _auth.authentificate(
                            _username.text, _password.text, context);
                        if (result == 200) {
                          setState(() {
                            errorEmail = null;
                            errorPassword = null;
                          });
                          Navigator.pushNamed(context, "nav");
                        } else if (result == 404) {
                          setState(() {
                            errorPassword = null;
                            errorEmail = "User with this email does not exist";
                          });
                        } else {
                          setState(() {
                            errorEmail = null;
                            errorPassword = "Password is incorrect";
                          });
                        }
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
