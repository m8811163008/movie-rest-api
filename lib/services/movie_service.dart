import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_rest_api/services/http_service.dart';

import '../models/movie.dart';

class MovieService {
  final GetIt getIt = GetIt.instance;
  late final HTTPService _http;
  MovieService() {
    _http = getIt.get<HTTPService>();
  }

  Future<List<Movie>> getPopularMovies({required int page}) async {
    //we are going to get Response
    Response _response =
        await _http.request('/movie/popular', query: {'page': page});
    if (_response.statusCode == 200) {
      Map<String?, dynamic> _data = _response.data;
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t get the popular movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies({required int page}) async {
    //we are going to get Response
    Response _response =
        await _http.request('/movie/upcoming', query: {'page': page});
    if (_response.statusCode == 200) {
      Map<String, dynamic> _data = jsonDecode(_response.data);
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t get the upcoming movies');
    }
  }

  Future<List<Movie>> getSearchMovies(String _searchTerm,
      {required int page}) async {
    //we are going to get Response
    Response _response = await _http.request('/search/movie', query: {
      'query': _searchTerm,
      'page': page,
    });
    if (_response.statusCode == 200) {
      Map<String?, dynamic> _data = jsonDecode(_response.data);
      List<Movie> _movies = _data['results'].map<Movie>((_movieData) {
        return Movie.fromJson(_movieData);
      }).toList();
      return _movies;
    } else {
      throw Exception('Couldn\'t perform movie search');
    }
  }
}
