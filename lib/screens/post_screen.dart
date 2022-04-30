import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/models/post.dart';
import 'package:larva/providers/dbstate_provider.dart';
import 'package:provider/provider.dart';

class PostScreen extends StatefulWidget {
  final String ref;

  final String author;
  const PostScreen({Key? key, required this.ref, required this.author})
      : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  PostController _pc = PostController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          brightness: Brightness.dark,
          centerTitle: true,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  _showEditOptions();
                },
                icon: Icon(Icons.more_horiz))
          ],
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                widget.author,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 10),
            Hero(
              tag: widget.ref,
              child: Container(
                width: double.infinity,
                child: CachedNetworkImage(
                    imageUrl: baseURL + 'posts/${widget.ref}'),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: _pc.getPost(widget.ref),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final post = snapshot.data as Post;
                    return Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(post.title,
                            style: Theme.of(context).textTheme.headline5),
                        SizedBox(
                          height: 10,
                        ),
                        Text(post.description,
                            style: Theme.of(context).textTheme.subtitle1),
                        SizedBox(
                          height: 10,
                        ),
                        Text(post.createdAt.substring(0, 10),
                            style: Theme.of(context).textTheme.caption)
                      ],
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      color: Colors.amber,
                    ));
                  }
                })
          ],
        ));
  }

  void _showEditOptions() {
    showModalBottomSheet(
        backgroundColor: Colors.grey[900],
        context: context,
        builder: (context) {
          return Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height / 3.5,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Center(
                  child: ListView.separated(
                      separatorBuilder: (_, _n) =>
                          Divider(height: 0.001, color: Colors.white),
                      itemBuilder: (context, i) => _modalItem(
                          context,
                          _options[i],
                          _options[i] == 'Delete' ? Colors.red : Colors.white,
                          widget.ref),
                      itemCount: 4)),
            ),
          );
        });
  }

  List<String> _options = ['Modify', 'Report', 'Share', 'Delete'];
  Widget _modalItem(
      BuildContext context, String title, Color color, String ref) {
    return GestureDetector(
      onTap: () async {
        EasyLoading.show(status: 'Deleting post...');
        int result;
        switch (title) {
          case 'Delete':
            result = await _pc.deletePost(ref);
            break;
          default:
            result = await Future.delayed(Duration(seconds: 2), () {
              return 2;
            });
            break;
        }
        if (result == 200) {
          await EasyLoading.showSuccess('Post has been sucessfully deleted!');
          Navigator.pop(context);
          context.read<DbState>().setState();
          Navigator.pop(context);
        } else {
          EasyLoading.showError('Something went wrong!');
        }

        EasyLoading.dismiss();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border(),
        ),
        height: MediaQuery.of(context).size.height / 15,
        child: Center(
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: color, fontSize: 20)),
        ),
      ),
    );
  }
}
