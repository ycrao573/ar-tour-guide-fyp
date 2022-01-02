// class AttrationModel {
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

//   const AttrationModel(
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

class AttrationModel {
  late String name;
  late String description;
  late String hYPERLINK;
  late String pHOTOURL;
  late String latitude;
  late String longtitude;
  late String openingHours;
  late String aDDRESSPOSTALCODE;
  late String uRLPath;
  late String aDDRESSSTREETNAME;
  late String imageText;
  late String field1;
  late int id;
  late String category;

  AttrationModel(
      {required this.name,
      required this.description,
      this.hYPERLINK = "",
      this.pHOTOURL = "",
      required this.latitude,
      required this.longtitude,
      this.openingHours = "",
      this.aDDRESSPOSTALCODE = "",
      this.uRLPath = "",
      this.aDDRESSSTREETNAME = "",
      this.imageText = "",
      this.field1 = "",
      required this.id,
      required this.category});

  AttrationModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    hYPERLINK = json['HYPERLINK'];
    pHOTOURL = json['PHOTOURL'];
    latitude = json['latitude'];
    longtitude = json['longtitude'];
    openingHours = json['Opening Hours'];
    aDDRESSPOSTALCODE = json['ADDRESSPOSTALCODE'];
    uRLPath = json['URL Path'];
    aDDRESSSTREETNAME = json['ADDRESSSTREETNAME'];
    imageText = json['Image Text'];
    field1 = json['Field_1'];
    id = json['id'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['HYPERLINK'] = this.hYPERLINK;
    data['PHOTOURL'] = this.pHOTOURL;
    data['latitude'] = this.latitude;
    data['longtitude'] = this.longtitude;
    data['Opening Hours'] = this.openingHours;
    data['ADDRESSPOSTALCODE'] = this.aDDRESSPOSTALCODE;
    data['URL Path'] = this.uRLPath;
    data['ADDRESSSTREETNAME'] = this.aDDRESSSTREETNAME;
    data['Image Text'] = this.imageText;
    data['Field_1'] = this.field1;
    data['id'] = this.id;
    data['category'] = this.category;
    return data;
  }
}
