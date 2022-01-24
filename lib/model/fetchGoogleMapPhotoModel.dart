class FetchGoogleMapPhotoModel {
  late String reference;
  late String photoReference;
  late String rating;

  FetchGoogleMapPhotoModel(
      {this.reference = "", this.photoReference = "", required this.rating});

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

class FetchGoogleMapPhotoWithReviewsModel {
  late String placeid;
  late String photoReference;
  late String rating;
  late List<GoogleMapReview> reviewlist;

  FetchGoogleMapPhotoWithReviewsModel(
      {this.placeid = "",
      this.photoReference = "",
      required this.rating,
      this.reviewlist = const <GoogleMapReview>[]});

  FetchGoogleMapPhotoWithReviewsModel.fromJson(Map<String, dynamic> json) {
    placeid = json['place_id'];
    photoReference = json['photo_reference'];
    rating = json['rating'];
    reviewlist = json['reviewlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['place_id'] = this.placeid;
    data['photo_reference'] = this.photoReference;
    data['rating'] = this.rating;
    return data;
  }
}

class GoogleMapReview {
  String? authorName;
  String? authorUrl;
  String? language;
  String? profilePhotoUrl;
  int? rating;
  String? relativeTimeDescription;
  String? text;
  int? time;

  GoogleMapReview(
      {this.authorName,
      this.authorUrl,
      this.language,
      this.profilePhotoUrl,
      this.rating,
      this.relativeTimeDescription,
      this.text,
      this.time});

  GoogleMapReview.fromJson(Map<String, dynamic> json) {
    authorName = json['author_name'];
    authorUrl = json['author_url'];
    language = json['language'];
    profilePhotoUrl = json['profile_photo_url'];
    rating = json['rating'];
    relativeTimeDescription = json['relative_time_description'];
    text = json['text'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_name'] = this.authorName;
    data['author_url'] = this.authorUrl;
    data['language'] = this.language;
    data['profile_photo_url'] = this.profilePhotoUrl;
    data['rating'] = this.rating;
    data['relative_time_description'] = this.relativeTimeDescription;
    data['text'] = this.text;
    data['time'] = this.time;
    return data;
  }
}
