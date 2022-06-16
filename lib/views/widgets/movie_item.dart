import 'package:film_fan/models/movie.dart';
import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:film_fan/views/screens/details.dart';
import 'package:flutter/material.dart';

class MovieItem extends StatelessWidget{
  final Movie movie;
  final FavoritesProvider favoritesProvider;

  MovieItem({required this.movie,required this.favoritesProvider});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(7),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (_)=>DetailsScreen(movie: movie,)));
      },
      child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            "${Constants.IMAGE_BASE_URL}${movie.posterPath}",
                            fit: BoxFit.cover,
                            frameBuilder: (context,child,frame,asy){
                              return frame==null?Image.asset("assets/images/placeholder.png",fit: BoxFit.cover,):child;
                            },
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(color: Colors.amber,icon: !favoritesProvider.movies.contains(movie)?Icon(Icons.favorite_border,):Icon(Icons.favorite), onPressed: (){

                              if(!favoritesProvider.movies.contains(movie)){
                              favoritesProvider.addToFavorites(movie);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to favorites")));
                              }else{

                                favoritesProvider.removeFromFavorites(movie);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Removed")));
                              }
                            }),
                          )
                        ],
                      ))),
              Padding(
                padding: const EdgeInsets.only(
                    top: 2, left: 8, right: 8, bottom: 3),
                child: Text(
                  "${movie.title}",
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 17),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                      child: Text(
                        "${movie.releaseDate}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 2),
                    child: Text("${movie.voteAverage}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8, right: 8),
                    child: Icon(
                      Icons.stars,
                      size: 15,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }


}