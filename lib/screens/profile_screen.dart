import 'dart:io';

import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/user.dart';
import 'package:larva/providers/dbstate_provider.dart';
import 'package:larva/screens/post_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:larva/widgets/customWidget.dart';
import 'package:provider/provider.dart';

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
    context.watch<DbState>().state;
    return FutureBuilder(
      future: _uc.getUserDetails(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data as User;
          print(user.pubs.length);

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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        crossAxisCount: 3),
                    itemCount: user.pubs.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostScreen(
                                      author: user.surname + ' ' + user.name,
                                      ref: user.pubs[i])));
                        },
                        child: Hero(
                          tag: user.pubs[i],
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(
                                          baseURL + 'posts/' + user.pubs[i])))),
                        ),
                      );
                    },
                  )
                ]),
              ));
        } else {
          return Scaffold(
              appBar: AppBar(
                brightness: Brightness.dark,
                title: CustomWidget.rectangular(height: 10, width: 150),
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
                        CustomWidget.circular(height: 200, width: 200),
                        SizedBox(
                          height: 20,
                        ),
                        CustomWidget.rectangular(height: 10, width: 50),
                        SizedBox(height: 20),
                        Container(
                          margin:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 50),
                          alignment: Alignment.center,
                          child:
                              CustomWidget.rectangular(height: 10, width: 200),
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
                            CustomWidget.rectangular(height: 10, width: 20),
                            SizedBox(height: 5),
                            CustomWidget.rectangular(height: 10, width: 50),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            CustomWidget.rectangular(height: 10, width: 20),
                            SizedBox(height: 5),
                            CustomWidget.rectangular(height: 10, width: 50),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            CustomWidget.rectangular(height: 10, width: 20),
                            SizedBox(height: 5),
                            CustomWidget.rectangular(height: 10, width: 50),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0,
                        crossAxisCount: 3),
                    itemCount: 9,
                    itemBuilder: (context, i) {
                      return CustomWidget.notRounded(height: 30, width: 30);
                    },
                  )
                ]),
              ));
        }
      },
    );
  }
}
