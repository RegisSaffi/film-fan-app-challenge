
import 'dart:io';

import 'package:film_fan/models/movie.dart';
import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:provider/provider.dart';

void main() {
   setUpAll(() => HttpOverrides.global = null);

  testWidgets('Testing MovieItem() widget', (WidgetTester tester) async {
    Movie movie = Movie(
        title: "Movie title",
        originalTitle: "original",
        id: 110,
        popularity: 100,
        posterPath:
            "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
        voteAverage: 9.9,
        voteCount: 33,
        releaseDate: "2020/01/01",
        overview: "Overview");

    await tester.pumpWidget(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => FavoritesProvider())],
      child: MaterialApp(
        home: Material(
          child: Builder(builder: (context) {
            FavoritesProvider favoritesProvider =
                Provider.of<FavoritesProvider>(context);
            return MovieItem(movie: movie, favoritesProvider: favoritesProvider);
          }),
        ),
      ),
    ));

    // Verify if there is a title text
    expect(find.text('Movie title'), findsOneWidget);
    //check if the vote average text found
    expect(find.text('9.9'), findsOneWidget);

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);

    // Tap the favorite icon
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();

    // Check if favorite icon updated
     expect(find.byIcon(Icons.favorite_border), findsNothing);
     expect(find.byIcon(Icons.favorite), findsOneWidget);

  });
}
