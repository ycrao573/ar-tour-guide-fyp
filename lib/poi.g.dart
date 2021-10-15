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
    json['reviews'] as List<String>,
    json['imageUrl'] as String,
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
      'reviews': instance.reviews,
      'imageUrl': instance.imageUrl,
    };
