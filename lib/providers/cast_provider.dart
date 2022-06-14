import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:film_fan/models/character.dart';
import 'package:film_fan/models/movie.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class CastProvider extends ChangeNotifier{

  bool isLoading=false;
  List<Character> cast=[];
  late String message;

  getCast(id) async {
    var dio=Dio();
    isLoading=true;
    try{
      var url="${Constants.API_BASE_URL}movie/$id/credits?api_key=${Constants.TMDB_API_KEY}&language=en-US";
      var res= await dio.get(url,options: Options(responseType: ResponseType.json));

     cast.clear();

      List results=res.data['cast'];
      results.forEach((element) {
       cast.add(Character.fromJson(element));
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
