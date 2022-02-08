import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikitude_flutter_app/model/fetchGoogleMapPhotoModel.dart';
import 'package:wikitude_flutter_app/widgets/shrimmingWidget.dart';

Future<FetchGoogleMapPhotoModel> fetchGoogleMapData(
    http.Client client, String name) async {
  final response = await client.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name%2Cplace_id%2Crating%2Cphotos%2Cuser_ratings_total&input=$name%20singapore&inputtype=textquery&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));
  var jsonString = jsonDecode(response.body);
  var rating = jsonDecode(response.body)["candidates"][0]["rating"].toString();
  var user_ratings_total = jsonDecode(response.body)["candidates"][0]
          ["user_ratings_total"]
      .toString();
  String reference = "";
  String photoReference = "";
  if (jsonString["candidates"][0].containsKey("photos")) {
    reference = jsonDecode(response.body)["candidates"][0]["photos"][0]
            ["photo_reference"]
        .toString();
    photoReference =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1200&" +
            "photo_reference=$reference" +
            "&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0";
  }
  String place_id = "";
  if (jsonString["candidates"][0].containsKey("place_id")) {
    place_id = jsonDecode(response.body)["candidates"][0]["place_id"];
  }
  final response2 = await client.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?fields=reviews&place_id=$place_id&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));
  var jsonString2 = jsonDecode(response2.body);
  var reviewlist = <GoogleMapReview>[];
  var reviews = jsonString2["result"]["reviews"] as List;
  reviewlist = reviews.map((i) => GoogleMapReview.fromJson(i)).toList();
  return FetchGoogleMapPhotoModel(
      reference: user_ratings_total,
      photoReference: photoReference,
      rating: rating,
      reviewlist: reviewlist);
}

Future<FetchGoogleMapPhotoWithReviewsModel> fetchGoogleLandmarkModel(
    http.Client client, String name) async {
  final response = await client.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name%2Cplace_id%2Crating%2Cphotos%2Cuser_ratings_total&input=$name%20Singapore&inputtype=textquery&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));
  var jsonString = jsonDecode(response.body);
  var rating = jsonDecode(response.body)["candidates"][0]["rating"].toString();
  var user_ratings_total = jsonDecode(response.body)["candidates"][0]
          ["user_ratings_total"]
      .toString();
  String reference = "";
  String photoReference = "";
  String place_id = "";
  if (jsonString["candidates"][0].containsKey("photos")) {
    reference = jsonDecode(response.body)["candidates"][0]["photos"][0]
            ["photo_reference"]
        .toString();
    photoReference =
        "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1200&" +
            "photo_reference=$reference" +
            "&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0";
  }
  if (jsonString["candidates"][0].containsKey("place_id")) {
    place_id = jsonDecode(response.body)["candidates"][0]["place_id"];
  }

  final response2 = await client.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?fields=reviews&place_id=$place_id&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));
  var jsonString2 = jsonDecode(response2.body);
  var reviewlist = <GoogleMapReview>[];
  var reviews = jsonString2["result"]["reviews"] as List;
  reviewlist = reviews.map((i) => GoogleMapReview.fromJson(i)).toList();
  return FetchGoogleMapPhotoWithReviewsModel(
      placeid: place_id,
      photoReference: photoReference,
      rating: rating,
      reviewlist: reviewlist,
      numrating: user_ratings_total);
}

class PoiDetailsState extends State<PoiDetailsWidget> {
  AppBar? get appBar {
    if (!Platform.isIOS) {
      return null;
    }
    return new AppBar(
      title: Text("Landmark Details"),
    );
  }

  String category;
  String id;
  String title;
  String description;
  String latitude;
  String longitude;

