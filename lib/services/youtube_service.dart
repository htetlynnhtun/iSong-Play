import 'package:dio/dio.dart';

class YoutubeService {
  final _dio = Dio();

  static final _singleton = YoutubeService._internal();
  YoutubeService._internal();
  factory YoutubeService() {
    return _singleton;
  }

  void dispose() {
    _dio.close();
  }

  Future<List<String>> getSuggestion(String query) async {
    const baseUrl = "https://suggestqueries.google.com/complete/search?client=firefox&ds=yt&q=";
    final endpoint = Uri.parse(baseUrl + query);
    final response = await _dio.getUri<String>(endpoint);
    final data = response.data!.split(",[")[1];
    final result = data.substring(0, data.length - 1).split(",").map((e) => e.substring(1, e.length - 1)).toList();

    return result;
  }
}
