import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/data/URL.dart';
import 'package:news/data/category/Category.dart';
import 'package:news/data/settings/SettingRepository.dart';
import 'package:news/event/Eventbus.dart';
import 'package:news/event/events.dart';

class CategoryRemoteService {
  final _eventBust = EventBusProvider.defaultInstance();

  Future<List<Category>> fetchCategory(String apiToken) async {
    var url = URL.addQuery(URL.category, {
      'api_token': apiToken,
    });
    final response =
        await http.get(url, headers: {'Accept': 'application/json'});
print("Response================"+response.body);
    if (response.statusCode == 200) {
      return Category.listFromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      SettingRepository.create().saveApiToken('');
      _eventBust.fire(AuthErrorEvent());
      throw Exception('Auth Error');
    } else {
      throw Exception('Failed to load post');
    }
  }
}
