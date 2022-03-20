import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:travelee/ar/poiDetails.dart';
import 'poi.dart';

import 'sample.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:path_provider/path_provider.dart';

import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';

class ArViewState extends State<ArViewWidget> with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey =
      "dQ/qjuElygmpZtRtFPWMjZSWE3mogM4IaeKPPszBY0J72xYASiMveZ3tNVO+vpqknCpwgTii/HQuX1o72OLxom+SNCMfdVx4AuOI8WWLC9YuPjEeLf03Iu2Dvn5OANgzCgm4Yed1j5yDEMnK9PYlIYsCRiJv5UmGBZqzDRIfQNRTYWx0ZWRfX+GXsk7p88JHLCvbioaZzU6MAM8kZnF9mKA9zxzI/2AIyGo9OkjPjx+jNJRk5KOMYeghaBkqjKzi/dwt+SshdMjF9O0GAhnVoYnUkDmVwGlBG0eC3lV9ptT1+dkObAMYUovGznR2AI35G66ez3DQeZZYJhGUtueWLmVjs8BCripCzymbLRuy/wzlo2AjPJ7gSsBDZ1g1Upo1iUeBeqlUs2yCO8GI66EnU5BOHPiWgcELB5MpYxajYX4dkP7ZEdmqIqeEnlC2yKzkg8/hr/Tm57pvD02Om7Aszh09Q5VDTbkUV/yqvTi1y/c7R5fXr+agq27VQEGE6SvB7xE7CnNbUDFF8pEBCFrVzIHIP/cH3T/Al/L/6RDgeu8HObzktPs+nC8HWp+qYzKdm5ft4tdrR9tWu2hNV1BdqlvLFVT2QlKou6pOJAFOrYXZH0xEmCnKua83Q0g8n7zuYrT4tN5HJVbgXyA6Rz/zO/1DB44JzPjWGqJ7/d+zHrJywq350aoSAoJpyZL3SvAvT2k5Wq9US1EWb2vXUqWDFg8FGoNDWe7Cxu4l4HELufCRVVCQI7r+xSGP9eA4vj134/VYN7aJ/cE+AZojRx9W10pDNO52KAncz0nlRwOPzxsXfe702UJSRej5TUoAs3xEwjCogwPDiRgJIteDPKk50A==";
  Sample sample;
  String loadPath = "";
  bool loadFailed = false;

  ArViewState({required this.sample}) {
    loadPath = "samples/" + this.sample.path;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    architectWidget = new ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: sample.startupConfiguration,
      features: sample.requiredFeatures,
    );

    Wakelock.enable();
  }

  @override
  void dispose() {
    this.architectWidget.pause();
    this.architectWidget.destroy();
    WidgetsBinding.instance!.removeObserver(this);

    Wakelock.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        this.architectWidget.pause();
        break;
      case AppLifecycleState.resumed:
        this.architectWidget.resume();
        break;
      default:
    }
  }

  void show_Custom_Flushbar(BuildContext context) {
    Flushbar(
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(16),
      icon: Icon(Icons.warning_amber, color: Colors.redAccent[700], size: 30.0),
      backgroundGradient: LinearGradient(
        colors: [Color(0xeef08e8d), Color(0xd0ee8d8c)],
        stops: [0.6, 1],
      ),
      borderRadius: BorderRadius.circular(8),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      isDismissible: true,
      // All of the previous Flushbars could be dismissed by swiping down
      // now we want to swipe to the sides
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      // The default curve is Curves.easeOut
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      title: 'Caution!',
      message:
          "For you safety, please do not look at screens while walking, especially when crossing the street",
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Live View - " + sample.name),
          backgroundColor: Colors.red.withOpacity(.5),
          elevation: 0),
      body: Container(
        child: architectWidget,
      ),
    );
  }

  Future<void> onLoadSuccess() async {
    loadFailed = false;
    show_Custom_Flushbar(context);
  }

  Future<void> onLoadFailed(String error) async {
    loadFailed = true;
    this.architectWidget.showAlert("Failed to load Architect World", error);
  }

  Future<void> onJSONObjectReceived(Map<String, dynamic> jsonObject) async {
    if (jsonObject["action"] != null) {
      switch (jsonObject["action"]) {
        case "present_poi_details":
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PoiDetailsWidget(
                      category: jsonObject["category"],
                      id: jsonObject["id"],
                      title: jsonObject["title"],
                      description: jsonObject["description"],
                      latitude: jsonObject["latitude"],
                      longitude: jsonObject["longitude"],
                    )),
          );
          break;
        case "present_landmark_poi_details":
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LandmarkPoiDetailsWidget(
                      category: jsonObject["category"],
                      id: jsonObject["id"],
                      title: jsonObject["title"],
                      description: jsonObject["description"],
                      latitude: jsonObject["latitude"].toString(),
                      longitude: jsonObject["longitude"].toString(),
                      officiallink: jsonObject["officiallink"],
                      hyperlink: jsonObject["hyperlink"],
                      photourl: jsonObject["photourl"],
                      openinghours: jsonObject["openinghours"],
                      urlpath: jsonObject["urlpath"],
                      address: jsonObject["address"],
                      imagetext: jsonObject["imagetext"],
                    )),
          );
          break;
      }
    }
  }

  Future<void> onArchitectWidgetCreated() async {
    this.architectWidget.load(loadPath, onLoadSuccess, onLoadFailed);
    this.architectWidget.resume();

    if ((sample.requiredExtensions.contains("screenshot") ||
        sample.requiredExtensions.contains("save_load_instant_target") ||
        sample.requiredExtensions.contains("native_detail"))) {
      this.architectWidget.setJSONObjectReceivedCallback(onJSONObjectReceived);
    }
  }
}

class ArViewWidget extends StatefulWidget {
  final Sample sample;

  ArViewWidget({
    Key? key,
    required this.sample,
  });

  @override
  ArViewState createState() => new ArViewState(sample: sample);
}
