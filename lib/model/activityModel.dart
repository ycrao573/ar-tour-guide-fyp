// https://www.kindacode.com/article/how-to-read-local-json-files-in-flutter/

class ActivityModel {
  late int id;
  late String imageUrl;
  late String title;
  late String description;
  late dynamic longitude;
  late dynamic latitude;

  ActivityModel({
    required this.id,
    this.imageUrl = "",
    required this.title,
    required this.description,
    this.longitude = "",
    this.latitude = "",
  });

  ActivityModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
    title = json['title'];
    description = json['description'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_url'] = this.imageUrl;
    data['title'] = this.title;
    data['description'] = this.description;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
