import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelee/model/restaurantModel.dart';
import 'package:http/http.dart' as http;
import 'package:travelee/widgets/shrimmingWidget.dart';

class RestaurantScreen extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantScreen({Key? key, required this.restaurant})
      : super(key: key);

  @override
  _RestaurantScreenState createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff85ccd8),
        body: Column(children: [
          Stack(children: [
            Stack(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.width,
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
                child: Container(
                  child: buildHeroWidget(widget.restaurant.name!),
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.restaurant.name! + " ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      (widget.restaurant.priceLevel != "")
                          ? Text(
                              "Price Level: " +
                                  widget.restaurant.priceLevel! +
                                  (widget.restaurant.price != null
                                      ? " (" + widget.restaurant.price! + ")"
                                      : ""),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : SizedBox(width: 0.0),
                      SizedBox(height: 3.0),
                      Row(
                        children: [
                          buildStarRatingWidget(
                              widget.restaurant.rating! + " "),
                          Text(widget.restaurant.rating!,
                              style: TextStyle(color: Colors.white)),
                          Text(" (" + widget.restaurant.numReviews! + ")",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.pin_drop,
                            size: 14.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 7.0),
                          SizedBox(
                            width: 300,
                            child: Text(widget.restaurant.address!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.0,
                                )),
                          )
                        ],
                      ),
                    ]),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ])
          ]),
          Container(
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      widget.restaurant.cuisine!.length != 0
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: widget.restaurant.cuisine!
                                      .map((item) => Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Chip(
                                              backgroundColor: Colors.red[200],
                                              label: Text(item.name!,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white)),
                                            ),
                                          ))
                                      .toList()),
                            )
                          : Text(""),
                      Text(
                        widget.restaurant.description!,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.restaurant.isClosed! ? "Closed" : "Open now",
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
                      widget.restaurant.phone != null
                          ? Text(
                              "Phone: " + widget.restaurant.phone!,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : SizedBox(width: 0.0),
                      widget.restaurant.email != null
                          ? Text(
                              widget.restaurant.email!,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : SizedBox(width: 0.0),
                      Divider(
                        color: Colors.white,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 250,
                            ),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://maps.googleapis.com/maps/api/staticmap?center=${widget.restaurant.latitude},${widget.restaurant.longitude}&markers=${widget.restaurant.latitude},${widget.restaurant.longitude}&zoom=14&size=500x250&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w",
                              placeholder: (context, url) =>
                                  buildAddressShimmer(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 300,
                              child: TextButton.icon(
                                icon: Icon(Icons.restaurant),
                                label: Text(
                                  "Restaurant Website",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    )),
                                onPressed: () async {
                                  String url = widget.restaurant.website!;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: TextButton.icon(
                                icon: ImageIcon(
                                  NetworkImage(
                                      "https://cdn-icons-png.flaticon.com/512/1216/1216908.png"),
                                  size: 25,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "See More in TripAdvisor",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xff00AF87)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    )),
                                onPressed: () async {
                                  String url = widget.restaurant.webUrl!;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: TextButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xff00AF87)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    )),
                                icon: Icon(
                                  Icons.reviews,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Write an review on TripAdvisor',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () async {
                                  String googleUrl =
                                      widget.restaurant.writeReview!;
                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 300,
                              child: TextButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xfff08e8d)),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32.0),
                                      ),
                                    )),
                                icon: Icon(
                                  Icons.map_outlined,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Find on Google Map',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () async {
                                  String googleUrl =
                                      'https://www.google.com/maps/search/?api=1&query=${widget.restaurant.name}';
                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]));
  }

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 100,
        width: MediaQuery.of(context).size.width / 1.5,
      );
}

Future<RestaurantGoogleModel> fetchRestaurantGoogle(String name) async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name%2Cplace_id%2Crating%2Cphotos%2Cuser_ratings_total&input=$name%20singapore&inputtype=textquery&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var place_id = "";
    var reference = "";
    var photoReference = "";
    var jsonString = jsonDecode(response.body);
    var rating =
        jsonDecode(response.body)["candidates"][0]["rating"].toString();
    var user_ratings_total = jsonDecode(response.body)["candidates"][0]
            ["user_ratings_total"]
        .toString();
    if (jsonString["candidates"][0].containsKey("photos")) {
      reference = jsonDecode(response.body)["candidates"][0]["photos"][0]
              ["photo_reference"]
          .toString();
      photoReference =
          "https://maps.googleapis.com/maps/api/place/photo?maxwidth=1200&" +
              "photo_reference=$reference" +
              "&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0";
    }
    return RestaurantGoogleModel.fromJson({
      "place_id": reference,
      "photo_reference": photoReference,
      "rating": rating,
      "user_ratings_total": user_ratings_total
    });
  } else {
    return RestaurantGoogleModel.fromJson({
      "place_id": "",
      "photo_reference": "",
      "rating": "",
      "user_ratings_total": ""
    });
  }
}

Widget buildStarRatingWidget(String rating) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RatingBar.builder(
        initialRating: double.parse(rating),
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemSize: 16.0,
        itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        ignoreGestures: true,
        onRatingUpdate: (double rating) {
          print(rating);
        },
      ),
    ],
  );
}

Widget buildHeroWidget(String name) {
  var result = fetchRestaurantGoogle(name);
  return FutureBuilder<RestaurantGoogleModel>(
    future: result,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return Hero(
          tag: snapshot.data!.place_id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(snapshot.data!.photo_reference != ""
                      ? snapshot.data!.photo_reference
                      : "https://png.pngtree.com/element_our/20190531/ourlarge/pngtree-flat-color-restaurant-shop-decoration-image_1273049.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.25), BlendMode.srcATop),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Hero(
          tag: "error",
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://png.pngtree.com/element_our/20190531/ourlarge/pngtree-flat-color-restaurant-shop-decoration-image_1273049.jpg"),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.25), BlendMode.srcATop),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }

      // By default, show a loading spinner.
      return Hero(
        tag: "default",
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://png.pngtree.com/element_our/20190531/ourlarge/pngtree-flat-color-restaurant-shop-decoration-image_1273049.jpg"),
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.25), BlendMode.srcATop),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    },
  );
}

class RestaurantGoogleModel {
  final String place_id;
  final String photo_reference;
  final String rating;
  final String user_ratings_total;

  const RestaurantGoogleModel({
    required this.place_id,
    required this.photo_reference,
    required this.rating,
    required this.user_ratings_total,
  });

  factory RestaurantGoogleModel.fromJson(Map<String, dynamic> json) {
    return RestaurantGoogleModel(
      place_id: json["place_id"],
      photo_reference: json["photo_reference"],
      rating: json['rating'],
      user_ratings_total: json['user_ratings_total'],
    );
  }
}
