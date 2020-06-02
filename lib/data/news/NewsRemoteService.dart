import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:news/data/URL.dart';
import 'package:news/data/news/News.dart';
import 'package:news/data/settings/SettingRepository.dart';
import 'package:news/event/Eventbus.dart';
import 'package:news/event/events.dart';

class NewsRemoteService {
  final _eventBust = EventBusProvider.defaultInstance();

  Future<List<News>> fetchNews(
    String apiToken,
    String type,
    String categoryId,
  ) async {
    var url = URL.addQuery(URL.news, {
      'api_token': apiToken,
      'type': type,
      'category_id': categoryId,
    });
    final response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    print("response:========="+response.body);
    if (response.statusCode == 200) {
      return News.listFromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      SettingRepository.create().saveApiToken('');
      _eventBust.fire(AuthErrorEvent());
      throw Exception('Auth Error');
    } else {
      throw Exception('Failed to load post'+e.toString());
    }
  }
}
