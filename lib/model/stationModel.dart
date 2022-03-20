class StationModel {
  String? id;
  String? longitude;
  String? latitude;
  String? description;
  String? name;
  String? chinese;
  String? altitude;
  String? category;

  StationModel(
      {this.id,
      this.longitude,
      this.latitude,
      this.description,
      this.name,
      this.chinese,
      this.altitude,
      this.category});

  StationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    description = json['description'];
    name = json['name'];
    chinese = json['chinese'];
    altitude = json['altitude'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['description'] = this.description;
    data['name'] = this.name;
    data['chinese'] = this.chinese;
    data['altitude'] = this.altitude;
    data['category'] = this.category;
    return data;
  }
}