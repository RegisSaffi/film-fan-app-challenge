import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:film_fan/models/movie.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier{

  bool isLoading=false;
  List<Movie> movies=[];
  late String message;

  addToFavorites(Movie movie) async {
    movies.add(movie);
    notifyListeners();
  }

  removeFromFavorites(Movie movie){
    movies.removeWhere((element) => element.id==movie.id);
    notifyListeners();
  }

}
