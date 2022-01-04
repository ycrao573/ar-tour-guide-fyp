import 'dart:convert';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/theme.dart';
import 'recognize.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class VisionPage extends StatefulWidget {
  final String base64;
  final String type;

  const VisionPage({Key? key, required this.base64, required this.type})
      : super(key: key);

  @override
  _VisionPageState createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  var _recognizeProvider = new RecognizeProvider();

  @override
  Widget build(BuildContext context) {
    final Future<String> _callVisionAPI;
    if (widget.type == 'label')
      _callVisionAPI = _recognizeProvider
          .searchWebImageBestGuessedLabel(widget.base64)
          .then((e) => e.label.toString());
    else if (widget.type == 'landmark')
      _callVisionAPI = _recognizeProvider
          .searchLandmarkReturnInfo(widget.base64)
          .then((e) => e);
    else if (widget.type == 'mixed') {
      _callVisionAPI = _recognizeProvider
          .searchMixedReturnInfo(widget.base64)
          .then((e) => e);
    } else
      _callVisionAPI = _recognizeProvider
          .searchWebImageReturnInfo(widget.base64)
          .then((e) => e);

    return Container(
      child: FutureBuilder<String>(
        future: _callVisionAPI, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children = [];
          if (snapshot.hasData) {
            var response = jsonDecode(snapshot.data ?? "{}");
            if (response["type"] != null) {
              if (response["type"] == "web") {
                // "description": _entityName,
                // "fullMatchedImageUrl": _fullMatchedImageUrl,
                // "partialMatchedImageUrl": _partialMatchedImageUrl,
                // "matchedPageUrl": _matchedPageUrl,
                // "label": _label
                children = <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 320,
                        child: Card(
                          color: Colors.black.withOpacity(0.1),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Column(
                              children: [
                                Text(
                                  "We don't think this is a famous scenery 🤔\nBut here is our best guess: ",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.teal[50],
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Divider(color: Colors.cyan[300]),
                                ListTile(
                                  leading: Icon(Icons.image_search_outlined,
                                      color: Colors.cyanAccent[100],
                                      size: 36.0),
                                  title: Text(
                                    response["description"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    response["label"].toString(),
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                        color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5.0),
                                  child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: 260,
                                      ),
                                      child: (response["fullMatchedImageUrl"] ==
                                                  null &&
                                              response["partialMatchedImageUrl"] ==
                                                  null)
                                          ? Image.memory(
                                              base64Decode(widget.base64))
                                          : Image.network(
                                              (response["fullMatchedImageUrl"] !=
                                                      null)
                                                  ? response["fullMatchedImageUrl"]
                                                      .toString()
                                                  : response["partialMatchedImageUrl"]
                                                      .toString(),
                                              errorBuilder: (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) =>
                                                  Image.memory(
                                                      base64Decode(widget.base64)))),
                                ),
                                ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  children: [
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.map_outlined,
                                        color: Colors.cyanAccent[100],
                                      ),
                                      label: Text(
                                        'Find on Map',
                                        style: TextStyle(
                                            color: Colors.cyanAccent[100],
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onPressed: () async {
                                        String googleUrl =
                                            'https://www.google.com/maps/search/?api=1&query=${response["description"]}';
                                        if (await canLaunch(googleUrl)) {
                                          await launch(googleUrl);
                                        }
                                      },
                                    ),
                                    TextButton.icon(
                                      icon: Icon(
                                        Icons.read_more,
                                        color:
                                            (response["matchedPageUrl"] != "")
                                                ? Colors.cyanAccent[100]
                                                : Colors.grey,
                                      ),
                                      label: Text(
                                        'Read More',
                                        style: TextStyle(
                                            color:
                                                (response["matchedPageUrl"] !=
                                                        "")
                                                    ? Colors.cyanAccent[100]
                                                    : Colors.grey,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onPressed: () async {
                                        if (response["matchedPageUrl"] == "") {
                                          return null;
                                        }
                                        String googleUrl =
                                            response["matchedPageUrl"];
                                        if (await canLaunch(googleUrl)) {
                                          await launch(googleUrl);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // SizedBox(height: 50),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     (response["description"] != null)
                  //         ? Text(response["description"],
                  //             style: TextStyle(
                  //                 fontSize: 24.0, fontWeight: FontWeight.bold))
                  //         : Text("Not found"),
                  //     SizedBox(height: 10),
                  //     (response["fullMatchedImageUrl"] != null)
                  //         ? Image.network(response["fullMatchedImageUrl"])
                  //         : ((response["partialMatchedImageUrl"] != null)
                  //             ? Image.network(
                  //                 response["partialMatchedImageUrl"])
                  //             : Text("")),
                  //     (response["label"] != null)
                  //         ? Text(response["description"],
                  //             style: myTheme.textTheme.caption)
                  //         : Text("label"),
                  //     SizedBox(height: 10),
                  //     (response["matchedPageUrl"] != null)
                  //         ? ElevatedButton(
                  //             onPressed: () =>
                  //                 launch(response["matchedPageUrl"]),
                  //             child: new Text('Click here to know more'),
                  //           )
                  //         : Text(""),
                  //   ],
                  // )
                ];
              } else if (response["type"] == "landmark") {
                // "landmarkName": _landmarkName,
                // "latitude": _latitude,
                // "longitude": _longitude,
                if (response["landmarkName"] == null) {
                  children = <Widget>[
                    SizedBox(height: 50),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 250),
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 72,
                        ),
                        Text(
                          'We did not find any related information. 😕',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 16.0),
                        )
                      ],
                    )
                  ];
                } else {
                  children = <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 320,
                          child: Card(
                            color: Colors.black.withOpacity(0.1),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.image_search_outlined,
                                        color: Colors.cyanAccent[100],
                                        size: 36.0),
                                    title: Text(
                                      response["landmarkName"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      'Tourist Attraction',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.8)),
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxHeight: 260,
                                        ),
                                        child: Image.network(
                                            "https://maps.googleapis.com/maps/api/staticmap?center=${response["landmarkName"]}&markers=${response["landmarkName"]}&zoom=14&size=400x400&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w")),
                                  ),
                                  ButtonBar(
                                    alignment: MainAxisAlignment.start,
                                    children: [
                                      TextButton.icon(
                                        icon: Icon(
                                          Icons.map_outlined,
                                          color: Colors.cyanAccent[100],
                                        ),
                                        label: Text(
                                          'Show on Map',
                                          style: TextStyle(
                                              color: Colors.cyanAccent[100],
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () async {
                                          String googleUrl =
                                              'https://www.google.com/maps/search/?api=1&query=${response["landmarkName"]}';
                                          if (await canLaunch(googleUrl)) {
                                            await launch(googleUrl);
                                          }
                                        },
                                      ),
                                      TextButton.icon(
                                        icon: Icon(
                                          Icons.panorama_photosphere_outlined,
                                          color: Colors.cyanAccent[100],
                                        ),
                                        label: Text(
                                          'Street View',
                                          style: TextStyle(
                                              color: Colors.cyanAccent[100],
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () async {
                                          String googleUrl =
                                              'https://www.google.com/maps/@?api=1&map_action=pano&viewpoint=${response["latitude"]},${response["longitude"]}';
                                          if (await canLaunch(googleUrl)) {
                                            await launch(googleUrl);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 50),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     (response["landmarkName"] != null)
                    //         ? Text(response["landmarkName"],
                    //             style: TextStyle(
                    //                 fontSize: 24.0,
                    //                 fontWeight: FontWeight.bold))
                    //         : Text("Not found"),
                    //     SizedBox(height: 10),
                    //     ((response["landmarkName"] != null) &&
                    //             (response["latitude"] != null))
                    //         ? Image.network(
                    //             "https://maps.googleapis.com/maps/api/staticmap?center=${response["latitude"]},${response["longitude"]}&markers=${response["latitude"]},${response["longitude"]}&zoom=14&size=400x400&key=AIzaSyCcuOYBEHg6xRvC-NU-ScSPH01aDndnV_w")
                    //         : Image.memory(base64Decode(widget.base64)),
                    //     SizedBox(height: 10),
                    //     (response["latitude"] != null)
                    //         ? Text(
                    //             "Latitude: " + response["latitude"].toString())
                    //         : Text("Not found"),
                    //     SizedBox(height: 10),
                    //     (response["longitude"] != null)
                    //         ? Text("Longitude: " +
                    //             response["longitude"].toString())
                    //         : Text("Not found"),
                    //     SizedBox(height: 10),
                    //   ],
                    // )
                  ];
                }
              }
            } else {
              children = <Widget>[
                SizedBox(height: 250),
                const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 60,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Text('Result: ${snapshot.data}',
                            style: TextStyle(color: Colors.white)),
                      ],
                    ))
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              SizedBox(
                width: 250,
                height: 250,
                child: Card(
                  color: Colors.white.withOpacity(0.5),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                                'We did not find any related information. 😕',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ];
          } else {
            children = <Widget>[
              SizedBox(
                width: 250,
                height: 250,
                child: Card(
                  color: Colors.white.withOpacity(0.5),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(
                                color: Colors.cyan[200]),
                            width: 64,
                            height: 64,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 18),
                            child:
                                Text('Hold on, we are finding this place... 🏃',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                    )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ];
          }
          return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: Image.memory(base64Decode(widget.base64)).image,
                      fit: BoxFit.cover)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: children,
                ),
              ));
          // },

          //   return Center(
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: children,
          //     ),
          //   );
        },
      ),
    );
  }
}
