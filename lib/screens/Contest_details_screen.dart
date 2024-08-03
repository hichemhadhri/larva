import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/models/post.dart';
import 'package:larva/screens/new_post_screen.dart';

class ContestDetails extends StatefulWidget {
  final String name;
  final String img;
  final String prize;
  final int deadline;
  final String contestId;

  const ContestDetails({
    Key? key,
    required this.contestId,
    required this.name,
    required this.prize,
    required this.img,
    required this.deadline,
  }) : super(key: key);

  @override
  _ContestDetailsState createState() => _ContestDetailsState();
}

class _ContestDetailsState extends State<ContestDetails> {
  Duration deadline = Duration();
  Timer? timer;
  List<Post> bestPosts = [];
  bool isLoading = true;
  final ContestController _contestController = ContestController();

  void countDown() {
    setState(() {
      deadline = Duration(seconds: deadline.inSeconds - 1);
    });
  }

  @override
  void initState() {
    super.initState();
    deadline = Duration(seconds: widget.deadline);
    timer = Timer.periodic(Duration(seconds: 1), (_) => countDown());
    _fetchBestPosts();
  }

  Future<void> _fetchBestPosts() async {
    List<Post> posts =
        await _contestController.getTop10Posts(context, widget.contestId);
    setState(() {
      bestPosts = posts;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Add(
                    fromContest: true,
                    contestId: widget.contestId,
                    contestName: widget.name,
                  ),
                ),
              );
            },
            child: Text(
              "Join",
              style: textTheme.titleLarge!.copyWith(
                color: Colors.amber,
              ),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.img.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: baseURL + widget.img,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    style: textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  icon: Icon(
                    Icons.add,
                    color: Colors.amber,
                  ),
                  label: Text(
                    "Follow",
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Prize: ${widget.prize}",
                      style: textTheme.titleSmall!.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Time Left:",
                      style: textTheme.titleSmall,
                    ),
                    Text(
                      "${deadline.inDays}d ${deadline.inHours % 24}h ${deadline.inMinutes % 60}m ${deadline.inSeconds % 60}s",
                      style: textTheme.headlineSmall!.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SvgPicture.asset(
                  "lib/assets/images/butterfly.svg",
                  height: 40,
                  color: Colors.amber,
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: Text("See posts"),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Best Posts",
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.amber))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: bestPosts.length,
                    itemBuilder: (context, index) {
                      final post = bestPosts[index];
                      return ListTile(
                        title: Text(post.title),
                        subtitle: Text(
                          "Rating: ${post.averageRating.toStringAsFixed(1)}",
                        ),
                        leading: CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(post.thumbnail),
                        ),
                        trailing: Text("by ${post.author}"),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
