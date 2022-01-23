class FetchGoogleMapPhotoModel {
  late String reference;
  late String photoReference;
  late String rating;

  FetchGoogleMapPhotoModel(
      {this.reference = "",
      this.photoReference = "",
      required this.rating});

  FetchGoogleMapPhotoModel.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    photoReference = json['photo_reference'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    data['photo_reference'] = this.photoReference;
    data['rating'] = this.rating;
    return data;
  }
}
