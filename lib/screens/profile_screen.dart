import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/user.dart';

class Profile extends StatefulWidget {
  final String id;
  const Profile({Key? key, required this.id}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserController _uc = UserController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _uc.getUserDetails(context, widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data as User;
          return Scaffold(
              appBar: AppBar(
                brightness: Brightness.dark,
                title: Text("${user.surname}_${user.name}"),
                centerTitle: true,
                automaticallyImplyLeading: false,
                actions: [],
              ),
              body: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                            radius: 100,
                            backgroundImage: user.pdp == ""
                                ? NetworkImage(
                                    baseURL + "default_${user.sexe}.jpeg",
                                  )
                                : NetworkImage(baseURL + user.pdp)),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "${user.surname} ${user.name}",
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(height: 20),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                          alignment: Alignment.center,
                          child: Text(user.description,
                              textAlign: TextAlign.center),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              user.pubs.length.toString(),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text('Post')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              user.followers.length.toString(),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text('Followers')
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              user.following.length.toString(),
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text('Following')
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        for (int i = 0; i < user.pubs.length; i++)
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: MediaQuery.of(context).size.width / 3,
                              width: MediaQuery.of(context).size.width / 3,
                              child: Image.network(
                                baseURL + user.pubsPhotos[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                      ],
                    ),
                  )
                ]),
              ));
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.amber,
          ));
        }
      },
    );
  }
}
