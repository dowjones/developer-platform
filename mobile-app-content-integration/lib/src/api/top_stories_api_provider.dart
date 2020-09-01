
import 'package:flutter_news_app/src/model/topstories/topstories.dart';
import 'package:dio/dio.dart';

class TopStoriesApiProvider {
  
  final Dio _dio = Dio();
  final String _topStoriesUrl =
    'https://us-central1-dj-finance-recommendation.cloudfunctions.net/getTopNews';
  final FirstCollection = 0;

  // Top Stories from DJ
  Future<TopStories> getTopStories() async {
    try {
      final newResponse = await _dio.get(_topStoriesUrl);
      final id = newResponse.data[FirstCollection]['id']; // First collection for company news
      final article = await _dio.get('$_topStoriesUrl?id=$id');
      return TopStories.fromJson(article.data); // filter entities and other types
    } catch (error, stacktrace) {
      print('Exception occured: $error with stacktrace: $stacktrace');
      return null;
    }
  }
}
