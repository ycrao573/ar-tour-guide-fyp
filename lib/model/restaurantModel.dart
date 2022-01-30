class RestaurantModel {
  String? locationId;
  String? name;
  String? latitude;
  String? longitude;
  String? numReviews;
  String? timezone;
  String? locationString;
  Photo? photo;
  List<dynamic>? awards;
  String? doubleclickZone;
  String? preferredMapEngine;
  String? rawRanking;
  String? rankingGeo;
  String? rankingGeoId;
  String? rankingPosition;
  String? rankingDenominator;
  String? rankingCategory;
  String? ranking;
  String? distance;
  String? distanceString;
  String? bearing;
  String? rating;
  bool? isClosed;
  bool? isLongClosed;
  String? priceLevel;
  List<NeighborhoodInfo>? neighborhoodInfo;
  String? description;
  String? webUrl;
  String? writeReview;
  List<Ancestors>? ancestors;
  Category? category;
  List<dynamic>? subcategory;
  String? parentDisplayName;
  bool? isJfyEnabled;
  List<dynamic>? nearestMetroStation;
  List<Reviews>? reviews;
  String? phone;
  String? website;
  String? email;
  AddressObj? addressObj;
  String? address;
  bool? isCandidateForContactInfoSuppression;
  List<Cuisine>? cuisine;
  List<dynamic>? dietaryRestrictions;
  List<EstablishmentTypes>? establishmentTypes;

  RestaurantModel({
    this.locationId,
    this.name,
    this.latitude,
    this.longitude,
    this.numReviews,
    this.timezone,
    this.locationString,
    this.photo,
    this.awards,
    this.doubleclickZone,
    this.preferredMapEngine,
    this.rawRanking,
    this.rankingGeo,
    this.rankingGeoId,
    this.rankingPosition,
    this.rankingDenominator,
    this.rankingCategory,
    this.ranking,
    this.distance,
    this.distanceString,
    this.bearing,
    this.rating,
    this.isClosed,
    this.isLongClosed,
    this.priceLevel,
    this.neighborhoodInfo,
    this.description,
    this.webUrl,
    this.writeReview,
    this.ancestors,
    this.category,
    this.subcategory,
    this.parentDisplayName,
    this.isJfyEnabled,
    this.nearestMetroStation,
    this.reviews,
    this.phone,
    this.website,
    this.email,
    this.addressObj,
    this.address,
    this.isCandidateForContactInfoSuppression,
    this.cuisine,
    this.dietaryRestrictions,
    this.establishmentTypes,
  });

  RestaurantModel.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'] as String?;
    name = json['name'] as String?;
    latitude = json['latitude'] as String?;
    longitude = json['longitude'] as String?;
    numReviews = json['num_reviews'] as String?;
    timezone = json['timezone'] as String?;
    locationString = json['location_string'] as String?;
    photo = (json['photo'] as Map<String,dynamic>?) != null ? Photo.fromJson(json['photo'] as Map<String,dynamic>) : null;
    awards = json['awards'] as List?;
    doubleclickZone = json['doubleclick_zone'] as String?;
    preferredMapEngine = json['preferred_map_engine'] as String?;
    rawRanking = json['raw_ranking'] as String?;
    rankingGeo = json['ranking_geo'] as String?;
    rankingGeoId = json['ranking_geo_id'] as String?;
    rankingPosition = json['ranking_position'] as String?;
    rankingDenominator = json['ranking_denominator'] as String?;
    rankingCategory = json['ranking_category'] as String?;
    ranking = json['ranking'] as String?;
    distance = json['distance'] as String?;
    distanceString = json['distance_string'] as String?;
    bearing = json['bearing'] as String?;
    rating = json['rating'] as String?;
    isClosed = json['is_closed'] as bool?;
    isLongClosed = json['is_long_closed'] as bool?;
    priceLevel = json['price_level'] as String?;
    neighborhoodInfo = (json['neighborhood_info'] as List?)?.map((dynamic e) => NeighborhoodInfo.fromJson(e as Map<String,dynamic>)).toList();
    description = json['description'] as String?;
    webUrl = json['web_url'] as String?;
    writeReview = json['write_review'] as String?;
    ancestors = (json['ancestors'] as List?)?.map((dynamic e) => Ancestors.fromJson(e as Map<String,dynamic>)).toList();
    category = (json['category'] as Map<String,dynamic>?) != null ? Category.fromJson(json['category'] as Map<String,dynamic>) : null;
    subcategory = json['subcategory'] as List?;
    parentDisplayName = json['parent_display_name'] as String?;
    isJfyEnabled = json['is_jfy_enabled'] as bool?;
    nearestMetroStation = json['nearest_metro_station'] as List?;
    reviews = (json['reviews'] as List?)?.map((dynamic e) => Reviews.fromJson(e as Map<String,dynamic>)).toList();
    phone = json['phone'] as String?;
    website = json['website'] as String?;
    email = json['email'] as String?;
    addressObj = (json['address_obj'] as Map<String,dynamic>?) != null ? AddressObj.fromJson(json['address_obj'] as Map<String,dynamic>) : null;
    address = json['address'] as String?;
    isCandidateForContactInfoSuppression = json['is_candidate_for_contact_info_suppression'] as bool?;
    cuisine = (json['cuisine'] as List?)?.map((dynamic e) => Cuisine.fromJson(e as Map<String,dynamic>)).toList();
    dietaryRestrictions = json['dietary_restrictions'] as List?;
    establishmentTypes = (json['establishment_types'] as List?)?.map((dynamic e) => EstablishmentTypes.fromJson(e as Map<String,dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['location_id'] = locationId;
    json['name'] = name;
    json['latitude'] = latitude;
    json['longitude'] = longitude;
    json['num_reviews'] = numReviews;
    json['timezone'] = timezone;
    json['location_string'] = locationString;
    json['photo'] = photo?.toJson();
    json['awards'] = awards;
    json['doubleclick_zone'] = doubleclickZone;
    json['preferred_map_engine'] = preferredMapEngine;
    json['raw_ranking'] = rawRanking;
    json['ranking_geo'] = rankingGeo;
    json['ranking_geo_id'] = rankingGeoId;
    json['ranking_position'] = rankingPosition;
    json['ranking_denominator'] = rankingDenominator;
    json['ranking_category'] = rankingCategory;
    json['ranking'] = ranking;
    json['distance'] = distance;
    json['distance_string'] = distanceString;
    json['bearing'] = bearing;
    json['rating'] = rating;
    json['is_closed'] = isClosed;
    json['is_long_closed'] = isLongClosed;
    json['price_level'] = priceLevel;
    json['neighborhood_info'] = neighborhoodInfo?.map((e) => e.toJson()).toList();
    json['description'] = description;
    json['web_url'] = webUrl;
    json['write_review'] = writeReview;
    json['ancestors'] = ancestors?.map((e) => e.toJson()).toList();
    json['category'] = category?.toJson();
    json['subcategory'] = subcategory;
    json['parent_display_name'] = parentDisplayName;
    json['is_jfy_enabled'] = isJfyEnabled;
    json['nearest_metro_station'] = nearestMetroStation;
    json['reviews'] = reviews?.map((e) => e.toJson()).toList();
    json['phone'] = phone;
    json['website'] = website;
    json['email'] = email;
    json['address_obj'] = addressObj?.toJson();
    json['address'] = address;
    json['is_candidate_for_contact_info_suppression'] = isCandidateForContactInfoSuppression;
    json['cuisine'] = cuisine?.map((e) => e.toJson()).toList();
    json['dietary_restrictions'] = dietaryRestrictions;
    json['establishment_types'] = establishmentTypes?.map((e) => e.toJson()).toList();
    return json;
  }
}

class Photo {
  Images? images;
  bool? isBlessed;
  String? uploadedDate;
  String? caption;
  String? id;
  String? helpfulVotes;
  String? publishedDate;
  User? user;

  Photo({
    this.images,
    this.isBlessed,
    this.uploadedDate,
    this.caption,
    this.id,
    this.helpfulVotes,
    this.publishedDate,
    this.user,
  });

  Photo.fromJson(Map<String, dynamic> json) {
    images = (json['images'] as Map<String,dynamic>?) != null ? Images.fromJson(json['images'] as Map<String,dynamic>) : null;
    isBlessed = json['is_blessed'] as bool?;
    uploadedDate = json['uploaded_date'] as String?;
    caption = json['caption'] as String?;
    id = json['id'] as String?;
    helpfulVotes = json['helpful_votes'] as String?;
    publishedDate = json['published_date'] as String?;
    user = (json['user'] as Map<String,dynamic>?) != null ? User.fromJson(json['user'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['images'] = images?.toJson();
    json['is_blessed'] = isBlessed;
    json['uploaded_date'] = uploadedDate;
    json['caption'] = caption;
    json['id'] = id;
    json['helpful_votes'] = helpfulVotes;
    json['published_date'] = publishedDate;
    json['user'] = user?.toJson();
    return json;
  }
}

class Images {
  Small? small;
  Thumbnail? thumbnail;
  Original? original;
  Large? large;
  Medium? medium;

  Images({
    this.small,
    this.thumbnail,
    this.original,
    this.large,
    this.medium,
  });

  Images.fromJson(Map<String, dynamic> json) {
    small = (json['small'] as Map<String,dynamic>?) != null ? Small.fromJson(json['small'] as Map<String,dynamic>) : null;
    thumbnail = (json['thumbnail'] as Map<String,dynamic>?) != null ? Thumbnail.fromJson(json['thumbnail'] as Map<String,dynamic>) : null;
    original = (json['original'] as Map<String,dynamic>?) != null ? Original.fromJson(json['original'] as Map<String,dynamic>) : null;
    large = (json['large'] as Map<String,dynamic>?) != null ? Large.fromJson(json['large'] as Map<String,dynamic>) : null;
    medium = (json['medium'] as Map<String,dynamic>?) != null ? Medium.fromJson(json['medium'] as Map<String,dynamic>) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['small'] = small?.toJson();
    json['thumbnail'] = thumbnail?.toJson();
    json['original'] = original?.toJson();
    json['large'] = large?.toJson();
    json['medium'] = medium?.toJson();
    return json;
  }
}

class Small {
  String? width;
  String? url;
  String? height;

  Small({
    this.width,
    this.url,
    this.height,
  });

  Small.fromJson(Map<String, dynamic> json) {
    width = json['width'] as String?;
    url = json['url'] as String?;
    height = json['height'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['width'] = width;
    json['url'] = url;
    json['height'] = height;
    return json;
  }
}

class Thumbnail {
  String? width;
  String? url;
  String? height;

  Thumbnail({
    this.width,
    this.url,
    this.height,
  });

  Thumbnail.fromJson(Map<String, dynamic> json) {
    width = json['width'] as String?;
    url = json['url'] as String?;
    height = json['height'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['width'] = width;
    json['url'] = url;
    json['height'] = height;
    return json;
  }
}

class Original {
  String? width;
  String? url;
  String? height;

  Original({
    this.width,
    this.url,
    this.height,
  });

  Original.fromJson(Map<String, dynamic> json) {
    width = json['width'] as String?;
    url = json['url'] as String?;
    height = json['height'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['width'] = width;
    json['url'] = url;
    json['height'] = height;
    return json;
  }
}

class Large {
  String? width;
  String? url;
  String? height;

  Large({
    this.width,
    this.url,
    this.height,
  });

  Large.fromJson(Map<String, dynamic> json) {
    width = json['width'] as String?;
    url = json['url'] as String?;
    height = json['height'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['width'] = width;
    json['url'] = url;
    json['height'] = height;
    return json;
  }
}

class Medium {
  String? width;
  String? url;
  String? height;

  Medium({
    this.width,
    this.url,
    this.height,
  });

  Medium.fromJson(Map<String, dynamic> json) {
    width = json['width'] as String?;
    url = json['url'] as String?;
    height = json['height'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['width'] = width;
    json['url'] = url;
    json['height'] = height;
    return json;
  }
}

class User {
  dynamic userId;
  String? memberId;
  String? type;

  User({
    this.userId,
    this.memberId,
    this.type,
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    memberId = json['member_id'] as String?;
    type = json['type'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['user_id'] = userId;
    json['member_id'] = memberId;
    json['type'] = type;
    return json;
  }
}

class NeighborhoodInfo {
  String? locationId;
  String? name;

  NeighborhoodInfo({
    this.locationId,
    this.name,
  });

  NeighborhoodInfo.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['location_id'] = locationId;
    json['name'] = name;
    return json;
  }
}

class Ancestors {
  List<Subcategory>? subcategory;
  String? name;
  dynamic abbrv;
  String? locationId;

  Ancestors({
    this.subcategory,
    this.name,
    this.abbrv,
    this.locationId,
  });

  Ancestors.fromJson(Map<String, dynamic> json) {
    subcategory = (json['subcategory'] as List?)?.map((dynamic e) => Subcategory.fromJson(e as Map<String,dynamic>)).toList();
    name = json['name'] as String?;
    abbrv = json['abbrv'];
    locationId = json['location_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['subcategory'] = subcategory?.map((e) => e.toJson()).toList();
    json['name'] = name;
    json['abbrv'] = abbrv;
    json['location_id'] = locationId;
    return json;
  }
}

class Subcategory {
  String? key;
  String? name;

  Subcategory({
    this.key,
    this.name,
  });

  Subcategory.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['key'] = key;
    json['name'] = name;
    return json;
  }
}

class Category {
  String? key;
  String? name;

  Category({
    this.key,
    this.name,
  });

  Category.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['key'] = key;
    json['name'] = name;
    return json;
  }
}

class Reviews {
  String? id;
  dynamic lang;
  String? locationId;
  String? publishedDate;
  String? publishedPlatform;
  String? rating;
  String? type;
  String? helpfulVotes;
  String? url;
  dynamic travelDate;
  dynamic text;
  dynamic user;
  String? title;
  dynamic ownerResponse;
  List<dynamic>? subratings;
  bool? machineTranslated;
  bool? machineTranslatable;

  Reviews({
    this.id,
    this.lang,
    this.locationId,
    this.publishedDate,
    this.publishedPlatform,
    this.rating,
    this.type,
    this.helpfulVotes,
    this.url,
    this.travelDate,
    this.text,
    this.user,
    this.title,
    this.ownerResponse,
    this.subratings,
    this.machineTranslated,
    this.machineTranslatable,
  });

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'] as String?;
    lang = json['lang'];
    locationId = json['location_id'] as String?;
    publishedDate = json['published_date'] as String?;
    publishedPlatform = json['published_platform'] as String?;
    rating = json['rating'] as String?;
    type = json['type'] as String?;
    helpfulVotes = json['helpful_votes'] as String?;
    url = json['url'] as String?;
    travelDate = json['travel_date'];
    text = json['text'];
    user = json['user'];
    title = json['title'] as String?;
    ownerResponse = json['owner_response'];
    subratings = json['subratings'] as List?;
    machineTranslated = json['machine_translated'] as bool?;
    machineTranslatable = json['machine_translatable'] as bool?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['lang'] = lang;
    json['location_id'] = locationId;
    json['published_date'] = publishedDate;
    json['published_platform'] = publishedPlatform;
    json['rating'] = rating;
    json['type'] = type;
    json['helpful_votes'] = helpfulVotes;
    json['url'] = url;
    json['travel_date'] = travelDate;
    json['text'] = text;
    json['user'] = user;
    json['title'] = title;
    json['owner_response'] = ownerResponse;
    json['subratings'] = subratings;
    json['machine_translated'] = machineTranslated;
    json['machine_translatable'] = machineTranslatable;
    return json;
  }
}

class AddressObj {
  String? street1;
  String? street2;
  String? city;
  dynamic state;
  String? country;
  String? postalcode;

  AddressObj({
    this.street1,
    this.street2,
    this.city,
    this.state,
    this.country,
    this.postalcode,
  });

  AddressObj.fromJson(Map<String, dynamic> json) {
    street1 = json['street1'] as String?;
    street2 = json['street2'] as String?;
    city = json['city'] as String?;
    state = json['state'];
    country = json['country'] as String?;
    postalcode = json['postalcode'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['street1'] = street1;
    json['street2'] = street2;
    json['city'] = city;
    json['state'] = state;
    json['country'] = country;
    json['postalcode'] = postalcode;
    return json;
  }
}

class Cuisine {
  String? key;
  String? name;

  Cuisine({
    this.key,
    this.name,
  });

  Cuisine.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['key'] = key;
    json['name'] = name;
    return json;
  }
}

class EstablishmentTypes {
  String? key;
  String? name;

  EstablishmentTypes({
    this.key,
    this.name,
  });

  EstablishmentTypes.fromJson(Map<String, dynamic> json) {
    key = json['key'] as String?;
    name = json['name'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['key'] = key;
    json['name'] = name;
    return json;
  }
}