import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/controllers/contestController.dart';
import 'package:larva/controllers/postController.dart';
import 'package:larva/controllers/userController.dart';
import 'package:larva/models/contest.dart';
import 'package:larva/models/post.dart';
import 'package:larva/models/user.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Profile extends StatefulWidget {
  final String userId;

  const Profile({Key? key, required this.userId}) : super(key: key);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserController _userController = UserController();
  ContestController _contestController = ContestController();
  PostController _postController = PostController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //_loadUserDetails();
    // _loadUserPosts();
    // _loadUserFavorites();
  }

  Future<User> _loadUserDetails() async {
    final user = await _userController.getUserDetails(widget.userId);

    return user;
  }

  Future<List<Post>> _loadUserPosts() async {
    final posts = await _userController.getUserPosts(widget.userId);

    return posts;
  }

  Future<List<Post>> _loadUserFavorites() async {
    final favorites = await _userController.getUserFavoritePosts(widget.userId);

    return favorites;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              Container(
                height: 300,
                child: Column(
                  children: [
                    TabBar(
                      indicatorColor: Colors.greenAccent,
                      labelColor: Colors.greenAccent,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Posts'),
                        Tab(text: 'Favorites'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildPostListView(),
                          _buildFavoritesListView()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return FutureBuilder(
      future: _loadUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final User user = snapshot.data as User;
          return Column(
            children: [
              _buildHeaderContent(user),
              SizedBox(height: 20),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.name + '_' + user.surname,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  _buildFollowersFollowingRow(user),
                  _buildBadgesRow(),
                ],
              ),
              SizedBox(height: 20),
              _buildUserStats(user),
            ],
          );
        }
      },
    );
  }

  Widget _buildHeaderContent(User user) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.greenAccent, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Color.fromARGB(255, 31, 39, 31),
                    child: CircleAvatar(
                      radius: 69,
                      backgroundImage:
                          NetworkImage(baseURL + user.profilePicture),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.person_add),
                  label: Text('Follow'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.greenAccent,
                    backgroundColor: Colors.grey[900],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildProfileStat(
                    'Hearts', user.stats['hearts'].toString(), Icons.favorite),
                _buildProfileStat('Average Rating',
                    user.stats['averageRating'].toString(), Icons.star),
                _buildProfileStat('Contests Won',
                    user.stats['contestsWon'].toString(), Icons.emoji_events),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        SizedBox(height: 5),
        Text(
          count,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFollowersFollowingRow(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildFollowersFollowingColumn('Followers',
              user.followers.length.toString(), MdiIcons.accountMultiple),
          SizedBox(width: 5),
          _buildFollowersFollowingColumn('Following',
              user.following.length.toString(), MdiIcons.accountPlus),
        ],
      ),
    );
  }

  Widget _buildFollowersFollowingColumn(
      String label, String count, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: Colors.grey),
        Text(
          count,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgesRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBadge('Creator', Colors.green[800]!, MdiIcons.star),
          SizedBox(width: 10),
          // Additional badges can be added here in the future
          // Example: _buildBadge('Verified', Colors.green[700]!, MdiIcons.checkCircle),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildUserStats(User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUserStatCard(
                icon: MdiIcons.trophy,
                label: 'Top 1%',
                value: '${user.stats['top1pct']} times',
                gradientColors: [Colors.green[700]!, Colors.green[500]!],
              ),
              _buildUserStatCard(
                icon: MdiIcons.music,
                label: 'Interests',
                value: 'Music, Dance, Video Games',
                gradientColors: [Colors.blue[700]!, Colors.blue[500]!],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUserStatCard(
                icon: MdiIcons.thumbUp,
                label: 'Rater Quality',
                value: 'Good Rater',
                gradientColors: [Colors.amber[700]!, Colors.amber[500]!],
              ),
              _buildUserStatCard(
                icon: MdiIcons.vote,
                label: 'Voting Similarity',
                value: '85%',
                gradientColors: [Colors.purple[700]!, Colors.purple[500]!],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserStatCard({
    required IconData icon,
    required String label,
    required String value,
    required List<Color> gradientColors,
  }) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostListView() {
    return FutureBuilder(
      future: _loadUserPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final userPosts = snapshot.data as List<Post>;
          return _buildPostList(userPosts);
        }
      },
    );
  }

  Widget _buildFavoritesListView() {
    return FutureBuilder(
      future: _loadUserFavorites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final userPosts = snapshot.data as List<Post>;
          return _buildPostList(userPosts);
        }
      },
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return _buildPostTile(
          imageUrl: post.mediaType == 'image' ? post.mediaUrl : post.thumbnail,
          title: post.title,
          contestName:
              post.contests.isNotEmpty ? post.contests[0].name : 'No Contest',
          finalRank: post.finalRank,
          averageRating: post.averageRating,
          hearts: post.fans.length,
        );
      },
    );
  }

  Widget _buildPostTile({
    required String imageUrl,
    required String title,
    required String contestName,
    required int finalRank,
    required double averageRating,
    required int hearts,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black, // Matching the background color for consistency
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: Colors.greenAccent, // Accent color for the border
          width: 1,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              baseURL + imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  contestName,
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 12),
                  SizedBox(width: 5),
                  Text(
                    '$averageRating',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  SizedBox(width: 10),
                  Icon(MdiIcons.heart, color: Colors.red, size: 12),
                  SizedBox(width: 5),
                  Text(
                    '$hearts',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Icons.leaderboard,
                    color: Colors.amber,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Top 25%',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.greenAccent),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
