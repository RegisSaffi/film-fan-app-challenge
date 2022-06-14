import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:film_fan/models/movie.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MoviesProvider extends ChangeNotifier{

  bool isLoading=false;
  List<Movie> movies=[];
  late String message;

  getMovies(String a) async {
    var dio=Dio();
    isLoading=true;

    try{
      var url="${Constants.API_BASE_URL}movie/$a?api_key=${Constants.TMDB_API_KEY}&language=en-US&page=1";
      var res= await dio.get(url,options: Options(responseType: ResponseType.json));

      movies.clear();

      List results=res.data['results'];
      results.forEach((element) {
        movies.add(Movie.fromJson(element));
      });

      isLoading=false;
      message='success';

      notifyListeners();

    }on DioError catch(error){
      print(error.message);
      message="${error.message}";
      isLoading=false;
      notifyListeners();
    }
  }

}
