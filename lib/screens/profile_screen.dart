import 'dart:io';

import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
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
  bool _select = false;
  late File _selectedMedia;

  void _getAndUploadImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.all,
      quality: 0.8, // only for android
      maxSize: 500,
    );
    setState(() {
      _selectedMedia = File(res!.first.path);
      _select = true;
    });

    await _uc.uploadPdp(context, widget.id, _selectedMedia);
  }

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
                        GestureDetector(
                          onTap: () {
                            _getAndUploadImage();
                          },
                          child: CircleAvatar(
                              radius: 100,
                              backgroundImage: _select
                                  ? FileImage(_selectedMedia) as ImageProvider
                                  : user.pdp == ""
                                      ? NetworkImage(
                                          baseURL + "default_${user.sexe}.jpeg",
                                        )
                                      : NetworkImage(baseURL + user.pdp)),
                        ),
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
