import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_rest_api/models/app_config.dart';

class HTTPService {
  final Dio dio = Dio();
  final GetIt getIt = GetIt.instance;
  late final String _baseUrl;
  late final String _apiKey;
  HTTPService() {
    AppConfig _config = getIt.get<AppConfig>();
    _baseUrl = _config.baseApiUrl;
    _apiKey = _config.apiKey;
  }

  Future<Response> request(String path, {Map<String, dynamic>? query}) async {
    try {
      String _url = '$_baseUrl$path';
      Map<String, dynamic> _query = {'api_key': _apiKey, 'language': 'en-US'};
      if (query != null) _query.addAll(query);
      return await dio.get(_url, queryParameters: _query);
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Something goes wrong!');
    }
  }
}
