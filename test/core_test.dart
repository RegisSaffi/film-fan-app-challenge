import 'package:film_fan/models/character.dart';
import 'package:film_fan/models/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing all the models", () {
    test("Testing Movie() item", () {
      Movie movie = Movie(
          title: "Movie title",
          originalTitle: "original",
          id: 110,
          popularity: 100,
          posterPath:
              "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
          voteAverage: 344,
          voteCount: 33,
          releaseDate: "2020/01/01",
          overview: "Overview");

      expect(movie.backdropPath, null);
      expect(movie.id, isNotNull);
    });

    test("Testing Character() item", () {
      var testJson = {
        "name": "Actual name",
        "character": "Character name",
        "id": 12,
        "profile_path":
            "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png",
      };

      Character c = Character.fromJson(testJson);

      expect(c.name, isNotNull);
      expect(c.name, testJson['name']);
      expect(c.id.runtimeType, int);
    });
  });
}
