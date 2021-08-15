import 'package:flutter/material.dart';

class SearchContest extends SearchDelegate<String> {
  SearchContest();
  final enrolledContexts = [
    "Chalba9_l'emission",
    "Paint_your_way",
    "Celebrate_your_talent",
  ];

  final allContexts = [
    "Chalba9_l'emission",
    "Paint_your_way",
    "Celebrate_your_talent",
    "Khoudou_iini_choufou_biha",
    "Bourguiba_got_talent",
    "ICTC",
    "test_contest",
    "rap_tunisien",
    "best_shots",
    "color_palette",
    "winek_wakt_elbard_kleni",
    "ija_ya_hama"
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(onPressed: () {}, icon: Icon(Icons.clear))];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back));
  }

  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(color: Colors.black),
      backgroundColor: Colors.black,
      inputDecorationTheme: Theme.of(context).inputDecorationTheme,
      hintColor: Color(0xFFC1C1C1),
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? enrolledContexts
        : allContexts.where((contest) {
            final contestLower = contest.toLowerCase();
            final queryLower = query..replaceAll(" ", "_").toLowerCase();

            return contestLower.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(context, suggestions);
  }

  Widget buildSuggestionsSuccess(
          BuildContext context, List<String> suggestions) =>
      Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = suggestions[index];
            final queryText = suggestion.substring(0, query.length);
            final remainingText = suggestion.substring(query.length);

            return ListTile(
              onTap: () {
                query = suggestion;

                close(context, query);
              },
              leading: Icon(
                Icons.star,
                color: Colors.white,
              ),
              // title: Text(suggestion),
              title: RichText(
                text: TextSpan(
                  text: queryText,
                  style: Theme.of(context).textTheme.headline6,
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
