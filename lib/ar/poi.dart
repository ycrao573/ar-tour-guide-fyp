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
  String officiallink;
  String hyperlink;
  String urlpath;
  String photourl;
  String imagetext;
  String openinghours;
  String address;

  LandmarkPoi(
      this.id,
      this.longitude,
      this.latitude,
      this.description,
      this.altitude,
      this.name,
      this.category,
      this.officiallink,
      this.hyperlink,
      this.urlpath,
      this.photourl,
      this.imagetext,
      this.openinghours,
      this.address,
    );

  factory LandmarkPoi.fromJson(Map<String, dynamic> json) =>
      _$LandmarkPoiFromJson(json);

  Map<String, dynamic> toJson() => _$LandmarkPoiToJson(this);
}
