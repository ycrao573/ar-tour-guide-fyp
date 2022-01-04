// class AttractionModel {
//   final int id;
//   final String category;
//   final String description;
//   final String name;
//   final String hyperlink;
//   final String photourl;
//   final String longitude;
//   final String latitude;
//   final String openinghours;
//   final String imagetext;
//   final String postalcode;

//   const AttractionModel(
//       this.id,
//       this.category,
//       this.description,
//       this.name,
//       this.hyperlink,
//       this.photourl,
//       this.longitude,
//       this.latitude,
//       this.openinghours,
//       this.imagetext,
//       this.postalcode);
// }
// https://www.kindacode.com/article/how-to-read-local-json-files-in-flutter/

import 'package:html/parser.dart' show parse, parseFragment;
import 'package:html/dom.dart' as dom;

class AttractionModel {
  late String name;
  late String description;
  late String hyperlink;
  late String photourl;
  late String latitude;
  late String longitude;
  late String openingHours;
  late String postalcode;
  late String urlpath;
  late String address;
  late String imageText;
  late String field1;
  late int id;
  late String category;

  AttractionModel(
      {required this.name,
      required this.description,
      this.hyperlink = "",
      this.photourl = "",
      required this.latitude,
      required this.longitude,
      this.openingHours = "",
      this.postalcode = "",
      this.urlpath = "",
      this.address = "",
      this.imageText = "",
      this.field1 = "",
      required this.id,
      required this.category});

  AttractionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    hyperlink = parseHtmlLink(json['HYPERLINK']);
    photourl = parseHtmlLink(json['PHOTOURL']);
    latitude = json['latitude'];
    longitude = json['longtitude'];
    openingHours = json['Opening Hours'];
    postalcode = json['ADDRESSPOSTALCODE'];
    urlpath = parseHtmlLink(json['URL Path']);
    address = json['ADDRESSSTREETNAME'];
    imageText = json['Image Text'];
    field1 = json['Field_1'];
    id = json['id'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['HYPERLINK'] = this.hyperlink;
    data['PHOTOURL'] = this.photourl;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longitude;
    data['Opening Hours'] = this.openingHours;
    data['ADDRESSPOSTALCODE'] = this.postalcode;
    data['URL Path'] = this.urlpath;
    data['ADDRESSSTREETNAME'] = this.address;
    data['Image Text'] = this.imageText;
    data['Field_1'] = this.field1;
    data['id'] = this.id;
    data['category'] = this.category;
    return data;
  }

  String parseHtmlLink(String input) {
    return "https://" + parseFragment(input, container: 'a').text.toString();
  }
}
