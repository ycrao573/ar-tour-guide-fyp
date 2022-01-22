import 'package:html/parser.dart';
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

  Poi(this.id, this.longitude, this.latitude, this.description, this.altitude,
      this.name, this.category);

  factory Poi.fromJson(Map<String, dynamic> json) => _$PoiFromJson(json);

  Map<String, dynamic> toJson() => _$PoiToJson(this);
}

class LandmarkPoi {
  int id;
  double longitude;
  double latitude;
  String description;
  double altitude;
  String name;
  String category;
  String hyperlink;
  String photourl;
  String openingHours;
  String postalcode;
  String urlpath;
  String address;
  String imageText;
  String field1;

  LandmarkPoi(
      this.id,
      this.longitude,
      this.latitude,
      this.description,
      this.altitude,
      this.name,
      this.category,
      this.hyperlink,
      this.photourl,
      this.openingHours,
      this.postalcode,
      this.urlpath,
      this.address,
      this.imageText,
      this.field1);

  factory LandmarkPoi.fromJson(Map<String, dynamic> json) =>
      _$LandmarkPoiFromJson(json);

  Map<String, dynamic> toJson() => _$LandmarkPoiToJson(this);
}
