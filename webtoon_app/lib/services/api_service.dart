import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:webtoon_app/models/webtoon_detail_model.dart';
import 'package:webtoon_app/models/webtoon_episode_model.dart';
import 'package:webtoon_app/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      'https://webtoon-crawler.nomadcoders.workers.dev';

  static const String today = "today";
  static const String episodes = "episodes";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoonList = jsonDecode(response.body);
      for (var webtoon in webtoonList) {
        webtoonInstances.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstances;
    }
    throw Error();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoonInfo = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoonInfo);
    }
    throw Error();
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> webtoonEpisodes = [];
    final url = Uri.parse('$baseUrl/$id/$episodes');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> webtoonEpisodeList = jsonDecode(response.body);
      for (var webtoonEpisode in webtoonEpisodeList) {
        webtoonEpisodes.add(WebtoonEpisodeModel.fromJson(webtoonEpisode));
      }
      return webtoonEpisodes;
    }
    throw Error();
  }
}
