import 'package:flutter/material.dart';
import 'package:larva/widgets/post.dart';

class Wall extends StatefulWidget {
  final PageController controller;
  const Wall({Key? key, required this.controller}) : super(key: key);

  @override
  _WallState createState() => _WallState();
}

class _WallState extends State<Wall> {
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: widget.controller,
      scrollDirection: Axis.vertical,
      children: [
        Post(
          controller: widget.controller,
          title: "hello IOS",
          description: "building wall layout",
          authorName: "Hichem Hadhri",
          constests: "artigo",
          subject: "Development",
        ),
        Post(
            controller: widget.controller,
            title: "Wt aamalna thawra",
            description: "niggas know my aka",
            authorName: "A.L.A",
            constests: "zahrouni",
            subject: "Music"),
        Post(
            controller: widget.controller,
            title: "Sunset lover",
            description: "golden moment in mornag",
            authorName: "Unknown",
            constests: "guruShots",
            subject: "Photography")
      ],
    );
  }
}
