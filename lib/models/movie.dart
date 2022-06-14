import 'package:flutter/material.dart';

class Movie{

  String title;
  String originalTitle;
  String backdropPath;
  int id;
  num popularity;
  String posterPath;
  num voteAverage;
  num voteCount;
  String releaseDate;
  String overview;

  Movie({
      required this.title,
      required this.originalTitle,
      required this.backdropPath,
      required this.id,
      required this.popularity,
      required this.posterPath,
      required this.voteAverage,
      required this.voteCount,
      required this.releaseDate,
      required this.overview});


  factory Movie.fromJson(Map<String,dynamic> json)=> Movie(
      id:json['id'],
      title:json['title'],
    originalTitle:json['original_title'],
    backdropPath:json['backdrop_path'],
    popularity:json['popularity'],
    posterPath:json['poster_path'],
    voteAverage:json['vote_average'],
    voteCount:json['vote_count'],
    releaseDate:json['release_date'],
    overview:json['overview']
  );

}

