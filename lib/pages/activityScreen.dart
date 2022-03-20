import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travelee/model/activityModel.dart';

class ActivityScreen extends StatefulWidget {
  final ActivityModel activity;

  const ActivityScreen({Key? key, required this.activity}) : super(key: key);

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
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
                child: Hero(
                  tag: widget.activity.imageUrl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image(
                      image: NetworkImage(widget.activity.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      iconSize: 30.0,
                      color: Colors.black,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ])
          ]),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.activity.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
                Container(
                  // adding padding
                  padding: const EdgeInsets.all(3.0),
                  // height should be fixed for vertical scrolling
                  height: 180.0,
                  decoration: BoxDecoration(
                    // adding borders around the widget
                    border: Border.all(
                      color: Colors.white12,
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
                        widget.activity.description,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonBar(
                  alignment: MainAxisAlignment.start,
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
                            'https://www.google.com/maps/search/?api=1&query=${widget.activity.latitude},${widget.activity.longitude}';
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
                            'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${widget.activity.latitude},${widget.activity.longitude}';
                        if (await canLaunch(googleUrl)) {
                          await launch(googleUrl);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ]));
  }
}
