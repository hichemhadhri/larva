import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/models/post.dart';

class PostScreen extends StatefulWidget {
  final String ref;
  final String url;
  const PostScreen({Key? key, required this.ref, required this.url})
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
          automaticallyImplyLeading: true,
          actions: [],
        ),
        body: Center(
          child: Column(
            children: [
              Hero(
                tag: widget.ref,
                child: Container(
                  width: double.infinity,
                  child:
                      CachedNetworkImage(imageUrl: baseURL + '${widget.url}'),
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
                      return Text(post.description);
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        color: Colors.amber,
                      ));
                    }
                  })
            ],
          ),
        ));
    // return FutureBuilder(
    //   future: _pc.getPost(widget.ref),
    //   builder: (context, snapshot) {
    //     if (snapshot.hasData) {
    //       print('hello');
    //       final post = snapshot.data as Post;
    //       return
    //     } else {
    //       return Center(
    //           child: CircularProgressIndicator(
    //         color: Colors.amber,
    //       ));
    //     }
    //   },
    // );
  }
}
