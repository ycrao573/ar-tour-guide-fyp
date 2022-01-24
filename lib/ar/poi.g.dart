// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Poi _$PoiFromJson(Map<String, dynamic> json) {
  return Poi(
    json['id'] as int,
    (json['longitude'] as num).toDouble(),
    (json['latitude'] as num).toDouble(),
    json['description'] as String,
    (json['altitude'] as num).toDouble(),
    json['name'] as String,
    json['category'] as String,
  );
}

Map<String, dynamic> _$PoiToJson(Poi instance) => <String, dynamic>{
      'id': instance.id,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'description': instance.description,
      'altitude': instance.altitude,
      'name': instance.name,
      'category': instance.category,
    };

LandmarkPoi _$LandmarkPoiFromJson(Map<String, dynamic> json) {
  return LandmarkPoi(
    json['id'] as int,
    (json['longitude'] as num).toDouble(),
    (json['latitude'] as num).toDouble(),
    json['description'] as String,
    (json['altitude'] as num).toDouble(),
    json['name'] as String,
    json['category'] as String,
    json['officiallink'],
    json['hyperlink'],
    json['photourl'],
    json['openinghours'],
    json['urlpath'],
    json['address'],
    json['imagetext'],
  );
}

Map<String, dynamic> _$LandmarkPoiToJson(LandmarkPoi instance) => <String, dynamic>{
      'id': instance.id,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'description': instance.description,
      'altitude': 100.0,
      'name': instance.name,
      'category': instance.category,
      'officiallink': instance.officiallink,
      'hyperlink' : instance.hyperlink,
      'photourl' : instance.photourl,
      'openinghours': instance.openinghours,
      'urlpath': instance.urlpath,
      'address': instance.address,
      'imagetext': instance.imagetext,
    };

  String parseHtmlLink(String input) {
    var string = parseFragment(input, container: 'a').text.toString();
    if (string.startsWith("https://") || string.startsWith("http://") ) {
      return string;
    }else{
      return "https://"+string;
    }
  }
