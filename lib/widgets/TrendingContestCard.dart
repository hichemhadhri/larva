import 'package:flutter/material.dart';
import 'package:larva/models/contest.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:larva/constants/constants.dart';
import 'package:larva/models/user.dart';
import 'package:larva/screens/Contest_details_screen.dart';

class TrendingContestCard extends StatelessWidget {
  final Contest contest;

  const TrendingContestCard({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _deadline =
        DateTime.parse(contest.endDate).difference(DateTime.now());
    final _textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContestDetails(
                      contest: Contest.createDummyContest(),
                    )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            if (contest.mediaUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                child: CachedNetworkImage(
                  imageUrl: baseURL + contest.mediaUrl,
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contest.name.replaceAll(" ", "_"),
                      style: _textTheme.headlineSmall!.copyWith(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Golden age",
                      style: _textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "4.9 (160 ratings)",
                          style: _textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
