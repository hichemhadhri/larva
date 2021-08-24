import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:larva/constants/constants.dart';

class PostWidget extends StatefulWidget {
  final String title;
  final String description;
  final String authorName;
  final List<String> constests;
  final String subject;
  final PageController controller;
  final String url;

  const PostWidget(
      {Key? key,
      required this.title,
      required this.description,
      required this.authorName,
      required this.constests,
      required this.subject,
      required this.controller,
      required this.url})
      : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        brightness: Brightness.dark,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: Text(widget.subject,
                    style: Theme.of(context).textTheme.headline6)),
            SizedBox(height: 50),
            Row(
              children: [
                CircleAvatar(child: Text(widget.authorName.substring(0, 1))),
                SizedBox(width: 10),
                Text(widget.authorName,
                    style: Theme.of(context).textTheme.headline6),
              ],
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: widget.constests
                    .map((e) =>
                        Text(e, style: Theme.of(context).textTheme.caption))
                    .toList()),
            SizedBox(height: 10),
            Expanded(child: Image.network(baseURL + widget.url)),
            SizedBox(height: 20),
            Text(widget.title, style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(widget.description,
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            SizedBox(height: 30),
            Center(
              child: RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                unratedColor: Colors.amber[100],
                itemPadding: const EdgeInsets.all(4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: gold,
                ),
                onRatingUpdate: (rating) {
                  widget.controller.nextPage(
                      duration: Duration(milliseconds: 400),
                      curve: Curves.easeIn);
                },
              ),
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
    );
  }
}
