import 'package:flutter/material.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/models/post.dart';
import 'package:larva/widgets/post.dart';

class Wall extends StatefulWidget {
  final PageController controller;
  const Wall({Key? key, required this.controller}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  final PostController _pc = PostController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _pc.getPosts(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final posts = snapshot.data as List<Post>;
          return PageView.builder(
              scrollDirection: Axis.vertical,
              controller: widget.controller,
              itemCount: posts.length,
              itemBuilder: (context, index) => PostWidget(
                  color: posts[index].backgroundColor,
                  url: posts[index].mediaUrl,
                  title: posts[index].title,
                  description: posts[index].description,
                  authorName: posts[index].authorName,
                  constests: [],
                  subject: posts[index].domaine,
                  controller: widget.controller));
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
