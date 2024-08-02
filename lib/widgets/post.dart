import 'dart:async';
import 'dart:math';
import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/user.dart';
import 'package:preload_page_view/preload_page_view.dart';
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
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  BetterPlayerController? _videoController;
  late BetterPlayerDataSource _betterPlayerDataSource;
  bool isVideo = false;
  bool isLoading = true;
  bool isDescriptionExpanded = false;
  bool isOverlayVisible = true;
  late User user;
  late String contestImageUrl = "";
  late String remainingTime = "";
  final PostController _pc = PostController();
  final ContestController _cc = ContestController();
  final UserController _uc = UserController();
  late AnimationController _rotationController;
  Timer? _timer;
  late Contest? _contest;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    _fetchUserInfo();
    _fetchContestInfo();
    isVideo = widget.post.mediaUrl.endsWith('.mp4') ||
        widget.post.mediaUrl.endsWith('.m3u8');
    if (isVideo) {
      _initializePlayer();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (_contest != null) {
          remainingTime =
              _calculateRemainingTime(DateTime.parse(_contest!.endDate));
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoController?.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserInfo() async {
    try {
      user = await _uc.getUserDetails(widget.post.author);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> _fetchContestInfo() async {
    if (widget.post.contests.isNotEmpty) {
      final contestId = widget.post.contests[0]; // Assuming the first contest
      _cc.getContest(null, contestId).then((contest) {
        setState(() {
          contestImageUrl = contest!.mediaUrl;
          _contest = contest;
          remainingTime =
              _calculateRemainingTime(DateTime.parse(contest.endDate));
        });
      });
    } else
      setState(() {
        remainingTime = "Ended";
        _contest = null;
      });
  }

  String _calculateRemainingTime(DateTime end) {
    final now = DateTime.now();
    final difference = end.difference(now);
    if (difference.isNegative) return "Ended";

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
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
        aspectRatio: 9 / 18,
        fit: BoxFit.cover,
        eventListener: _onVideoEvent,
        controlsConfiguration: BetterPlayerControlsConfiguration(
          showControls: false,
        ),
      ),
      betterPlayerDataSource: _betterPlayerDataSource,
    );
  }

  void _onVideoEvent(BetterPlayerEvent event) {
    if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
      setState(() {
        // Video is ready, rebuild to display it
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController?.isPlaying() ?? false) {
      _videoController?.pause();
    } else {
      _videoController?.play();
    }
  }

  void _handleLongPress(bool isPressed) {
    setState(() {
      isOverlayVisible = !isPressed;
    });
    if (isPressed) {
      _videoController?.pause();
    } else {
      _videoController?.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
            body: Stack(
              children: [
                Positioned.fill(
                  child: isVideo
                      ? VisibilityDetector(
                          key: Key(widget.post.mediaUrl),
                          onVisibilityChanged: (VisibilityInfo info) {
                            if (_videoController != null) {
                              if (info.visibleFraction > 0.5) {
                                _videoController?.play();
                              } else {
                                _videoController?.pause();
                              }
                            }
                          },
                          child: GestureDetector(
                            onLongPressStart: (_) {
                              _handleLongPress(true);
                            },
                            onLongPressEnd: (_) {
                              _handleLongPress(false);
                            },
                            child: BetterPlayer(
                              controller: _videoController!,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onLongPressStart: (_) {
                            _handleLongPress(true);
                          },
                          onLongPressEnd: (_) {
                            _handleLongPress(false);
                          },
                          child: CachedNetworkImage(
                            imageUrl: baseURL + widget.post.mediaUrl,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                ),
                Positioned(
                  top: height * 0.05,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      widget.post.domaines.isEmpty
                          ? "General"
                          : widget.post.domaines[0],
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(width * 0.02),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.transparent,
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        if (isOverlayVisible)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: width * 0.05,
                                backgroundImage:
                                    NetworkImage(baseURL + user.profilePicture),
                              ),
                              SizedBox(width: width * 0.03),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${user.name.toLowerCase()} ${user.surname}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        '•',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      GestureDetector(
                                        onTap: () {
                                          // Add follow logic here
                                        },
                                        child: Text(
                                          'Follow',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontSize: width * 0.03,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.005),
                                  Row(
                                    children: [
                                      Text(
                                        widget.post.title,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        '•',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontSize: width * 0.03,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Text(
                                        widget.post.createdAt.substring(0, 10),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: width * 0.03,
                                            ),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Row(
                                        children: [
                                          Icon(Icons.star,
                                              color: Colors.yellow,
                                              size: width * 0.035),
                                          SizedBox(width: width * 0.005),
                                          Text(
                                            '${widget.post.ratings.length}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontSize: width * 0.03),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Row(
                                        children: [
                                          Icon(Icons.favorite,
                                              color: Colors.red,
                                              size: width * 0.035),
                                          SizedBox(width: width * 0.005),
                                          Text(
                                            '${widget.post.fans.length}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontSize: width * 0.03),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (widget.post.contests.length > 0)
                                    AnimatedBuilder(
                                      animation: _rotationController,
                                      builder: (context, child) {
                                        return Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: width * 0.05,
                                              backgroundImage: NetworkImage(
                                                  baseURL + contestImageUrl),
                                              backgroundColor: Colors.white,
                                              foregroundColor: Colors.white,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.white,
                                                    width: width * 0.005,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black
                                                      .withOpacity(0.3),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '${_contest!.posts.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    remainingTime,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 241, 163, 78),
                                            fontSize: width * 0.03),
                                  ),
                                  if (widget.post.contests.length > 0)
                                    Text(
                                        '#' +
                                            _contest!.name.replaceAll(" ", "_"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              color: Colors.white,
                                              fontSize: width * 0.03,
                                            )),
                                  SizedBox(height: height * 0.01),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        iconSize: width * 0.06,
                                        icon: Icon(Icons.bookmark_border,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Handle the button press
                                        },
                                      ),
                                      IconButton(
                                        iconSize: width * 0.06,
                                        icon: Icon(Icons.more_horiz,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Handle the button press
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        SizedBox(height: height * 0.01),
                        if (isOverlayVisible)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isDescriptionExpanded = !isDescriptionExpanded;
                              });
                            },
                            child: Text(
                              widget.post.description,
                              maxLines: isDescriptionExpanded ? null : 1,
                              overflow: isDescriptionExpanded
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      color: Colors.white70,
                                      fontSize: width * 0.03),
                            ),
                          ),
                        SizedBox(height: height * 0.01),
                        if (isOverlayVisible)
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  unratedColor: Colors.amber[100],
                                  itemPadding: EdgeInsets.all(width * 0.01),
                                  itemSize: width * 0.08,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) async {
                                    int timespent =
                                        120; // Example timespent value
                                    await _pc.submitRating(context,
                                        widget.post.id, rating, timespent);

                                    // Navigate to the next post
                                    widget.controller.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }

  @override
  bool get wantKeepAlive => false;
}
