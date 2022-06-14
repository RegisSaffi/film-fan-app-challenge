import 'package:dio/dio.dart';
import 'package:film_fan/models/movie.dart';
import 'package:film_fan/providers/cast_provider.dart';
import 'package:film_fan/providers/favorites_provider.dart';
import 'package:film_fan/providers/session_provider.dart';
import 'package:film_fan/providers/similar_movies_provider.dart';
import 'package:film_fan/utils/constants.dart';
import 'package:film_fan/views/widgets/movie_item.dart';
import 'package:film_fan/views/widgets/rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatefulWidget {
  final Movie movie;

  const DetailsScreen({required this.movie});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var rating;

  late SessionProvider _sessionProvider;

  @override
  void initState() {
    _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    var _similarMoviesProvider =
        Provider.of<SimilarMoviesProvider>(context, listen: false);
    _similarMoviesProvider.getMovies(widget.movie.id);

    var _castProvider = Provider.of<CastProvider>(context, listen: false);
    _castProvider.getCast(widget.movie.id);
    super.initState();
  }

  showLoading(msg) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () {
              return Future<bool>(() => false);
            },
            child: AlertDialog(
              content: Row(
                children: [
                  CircularProgressIndicator.adaptive(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$msg",
                    softWrap: true,
                  ),
                ],
              ),
            ),
          );
        });
  }

  ////////////
  vote() async {
    try {
      var dio = Dio();

      showLoading("Submitting vote...");

      var params = {
        "value": rating,
      };

      var res = await dio.post(
          "${Constants.API_BASE_URL}movie/${widget.movie.id}/rating?api_key=${Constants.TMDB_API_KEY}&guest_session_id=${_sessionProvider.sessionId}&language=en-US",
          data: params,
          options: Options(responseType: ResponseType.json));

      Navigator.of(context).pop();

      var code = res.data["status_code"];
      String msg = res.data["status_message"];

      if (code == 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Your vote for this movie submitted successfully")));

      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "You already voted for this movie, try again after some time")));
      }

    } on DioError catch (e) {
      Navigator.of(context).pop();

      if (e.response?.statusCode == 401) {
        _sessionProvider.getSession();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Your session expired, but you can try again now")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Unable to submit your vote, try again later")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SimilarMoviesProvider _similarMoviesProvider =
        Provider.of<SimilarMoviesProvider>(context);
    CastProvider _castProvider = Provider.of<CastProvider>(context);
    FavoritesProvider favoritesProvider =
        Provider.of<FavoritesProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text("${widget.movie.title}"),
            pinned: true,
            expandedHeight: 430,
            actions: [
              IconButton(
                  color: Colors.amber,
                  icon: favoritesProvider.movies.contains(widget.movie)
                      ? Icon(
                          Icons.favorite_border,
                        )
                      : Icon(Icons.favorite),
                  onPressed: () {
                    if (favoritesProvider.movies.contains(widget.movie)) {
                      favoritesProvider.addToFavorites(widget.movie);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Added to favorites")));
                    } else {
                      favoritesProvider.removeFromFavorites(widget.movie);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Removed")));
                    }
                  })
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  Column(
                    children: [
                      Container(
                        height: 410,
                        width: MediaQuery.of(context).size.width,
                        child: Image.network(
                          "${Constants.IMAGE_BASE_URL}${widget.movie.backdropPath}",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Container(
                                    height: 120,
                                    width: 83,
                                    child: Image.network(
                                      "${Constants.IMAGE_BASE_URL}${widget.movie.posterPath}",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.movie.originalTitle}",
                                        overflow: TextOverflow.visible,
                                        style: TextStyle(fontSize: 22),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        "${widget.movie.releaseDate}",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0, bottom: 8.0),
                                        child: Row(
                                          children: [
                                            RatingBar(
                                              rating:
                                                  widget.movie.voteAverage / 2,
                                              small: true,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("${widget.movie.voteAverage}"),
                                            Icon(
                                              Icons.stars,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Text("${widget.movie.voteCount}"),
                                            Icon(
                                              Icons.group,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "About this movie",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "${widget.movie.overview}",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Cast",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child:_castProvider.isLoading?Center(child: CircularProgressIndicator.adaptive()):!_castProvider.isLoading&&_castProvider.cast.length!=0?  ListView.builder(
                itemBuilder: (context, i) => Container(
                  child: LimitedBox(
                    maxWidth: 140,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              "${Constants.IMAGE_BASE_URL}${_castProvider.cast[i].profilePath}",
                            ),
                          ),
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "${_castProvider.cast[i].name}",
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                          Flexible(
                              child: Text(
                            "${_castProvider.cast[i].character}",
                            overflow: TextOverflow.visible,
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ))
                        ],
                      ),
                    ),
                  ),
                ),
                scrollDirection: Axis.horizontal,
                itemCount: _castProvider.cast.length,
              ):Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Error loading movie cast, try again later")),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Rate this movie",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    "Tell others what you think about this movie",
                    overflow: TextOverflow.visible,
                    style: TextStyle(color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: RatingBar(
                      onRatingChanged: (d) {
                        setState(() {
                          rating = d*2;
                        });
                      },
                      rating: rating??0,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (rating == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Select star(s) first")));
                        } else {
                          vote();
                        }
                      },
                      child: Text("Rate movie"))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Similar movies",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _similarMoviesProvider.isLoading?Center(child: CircularProgressIndicator.adaptive()):!_similarMoviesProvider.isLoading&&_similarMoviesProvider.movies.length!=0?  GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.all(5),
                itemCount: _similarMoviesProvider.movies.length,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 320,
                    maxCrossAxisExtent: 250,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return MovieItem(
                    movie: _similarMoviesProvider.movies[index],
                    favoritesProvider: favoritesProvider,
                  );
                }):Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(_similarMoviesProvider.message=='success'?"No similar movies available":"Error loading similar movies, try again later")),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50,))
        ],
      ),
    );
  }
}
