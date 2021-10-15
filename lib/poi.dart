import 'package:json_annotation/json_annotation.dart';

part 'poi.g.dart';

@JsonSerializable()
class Poi {
  int id;
  double longitude;
  double latitude;
  String description;
  double altitude;
  String name;
  String category;
  List<String> reviews;
  String imageUrl;

  Poi(this.id, this.longitude, this.latitude, this.description, this.altitude,
      this.name, this.category, this.reviews, this.imageUrl);

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);

  Map<String, dynamic> toJson() => _$PoiToJson(this);
}
