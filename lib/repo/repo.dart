import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:smartphone_news_app/models/score.dart';

class NewsRepository {

    Future<CategoriesNewsModel> fetchNewsCategoires(String category) async {
        String newsUrl =
            'https://newsapi.org/v2/everything?q=$category&sources=techcrunch&sortBy=publishedAt&apiKey=824ed89ad4794b96a31b6233d1e1d389';
        print(newsUrl);
        final response = await http.get(Uri.parse(newsUrl));
        if (response.statusCode == 200) {
            final body = jsonDecode(response.body);
            return CategoriesNewsModel.fromJson(body);
        } else {
            throw Exception('Error');
        }
    }

}