  PoiDetailsState(
      {required this.category,
      required this.id,
      required this.title,
      required this.description,
      required this.latitude,
      required this.longitude});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchGoogleMapPhotoModel>(
      future: fetchGoogleMapData(http.Client(), this.title),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data;
          return Scaffold(
              backgroundColor: Color(0xff85ccd8),
              appBar: this.appBar,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    data!.reference != ""
                        ? Container(
                            width: max(MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width),
                            height: min(MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: data.reference,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(data.photoReference),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 90.0),
                    PoiDetailWidget(
                      poiDetail: PoiDetailsState(
                        category: this.category,
                        id: this.id,
                        title: this.title,
                        description: this.description,
                        latitude: this.latitude,
                        longitude: this.longitude,
                      ),
                      rating: double.parse(data.rating),
                      numrating: data.reference,
                      reviewlist: data.reviewlist,
                    ),
                  ],
                ),
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class PoiDetailsWidget extends StatefulWidget {
  final String category;
  final String id;
  final String title;
  final String description;
  final String latitude;
  final String longitude;

  PoiDetailsWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.latitude,
      required this.longitude});

  @override
  PoiDetailsState createState() => new PoiDetailsState(
        category: category,
        id: id,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
      );
}

class PoiDetailWidget extends StatefulWidget {
  final PoiDetailsState? poiDetail;
  final double rating;
  final String numrating;
  final List<GoogleMapReview> reviewlist;

  const PoiDetailWidget({
    Key? key,
    required this.poiDetail,
    required this.rating,
    required this.numrating,
    required this.reviewlist,
  }) : super(key: key);

  @override
  _PoiDetailWidgetState createState() => _PoiDetailWidgetState();
}

