import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikitude_flutter_app/widgets/shrimmingWidget.dart';

class PoiDetailsState extends State<PoiDetailsWidget> {
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

  AppBar? get appBar {
    if (!Platform.isIOS) {
      return null;
    }
    return new AppBar(
      title: Text("Landmark Details"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff85ccd8),
        appBar: this.appBar,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 50.0),
            child: Column(children: [
              SizedBox(height: 100),
              Text(title,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 2),
              Divider(
                color: Colors.white,
              ),
              SizedBox(height: 2),
              Text("Address: " + description),
              SizedBox(height: 10),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                    ),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://maps.googleapis.com/maps/api/staticmap?center=$title,Singapore&markers=$title,Singapore&zoom=14&size=400x400&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w",
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
                              'https://www.google.com/maps/search/?api=1&query=${title},%20Singapore';
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
                              'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=$latitude,$longitude';
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
          ),
        ));
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
