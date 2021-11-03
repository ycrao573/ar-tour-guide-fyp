import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/theme.dart';
import 'recognize.dart';
import 'dart:convert';

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
    else
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
                  SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (response["description"] != null)
                          ? Text(response["description"],
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold))
                          : Text("Not found"),
                      SizedBox(height: 10),
                      (response["fullMatchedImageUrl"] != null)
                          ? Image.network(response["fullMatchedImageUrl"])
                          : ((response["partialMatchedImageUrl"] != null)
                              ? Image.network(
                                  response["partialMatchedImageUrl"])
                              : Text("")),
                      (response["label"] != null)
                          ? Text(response["description"],
                              style: myTheme.textTheme.caption)
                          : Text("label"),
                      SizedBox(height: 10),
                      (response["matchedPageUrl"] != null)
                          ? ElevatedButton(
                              onPressed: () =>
                                  launch(response["matchedPageUrl"]),
                              child: new Text('Click here to know more'),
                            )
                          : Text(""),
                    ],
                  )
                ];
              } else if (response["type"] == "landmark") {
                // "landmarkName": _landmarkName,
                // "latitude": _latitude,
                // "longitude": _longitude
                children = <Widget>[
                  SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (response["landmarkName"] != null)
                          ? Text(response["landmarkName"],
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold))
                          : Text("Not found"),
                      SizedBox(height: 10),
                      Image.memory(base64Decode(widget.base64)),
                      SizedBox(height: 10),
                      (response["latitude"] != null)
                          ? Text("Latitude: " + response["latitude"].toString())
                          : Text("Not found"),
                      SizedBox(height: 10),
                      (response["longitude"] != null)
                          ? Text(
                              "Longitude: " + response["longitude"].toString())
                          : Text("Not found"),
                      SizedBox(height: 10),
                    ],
                  )
                ];
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
                            style: TextStyle(color: Colors.black)),
                      ],
                    ))
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
