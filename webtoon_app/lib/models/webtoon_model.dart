class WebtoonModel {
  final String title;
  final String thumbnail;
  final String id;

  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumbnail = json['thumb'],
        id = json['id'];
}
