import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/models/post.dart';
import 'package:larva/widgets/customWidget.dart';
import 'package:larva/widgets/post.dart';
import 'package:preload_page_view/preload_page_view.dart';

class Wall extends StatefulWidget {
  final PreloadPageController controller;
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

          return PreloadPageView.builder(
              preloadPagesCount: 4,
              scrollDirection: Axis.vertical,
              controller: widget.controller,
              itemCount: posts.length,
              itemBuilder: (context, index) => PostWidget(
                  post: posts[index], controller: widget.controller));
        } else {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            body: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: CustomWidget.rectangular(height: 15, width: 200)),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      children: [
                        CustomWidget.circular(height: 40, width: 40),
                        SizedBox(width: 20),
                        CustomWidget.rectangular(height: 15, width: 150)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: Center(
                          child: Container(
                              width: double.infinity,
                              child: InteractiveViewer(
                                child: CustomWidget.rectangular(height: 300),
                              )))),
                  SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: CustomWidget.rectangular(height: 15, width: 100)),
                  SizedBox(height: 10),
                  Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: CustomWidget.rectangular(height: 15, width: 200)),
                  SizedBox(height: 30),
                  SizedBox(height: 70)
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
