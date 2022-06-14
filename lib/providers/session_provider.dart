import 'package:dio/dio.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SessionProvider extends ChangeNotifier{

  bool isLoading=false;
  late String sessionId;
  late String message;

  getSessionId(){
    return sessionId;
  }

  getSession() async {
    var dio=Dio();

    try{
      var res= await dio.get("${Constants.API_BASE_URL}authentication/guest_session/new?api_key=${Constants.TMDB_API_KEY}&language=en-US",options: Options(responseType: ResponseType.json));

      sessionId=res.data['guest_session_id'];
      notifyListeners();

    }on DioError catch(error){
      print(error.message);
      message=error.message;
      notifyListeners();

    }

  }

}
