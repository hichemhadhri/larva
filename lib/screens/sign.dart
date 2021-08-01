import 'package:larva/models/user.dart';
import 'package:flutter/material.dart';

class Sign extends StatefulWidget {
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<Sign> {
  // controllers
  final name = TextEditingController();
  final surname = TextEditingController();
  final age = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final birth = TextEditingController();
  var date = DateTime.now();

  String? signError;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    password.dispose();
    name.dispose();
    surname.dispose();
    age.dispose();
    confirmPassword.dispose();
    birth.dispose();
    email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(children: <Widget>[
        Padding(
            padding: EdgeInsets.fromLTRB(
                0, MediaQuery.of(context).size.height / 50, 0, 0),
            child: Image.asset(
              'lib/assets/stars.png',
              color: Colors.white,
            )),
        SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SafeArea(
                      child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      'Artigo',
                      style: Theme.of(context).textTheme.headline1,
                    ),
                  )),
                  SizedBox(height: height / 200),
                  customInput(
                    'name',
                    Icons.person,
                    null,
                    name,
                  ),
                  customInput(
                    'surname',
                    Icons.person_outline,
                    null,
                    surname,
                  ),
                  customInput(
                    'age',
                    Icons.access_time,
                    null,
                    age,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width / 6, height / 40, width / 6, 0),
                    child: GestureDetector(
                        child: Text('date of birth'),
                        onTap: () {
                          showMaterialDatePicker(
                            context: context,
                            selectedDate: date,
                            onChanged: (value) => setState(() => date = value),
                          );
                        }),
                  ),
                  customInput(
                    'email',
                    Icons.email,
                    null,
                    email,
                  ),
                  customInput(
                    'password',
                    Icons.vpn_key,
                    null,
                    password,
                  ),
                  customInput('confirm passowrd', Icons.lock, signError,
                      confirmPassword),
                  Container(
                      width: width / 3,
                      height: height / 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        gradient: LinearGradient(
                          colors: [gold, Colors.white],
                        ),
                      ),
                      margin: EdgeInsets.fromLTRB(0, height / 30, 0, 0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                        onPressed: () {
                          Map<String, dynamic> data = Map<String, dynamic>();
                          data["mail"] = email.text;
                          data["name"] = name.text;
                          data["surname"] = surname.text;
                          data["age"] = age.text;
                          data["dateOfBirth"] = date;
                          data["password"] = password.text;
                          data["confirmPassword"] = confirmPassword.text;
                          data["userpdp"] =
                              "https://firebasestorage.googleapis.com/v0/b/artigo-4a5f3.appspot.com/o/no-img.png?alt=media&token=5d94c78c-a006-4033-bf2c-aa604fff54d9";
                          data["sexe"] = "male";
                          data["description"] = "";
                          data["location"] = " ";
                          data["interets"] = List();
                          data["pubs"] = List();
                          data["pubsphotos"] = List();
                          data["followers"] = 0;
                          data["following"] = List();
                          data["superliked"] = List();
                          data["superlikedpicss"] = List();
                          data["badges"] = "00000";
                          data["badgesref"] = List();
                          data["likes"] = 0;
                          data["superlikes"] = 0;
                          data["mostLiked"] = ""; //docref
                          data["mostsuperliked"] = ""; //docref
                          data["createdAt"] = DateTime.now().toString();
                          data["collabs"] = List();
                          data["totalviews"] = 0;

                          print(data);
                          Userp user;
                          db
                              .signUp(data["mail"], data)
                              .then((value) {
                                print("signUp successfully");
                                user = value;
                                setState(() {
                                  signError = null;
                                });
                                Navigator.pushNamed(context, '/wall',
                                    arguments: user);
                              })
                              .then((value) {})
                              .catchError((error) {
                                print("error is " + error);
                                setState(() {
                                  signError = error;
                                });
                                print("sign error is " + signError);
                              });
                        },
                        color: Colors.transparent,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )),
                ]),
          ),
        ),
      ]),
    );
  }
}

Widget customInput(String placeholder, IconData icon, String? error,
    TextEditingController controller) {
  return Padding(
    padding: EdgeInsets.fromLTRB(g_width / 6, g_height / 100, g_width / 6, 0),
    child: TextFormField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          errorText: error,
          errorStyle: TextStyle(
            color: Colors.redAccent,
            fontSize: 12,
          ),
          hintText: placeholder,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 20),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Color.fromARGB(255, 233, 200, 10), width: 3)),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: gold,
              width: 2,
            ),
          )),
    ),
  );
}
