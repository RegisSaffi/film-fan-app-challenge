import 'package:film_fan/models/movie.dart';
import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    FavoritesProvider favoritesProvider=Provider.of<FavoritesProvider>(context);

    return SizedBox.expand(
      child:favoritesProvider.movies.length==0?Center(child: Text("Your favorites list is empty",style: TextStyle(color: Colors.grey),)): GridView.builder(
          padding: EdgeInsets.all(5),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              mainAxisExtent: 320, maxCrossAxisExtent: 250,mainAxisSpacing: 10,crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            return MovieItem(movie: favoritesProvider.movies[index],favoritesProvider: favoritesProvider,);

          },itemCount: favoritesProvider.movies.length,),
    );
  }


}