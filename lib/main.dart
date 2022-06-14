import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/providers/movies_provider.dart';
import 'package:film_fan/providers/session_provider.dart';
import 'package:film_fan/providers/similar_movies_provider.dart';
import 'package:film_fan/views/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/cast_provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_)=>SessionProvider()),
    ChangeNotifierProvider(create: (_)=>MoviesProvider()),
    ChangeNotifierProvider(create: (_)=>SimilarMoviesProvider()),
    ChangeNotifierProvider(create: (_)=>CastProvider()),
    ChangeNotifierProvider(create: (_)=>FavoritesProvider()),
  ],child: MyApp(),));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Fan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(
      ),
    );
  }
}