class _PoiDetailWidgetState extends State<PoiDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
      child: Column(children: [
        Text(widget.poiDetail!.title,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20.0,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        widget.poiDetail!.category != "MRT Station"
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RatingBar.builder(
                    initialRating: widget.rating,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 20.0,
                    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(width: 8.0),
                  Text(widget.rating.toString()),
                  SizedBox(width: 5.0),
                  Text("(" + widget.numrating.toString() + ")"),
                  SizedBox(height: 2),
                ],
              )
            : SizedBox(height: 0),
        Divider(
          color: Colors.white,
        ),
        SizedBox(height: 2),
        Text("Address: " + widget.poiDetail!.description),
        SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 250,
              ),
              child: CachedNetworkImage(
                imageUrl:
                    "https://maps.googleapis.com/maps/api/staticmap?center=${widget.poiDetail!.title},Singapore&markers=${widget.poiDetail!.title},Singapore&zoom=14&size=400x400&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w",
                placeholder: (context, url) => buildAddressShimmer(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            )),
        Divider(
          color: Colors.white,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonBar(
              children: [
                TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xfff08e8d))),
                  icon: Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Find on Map',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    String googleUrl =
                        'https://www.google.com/maps/search/?api=1&query=${widget.poiDetail!.title},%20Singapore';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    }
                  },
                ),
                TextButton.icon(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xfff08e8d))),
                  icon: Icon(
                    Icons.panorama_photosphere,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Street View',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    String googleUrl =
                        'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${widget.poiDetail!.latitude},${widget.poiDetail!.longitude}';
                    if (await canLaunch(googleUrl)) {
                      await launch(googleUrl);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        Divider(color: Colors.white),
        SizedBox(height: 10),
        Text("Reviews",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.reviewlist.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3.0),
                  child: Container(
                    // height should be fixed for vertical scrolling
                    height: 100.0,
                    // SingleChildScrollView should be
                    // wrapped in an Expanded Widget
                    child: Expanded(
                      // SingleChildScrollView contains a
                      // single child which is scrollable
                      child: SingleChildScrollView(
                        // for Vertical scrolling
                        scrollDirection: Axis.vertical,
                        child: Card(
                          color: Colors.white70,
                          child: ListTile(
                            title: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 2, 2, 2),
                                  child: Row(
                                    children: [
                                      Text(
                                          widget.reviewlist[index].authorName
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 4.0),
                                      RatingBar.builder(
                                        initialRating:
                                            widget.reviewlist[index].rating! +
                                                0.0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: 12.0,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        ignoreGestures: true,
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      SizedBox(width: 4.0),
                                      Text(
                                          widget.reviewlist[index].rating!
                                              .toDouble()
                                              .toStringAsFixed(1),
                                          style: TextStyle(fontSize: 12))
                                    ],
                                  ),
                                ),
                                Text(widget.reviewlist[index].text.toString(),
                                    style: TextStyle(fontSize: 13)),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                          DateFormat('- MMM dd, yyyy')
                                              .format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      1000 *
                                                          (widget
                                                              .reviewlist[index]
                                                              .time!)))
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(widget
                                  .reviewlist[index].profilePhotoUrl
                                  .toString()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
  }

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 410,
        width: MediaQuery.of(context).size.width / 1.25,
      );
}

class LandmarkPoiDetailsState extends State<LandmarkPoiDetailsWidget> {
  AppBar? get appBar {
    if (!Platform.isIOS) {
      return null;
    }
    return new AppBar(
      title: Text("Landmark Details"),
    );
  }

  String category;
  String id;
  String title;
  String description;
  String latitude;
  String longitude;
  String officiallink;
  String hyperlink;
  String photourl;
  String openinghours;
  String urlpath;
  String address;
  String imagetext;

  LandmarkPoiDetailsState({
    required this.category,
    required this.id,
    required this.title,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.hyperlink,
    required this.photourl,
    required this.openinghours,
    required this.urlpath,
    required this.address,
    required this.imagetext,
    required this.officiallink,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FetchGoogleMapPhotoWithReviewsModel>(
      future: fetchGoogleLandmarkModel(http.Client(), this.title),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          var data = snapshot.data;
          return Scaffold(
              backgroundColor: Color(0xff85ccd8),
              appBar: this.appBar,
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    data!.placeid != ""
                        ? Container(
                            width: max(MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width),
                            height: min(MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0,
                                ),
                              ],
                            ),
                            child: Hero(
                              tag: data.placeid,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image(
                                  image: NetworkImage(data.photoReference),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(height: 90.0),
                    LandmarkPoiDetailWidget(
                        landmarkPoiDetail: LandmarkPoiDetailsState(
                          category: this.category,
                          id: this.id,
                          title: this.title,
                          description: this.description,
                          latitude: this.latitude,
                          longitude: this.longitude,
                          hyperlink: this.hyperlink,
                          photourl: this.photourl,
                          openinghours: this.openinghours,
                          urlpath: this.urlpath,
                          address: this.address,
                          imagetext: this.imagetext,
                          officiallink: this.officiallink,
                        ),
                        rating: double.parse(data.rating),
                        reviewlist: data.reviewlist,
                        numrating: data.numrating),
                  ],
                ),
              ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class LandmarkPoiDetailsWidget extends StatefulWidget {
  final String category;
  final String id;
  final String title;
  final String description;
  final String latitude;
  final String longitude;
  final String officiallink;
  final String hyperlink;
  final String photourl;
  final String openinghours;
  final String urlpath;
  final String address;
  final String imagetext;

  LandmarkPoiDetailsWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.latitude,
      required this.longitude,
      required this.hyperlink,
      required this.photourl,
      required this.openinghours,
      required this.urlpath,
      required this.address,
      required this.imagetext,
      required this.officiallink});

  @override
  LandmarkPoiDetailsState createState() => new LandmarkPoiDetailsState(
        category: category,
        id: id,
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        hyperlink: hyperlink,
        photourl: photourl,
        openinghours: openinghours,
        urlpath: urlpath,
        address: address,
        imagetext: imagetext,
        officiallink: officiallink,
      );
}

class LandmarkPoiDetailWidget extends StatefulWidget {
  final LandmarkPoiDetailsState? landmarkPoiDetail;
  final double rating;
  final String numrating;

  final List<GoogleMapReview> reviewlist;

  const LandmarkPoiDetailWidget(
      {Key? key,
      required this.landmarkPoiDetail,
      required this.rating,
      required this.reviewlist,
      required this.numrating})
      : super(key: key);

  @override
  _LandmarkPoiDetailWidgetState createState() =>
      _LandmarkPoiDetailWidgetState();
}

class _LandmarkPoiDetailWidgetState extends State<LandmarkPoiDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.landmarkPoiDetail!.title,
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            widget.landmarkPoiDetail!.category != "MRT Station"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RatingBar.builder(
                        initialRating: widget.rating,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(width: 8.0),
                      Text(widget.rating.toString()),
                      SizedBox(width: 5.0),
                      Text("(" + widget.numrating.toString() + ")"),
                      SizedBox(height: 2),
                    ],
                  )
                : SizedBox(height: 0),
            Divider(
              color: Colors.white,
            ),
            SizedBox(height: 2),
            Text(widget.landmarkPoiDetail!.description),
            SizedBox(height: 10),
            Text("Opening Hours: ",
                style: TextStyle(fontWeight: FontWeight.w700)),
            Text(widget.landmarkPoiDetail!.openinghours),
            SizedBox(height: 10),
            Text("Address: ", style: TextStyle(fontWeight: FontWeight.w700)),
            Text(widget.landmarkPoiDetail!.address),
            SizedBox(height: 10),
            SizedBox(height: 10),
            Center(
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://maps.googleapis.com/maps/api/staticmap?center=${widget.landmarkPoiDetail!.title},Singapore&markers=${widget.landmarkPoiDetail!.title},Singapore&zoom=14&size=400x400&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w",
                      placeholder: (context, url) => buildAddressShimmer(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  )),
            ),
            Divider(
              color: Colors.white,
            ),
            Align(
              alignment: Alignment.center,
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                icon: Image.network(
                    "https://pbs.twimg.com/profile_images/900675547252097024/X-0HqqGi_400x400.jpg",
                    height: 25),
                label: Text(
                  'View in Singapore Tourism Board',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  String googleUrl = widget.landmarkPoiDetail!.officiallink;
                  if (await canLaunch(googleUrl)) {
                    await launch(googleUrl);
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBar(
                  children: [
                    TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xfff08e8d))),
                      icon: Icon(
                        Icons.map_outlined,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Find on Map',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () async {
                        String googleUrl =
                            'https://www.google.com/maps/search/?api=1&query=${widget.landmarkPoiDetail!.title},%20Singapore';
                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        }
                      },
                    ),
                    TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xfff08e8d))),
                      icon: Icon(
                        Icons.panorama_photosphere,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Street View',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500),
                      ),
                      onPressed: () async {
                        String googleUrl =
                            'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${widget.landmarkPoiDetail!.latitude},${widget.landmarkPoiDetail!.longitude}';
                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.white),
            SizedBox(height: 10),
            Text("Reviews",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 50),
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.reviewlist.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Container(
                        // height should be fixed for vertical scrolling
                        height: 100.0,
                        // SingleChildScrollView should be
                        // wrapped in an Expanded Widget
                        child: Expanded(
                          // SingleChildScrollView contains a
                          // single child which is scrollable
                          child: SingleChildScrollView(
                            // for Vertical scrolling
                            scrollDirection: Axis.vertical,
                            child: Card(
                              color: Colors.white70,
                              child: ListTile(
                                title: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 2, 2, 2),
                                      child: Row(
                                        children: [
                                          Text(
                                              widget
                                                  .reviewlist[index].authorName
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(width: 4.0),
                                          RatingBar.builder(
                                            initialRating: widget
                                                    .reviewlist[index].rating! +
                                                0.0,
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: 12.0,
                                            itemPadding: EdgeInsets.symmetric(
                                                horizontal: 1.0),
                                            itemBuilder: (context, _) => Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            ignoreGestures: true,
                                            onRatingUpdate: (rating) {
                                              print(rating);
                                            },
                                          ),
                                          SizedBox(width: 4.0),
                                          Text(
                                              widget.reviewlist[index].rating!
                                                  .toDouble()
                                                  .toStringAsFixed(1),
                                              style: TextStyle(fontSize: 12))
                                        ],
                                      ),
                                    ),
                                    Text(
                                        widget.reviewlist[index].text
                                            .toString(),
                                        style: TextStyle(fontSize: 13)),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                              DateFormat('- MMM dd, yyyy')
                                                  .format(DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          1000 *
                                                              (widget
                                                                  .reviewlist[
                                                                      index]
                                                                  .time!)))
                                                  .toString(),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(widget
                                      .reviewlist[index].profilePhotoUrl
                                      .toString()),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ]),
    );
  }

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 405,
        width: MediaQuery.of(context).size.width / 1.3,
      );
}
