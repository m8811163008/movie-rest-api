import 'package:movie_rest_api/models/movie.dart';
import 'package:movie_rest_api/models/search_category.dart';

class MainPageData {
  //maintain a list of movie to show in UI
  final List<Movie> movies;
  //helping pagination , a way of api give us data in chunks
  final int page;
  //String to keep search category and search text
  final String searchCategory;
  final String searchText;

  MainPageData(
      {this.movies = const [],
      this.page = 1,
      this.searchCategory = SearchCategory.popular,
      this.searchText = ''});

  //crete helper function copy with to keep the state of application and add new variable to class
  MainPageData copyWith(
      {List<Movie>? movies,
      int? page,
      String? searchCategory,
      String? searchText}) {
    return MainPageData(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      searchCategory: searchCategory ?? this.searchCategory,
      searchText: searchText ?? this.searchText,
    );
  }
}
