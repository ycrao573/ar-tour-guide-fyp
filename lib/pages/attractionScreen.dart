import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikitude_flutter_app/model/attractionModel.dart';
import 'package:wikitude_flutter_app/widgets/shrimmingWidget.dart';

class AttractionScreen extends StatefulWidget {
  final AttractionModel attraction;

  const AttractionScreen({Key? key, required this.attraction})
      : super(key: key);

  @override
  _AttractionScreenState createState() => _AttractionScreenState();
}

class _AttractionScreenState extends State<AttractionScreen> {
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
                  child: Hero(
                    tag: widget.attraction.photourl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.attraction.photourl),
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.35),
                                BlendMode.srcATop),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.attraction.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.0),
                      buildStarRatingWidget(widget.attraction.name),
                      SizedBox(height: 5.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.pin_drop,
                            size: 14.0,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.0),
                          (widget.attraction.postalcode == "")
                              ? SizedBox(
                                  width: 280,
                                  child: Text(
                                    widget.attraction.address + "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 300,
                                  child: Text(
                                      widget.attraction.address +
                                          "," +
                                          widget.attraction.postalcode,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13.0,
                                      )),
                                )
                        ],
                      ),
                      SizedBox(height: 5.0),
                      SizedBox(
                        width: 326,
                        child: Text(
                          widget.attraction.imageText,
                          maxLines: 5,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
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
                    Row(
                      children: <Widget>[
                        TextButton.icon(
                          icon: Icon(Icons.open_in_new),
                          label: Text("Official Website"),
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.teal[50])),
                          onPressed: () async {
                            String url = widget.attraction.hyperlink;
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                        ),
                      ],
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
                      Container(
                        // adding padding
                        padding: const EdgeInsets.all(3.0),
                        // height should be fixed for vertical scrolling
                        height: 68.0,
                        decoration: BoxDecoration(
                          // adding borders around the widget
                          border: Border.all(
                            color: Colors.white10,
                            width: 1.0,
                          ),
                        ),
                        // SingleChildScrollView should be
                        // wrapped in an Expanded Widget
                        child: Expanded(
                          // SingleChildScrollView contains a
                          // single child which is scrollable
                          child: SingleChildScrollView(
                            // for Vertical scrolling
                            scrollDirection: Axis.vertical,
                            child: Text(
                              widget.attraction.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Text(
                        "Opening Hours: " + widget.attraction.openingHours,
                        maxLines: 5,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                        ),
                      ),
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
                                  "https://maps.googleapis.com/maps/api/staticmap?center=${widget.attraction.name + ',Singapore'}&markers=${widget.attraction.name + ',Singapore'}&zoom=14&size=500x250&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w",
                              placeholder: (context, url) =>
                                  buildAddressShimmer(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )),
                      Divider(
                        color: Colors.white,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
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
                            String googleUrl = widget.attraction.field1;
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
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xfff08e8d))),
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
                                      'https://www.google.com/maps/search/?api=1&query=${widget.attraction.name}';
                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                },
                              ),
                              TextButton.icon(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xfff08e8d))),
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
                                      'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${widget.attraction.name}';
                                  if (await canLaunch(googleUrl)) {
                                    await launch(googleUrl);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
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
        height: 170,
        width: MediaQuery.of(context).size.width,
      );

  Widget buildStarRatingWidget(String name) {
    var result = fetchRatings(name);
    return FutureBuilder<LandmarkRating>(
      future: result,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RatingBar.builder(
                initialRating: double.parse(snapshot.data!.rating),
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
              SizedBox(width: 8.0),
              Text(snapshot.data!.rating,
                  style: TextStyle(color: Colors.white)),
              SizedBox(width: 5.0),
              Text("(" + snapshot.data!.user_ratings_total + ")",
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 2),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return SizedBox();
      },
    );
  }

  Future<LandmarkRating> fetchRatings(String name) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=name%2Cplace_id%2Crating%2Cphotos%2Cuser_ratings_total&input=$name%20singapore&inputtype=textquery&key=AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonString = jsonDecode(response.body);
      var rating =
          jsonDecode(response.body)["candidates"][0]["rating"].toString();
      var user_ratings_total = jsonDecode(response.body)["candidates"][0]
              ["user_ratings_total"]
          .toString();
      return LandmarkRating.fromJson(
          {"rating": rating, "user_ratings_total": user_ratings_total});
    } else {
      return LandmarkRating.fromJson({"rating": "", "user_ratings_total": ""});
    }
  }
}

class LandmarkRating {
  final String rating;
  final String user_ratings_total;

  const LandmarkRating({
    required this.rating,
    required this.user_ratings_total,
  });

  factory LandmarkRating.fromJson(Map<String, dynamic> json) {
    return LandmarkRating(
      rating: json['rating'],
      user_ratings_total: json['user_ratings_total'],
    );
  }
}
