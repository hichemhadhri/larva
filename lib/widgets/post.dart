import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/providers/userid_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/post.dart';

class PostWidget extends StatefulWidget {
  final Post post;
  final PreloadPageController controller;

  const PostWidget({
    Key? key,
    required this.post,
    required this.controller,
  }) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with AutomaticKeepAliveClientMixin {
  late BetterPlayerController _videoController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  bool isVideo = false;
  bool isLoading = true;
  late String authorName;
  late String authorPdp;
  final PostController _pc = PostController();

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
    isVideo = widget.post.mediaUrl.endsWith('.mp4') ||
        widget.post.mediaUrl.endsWith('.m3u8');
    if (isVideo) {
      _initializePlayer();
    }
  }

  Future<void> _fetchUserInfo() async {
    final response = await http
        .get(Uri.parse(baseURL + 'users/${context.read<UserId>().id}'));
    if (response.statusCode == 200) {
      var userData = jsonDecode(response.body);
      setState(() {
        authorName =
            userData['user']['name'] + ' ' + userData['user']['surname'];
        authorPdp = userData['user']['profilePicture'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  void _initializePlayer() {
    _betterPlayerDataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.network,
      baseURL + widget.post.mediaUrl,
    );
    _videoController = BetterPlayerController(
      BetterPlayerConfiguration(
        autoPlay: false,
        looping: true,
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );

    _videoController.addEventsListener((event) {
      print("BetterPlayer event: ${event.betterPlayerEventType}");
    });
  }

  @override
  void dispose() {
    if (isVideo) {
      _videoController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            extendBodyBehindAppBar: true,
            backgroundColor: Color(int.parse(
                widget.post.backgroundColor.replaceFirst("#", "0xff"))),
            body: Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 50, bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                          widget.post.domaines.isEmpty
                              ? "General"
                              : widget.post.domaines[0],
                          style: Theme.of(context).textTheme.titleLarge)),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              CachedNetworkImageProvider(baseURL + authorPdp),
                        ),
                        SizedBox(width: 10),
                        Text(authorName,
                            style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: Center(
                      child: Container(
                        width: double.infinity,
                        child: isVideo
                            ? VisibilityDetector(
                                key: Key(widget.post.mediaUrl),
                                onVisibilityChanged: (VisibilityInfo info) {
                                  if (info.visibleFraction > 0.5) {
                                    _videoController.play();
                                  } else {
                                    _videoController.pause();
                                  }
                                },
                                child: _videoController.videoPlayerController!
                                        .value.initialized
                                    ? AspectRatio(
                                        aspectRatio: _videoController
                                            .videoPlayerController!
                                            .value
                                            .aspectRatio,
                                        child: BetterPlayer(
                                            controller: _videoController))
                                    : Center(
                                        child: CircularProgressIndicator()),
                              )
                            : InteractiveViewer(
                                child: CachedNetworkImage(
                                  imageUrl: baseURL + widget.post.mediaUrl,
                                  filterQuality: FilterQuality.high,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Text(widget.post.title,
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(widget.post.description,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                        'Average Rating: ${widget.post.averageRating.toStringAsFixed(1)}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                        'Average Time Spent: ${widget.post.averageTimeSpent} seconds'),
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
                      onRatingUpdate: (rating) async {
                        // Example timespent value; replace with actual logic
                        int timespent = 120;
                        await _pc.submitRating(
                            context, widget.post.id, rating, timespent);

                        // Navigate to the next post
                        widget.controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 70),
                ],
              ),
            ),
          );
  }

  @override
  bool get wantKeepAlive => true;
}
