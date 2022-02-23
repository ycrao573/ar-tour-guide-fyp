class RestaurantModel {
  String? locationId;
  String? name;
  String? latitude;
  String? longitude;
  String? numReviews;
  String? locationString;
  Photo? photo;
  List<Awards>? awards;
  String? ranking;
  String? distance;
  String? distanceString;
  String? rating;
  bool? isClosed;
  String? openNowText;
  String? priceLevel;
  String? price;
  String? description;
  String? webUrl;
  String? writeReview;
  List<Reviews>? reviews;
  String? phone;
  String? website;
  String? email;
  String? address;
  List<Cuisine>? cuisine;
  List<DietaryRestrictions>? dietaryRestrictions;

  RestaurantModel(
      {this.locationId,
      this.name,
      this.latitude,
      this.longitude,
      this.numReviews,
      this.locationString,
      this.photo,
      this.awards,
      this.ranking,
      this.distance,
      this.distanceString,
      this.rating,
      this.isClosed,
      this.openNowText,
      this.priceLevel,
      this.price,
      this.description,
      this.webUrl,
      this.writeReview,
      this.reviews,
      this.phone,
      this.website,
      this.email,
      this.address,
      this.cuisine,
      this.dietaryRestrictions});

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    name = json['name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    numReviews = json['num_reviews'];
    locationString = json['location_string'];
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    if (json['awards'] != null) {
      awards = <Awards>[];
      json['awards'].forEach((v) {
        awards!.add(new Awards.fromJson(v));
      });
    }
    ranking = json['ranking'];
    distance = json['distance'];
    distanceString = json['distance_string'];
    rating = json['rating'];
    isClosed = json['is_closed'];
    openNowText = json['open_now_text'];
    priceLevel = json['price_level'];
    price = json['price'];
    description = json['description'];
    webUrl = json['web_url'];
    writeReview = json['write_review'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      var abc = json['reviews'];
      if (abc[0] != null) {
        json['reviews'].forEach((v) {
          reviews!.add(new Reviews.fromJson(v));
        });
      }
    }
    phone = json['phone'];
    website = json['website'];
    email = json['email'];
    address = json['address'];
    if (json['cuisine'] != null) {
      cuisine = <Cuisine>[];
      json['cuisine'].forEach((v) {
        cuisine!.add(new Cuisine.fromJson(v));
      });
    }
    if (json['dietary_restrictions'] != null) {
      dietaryRestrictions = <DietaryRestrictions>[];
      json['dietary_restrictions'].forEach((v) {
        dietaryRestrictions!.add(new DietaryRestrictions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['name'] = this.name;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['num_reviews'] = this.numReviews;
    data['location_string'] = this.locationString;
    if (this.photo != null) {
      data['photo'] = this.photo!.toJson();
    }
    if (this.awards != null) {
      data['awards'] = this.awards!.map((v) => v.toJson()).toList();
    }
    data['ranking'] = this.ranking;
    data['distance'] = this.distance;
    data['distance_string'] = this.distanceString;
    data['rating'] = this.rating;
    data['is_closed'] = this.isClosed;
    data['open_now_text'] = this.openNowText;
    data['price_level'] = this.priceLevel;
    data['price'] = this.price;
    data['description'] = this.description;
    data['web_url'] = this.webUrl;
    data['write_review'] = this.writeReview;
    if (this.reviews != null) {
      data['reviews'] = this.reviews!.map((v) => v.toJson()).toList();
    }
    data['phone'] = this.phone;
    data['website'] = this.website;
    data['email'] = this.email;
    data['address'] = this.address;
    if (this.cuisine != null) {
      data['cuisine'] = this.cuisine!.map((v) => v.toJson()).toList();
    }
    if (this.dietaryRestrictions != null) {
      data['dietary_restrictions'] =
          this.dietaryRestrictions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Photo {
  Images? images;
  String? caption;

  Photo({this.images, this.caption});

  Photo.fromJson(Map<String, dynamic> json) {
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
    caption = json['caption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }
    data['caption'] = this.caption;
    return data;
  }
}

class Images {
  Small? small;
  Small? thumbnail;
  Small? original;
  Small? large;
  Small? medium;

  Images({this.small, this.thumbnail, this.original, this.large, this.medium});

  Images.fromJson(Map<String, dynamic> json) {
    small = json['small'] != null ? new Small.fromJson(json['small']) : null;
    thumbnail = json['thumbnail'] != null
        ? new Small.fromJson(json['thumbnail'])
        : null;
    original =
        json['original'] != null ? new Small.fromJson(json['original']) : null;
    large = json['large'] != null ? new Small.fromJson(json['large']) : null;
    medium = json['medium'] != null ? new Small.fromJson(json['medium']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.small != null) {
      data['small'] = this.small!.toJson();
    }
    if (this.thumbnail != null) {
      data['thumbnail'] = this.thumbnail!.toJson();
    }
    if (this.original != null) {
      data['original'] = this.original!.toJson();
    }
    if (this.large != null) {
      data['large'] = this.large!.toJson();
    }
    if (this.medium != null) {
      data['medium'] = this.medium!.toJson();
    }
    return data;
  }
}

class AwardsImages {
  String? small;
  String? large;

  AwardsImages({this.small, this.large});

  AwardsImages.fromJson(Map<String, dynamic> json) {
    small = json['small'] != null ? json['small'] : null;
    large = json['large'] != null ? json['large'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.small != null) {
      data['small'] = this.small!;
    }
    if (this.large != null) {
      data['large'] = this.large!;
    }
    return data;
  }
}

class Small {
  String? width;
  String? url;
  String? height;

  Small({this.width, this.url, this.height});

  Small.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    url = json['url'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['url'] = this.url;
    data['height'] = this.height;
    return data;
  }
}

class Awards {
  String? awardType;
  String? year;
  AwardsImages? images;
  String? displayName;

  Awards({this.awardType, this.year, this.images, this.displayName});

  Awards.fromJson(Map<String, dynamic> json) {
    awardType = json['award_type'];
    year = json['year'];
    images = json['images'] != null
        ? new AwardsImages.fromJson(json['images'])
        : null;
    displayName = json['display_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['award_type'] = this.awardType;
    data['year'] = this.year;
    if (this.images != null) {
      data['images'] = this.images!.toJson();
    }
    data['display_name'] = this.displayName;
    return data;
  }
}

class Reviews {
  String? rating;
  String? type;
  String? url;
  String? title;

  Reviews({this.rating, this.type, this.url, this.title});

  Reviews.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    type = json['type'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rating'] = this.rating;
    data['type'] = this.type;
    data['url'] = this.url;
    data['title'] = this.title;
    return data;
  }
}

class Cuisine {
  String? key;
  String? name;

  Cuisine({this.key, this.name});

  Cuisine.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    return data;
  }
}

class DietaryRestrictions {
  String? key;
  String? name;

  DietaryRestrictions({this.key, this.name});

  DietaryRestrictions.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['name'] = this.name;
    return data;
  }
}
