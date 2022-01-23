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
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name%2Crating%2Cphotos&input=$name%20singapore&inputtype=textquery&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));
  var jsonString = jsonDecode(response.body);
  var rating = jsonDecode(response.body)["candidates"][0]["rating"].toString();
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
  return FetchGoogleMapPhotoModel(
      reference: reference, photoReference: photoReference, rating: rating);
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
                        rating: double.parse(data.rating)),
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

class PoiDetailWidget extends StatefulWidget {
  final PoiDetailsState? poiDetail;
  final double rating;

  const PoiDetailWidget(
      {Key? key, required this.poiDetail, required this.rating})
      : super(key: key);

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
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    ignoreGestures: true,
                    onRatingUpdate: (rating) {
                      print(rating);
                    },
                  ),
                  SizedBox(width: 15.0),
                  Text(widget.rating.toString()),
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
      ]),
    );
  }

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 410,
        width: MediaQuery.of(context).size.width / 1.25,
      );
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
