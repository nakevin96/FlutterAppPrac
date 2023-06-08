import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String baseUrl = dotenv.env['WEBTOON_BASE_URL']!;

  final String today = "today";

  void getTodaysToons() {}
}
