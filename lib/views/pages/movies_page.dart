import 'package:film_fan/models/movie.dart';
import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/providers/movies_provider.dart';
import 'package:film_fan/providers/session_provider.dart';
import 'package:film_fan/views/widgets/movie_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MoviesPage extends StatefulWidget {


  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  var filters=[
    "Now playing",
    "Popular",
    "Upcoming",
    "Top rated"
  ];

  var selectedFilter="Now playing";

  @override
  void initState() {

    var _sessionProvider = Provider.of<SessionProvider>(context,listen: false);
    _sessionProvider.getSession();

    var _moviesProvider = Provider.of<MoviesProvider>(context,listen: false);
    _moviesProvider.getMovies("now_playing");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MoviesProvider moviesProvider=Provider.of<MoviesProvider>(context);
    FavoritesProvider favoritesProvider=Provider.of<FavoritesProvider>(context);

    return SizedBox.expand(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:filters.map((e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterChip(label: Text("$e"),selected: selectedFilter==e,onSelected: (s){
                  setState(() {
                    selectedFilter=e;
                  });
                  moviesProvider.getMovies("$e".toLowerCase().replaceAll(" ", "_"));
                },),
              )).toList(),
            ),
          ),
          Flexible(
            child:moviesProvider.isLoading?Center(child: CircularProgressIndicator.adaptive()):!moviesProvider.isLoading&&moviesProvider.movies.length!=0? GridView.builder(
              padding: EdgeInsets.all(5),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 320,
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 7,
                    crossAxisSpacing: 0),
                itemBuilder: (context, index) {
                  return MovieItem(movie: moviesProvider.movies[index],favoritesProvider: favoritesProvider,);
                },itemCount: moviesProvider.movies.length,):Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text("Error loading movies, try again later")),
            ),
          ),
        ],
      ),
    );
  }
}
