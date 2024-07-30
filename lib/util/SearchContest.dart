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
    return [
      IconButton(
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(color: Colors.black),
      inputDecorationTheme: Theme.of(context).inputDecorationTheme,
      hintColor: Color(0xFFC1C1C1),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.black,
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.black,
        onBackground: Colors.white,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? enrolledContexts
        : allContexts.where((contest) {
            final contestLower = contest.toLowerCase();
            final queryLower = query.replaceAll(" ", "_").toLowerCase();

            return contestLower.startsWith(queryLower);
          }).toList();

    return buildSuggestionsSuccess(context, suggestions);
  }

  Widget buildSuggestionsSuccess(
          BuildContext context, List<String> suggestions) =>
      Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
              title: RichText(
                text: TextSpan(
                  text: queryText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  children: [
                    TextSpan(
                      text: remainingText,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
