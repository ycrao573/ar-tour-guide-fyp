import 'dart:ui';

import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:augmented_reality_plugin_wikitude/architect_widget.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:wakelock/wakelock.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  List<String> features = ["object_tracking"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Examples'),
      ),
      body: Container(
        decoration: BoxDecoration(color: Color(0xffdddddd)),
        child: TextButton(
          child: Text('Open Your Camera'),
          onPressed: () {
            _pushArView();
          },
        ),
      ),
    );
  }

  Future<WikitudeResponse> _isDeviceSupporting(List<String> features) async {
    return await WikitudePlugin.isDeviceSupporting(features);
  }

  Future<WikitudeResponse> _requestARPermissions(List<String> features) async {
    return await WikitudePlugin.requestARPermissions(features);
  }

  void _showPermissionError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Permissions required"),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Open settings'),
                onPressed: () {
                  Navigator.of(context).pop();
                  WikitudePlugin.openAppSettings();
                },
              )
            ],
          );
        });
  }

  Future<void> _pushArView() async {
    WikitudeResponse supportingResponse = await _isDeviceSupporting(features);
    WikitudeResponse permissionsResponse =
        await _requestARPermissions(features);
    if (permissionsResponse.success && supportingResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArViewWidget()),
      );
    } else {
      _showPermissionError(permissionsResponse.message);
    }
  }
}

class ArViewState extends State<ArViewWidget> with WidgetsBindingObserver {
  late ArchitectWidget architectWidget;
  String wikitudeTrialLicenseKey = "dQ/qjuElygmpZtRtFPWMjZSWE3mogM4IaeKPPszBY0J72xYASiMveZ3tNVO+vpqknCpwgTii/HQuX1o72OLxom+SNCMfdVx4AuOI8WWLC9YuPjEeLf03Iu2Dvn5OANgzCgm4Yed1j5yDEMnK9PYlIYsCRiJv5UmGBZqzDRIfQNRTYWx0ZWRfX+GXsk7p88JHLCvbioaZzU6MAM8kZnF9mKA9zxzI/2AIyGo9OkjPjx+jNJRk5KOMYeghaBkqjKzi/dwt+SshdMjF9O0GAhnVoYnUkDmVwGlBG0eC3lV9ptT1+dkObAMYUovGznR2AI35G66ez3DQeZZYJhGUtueWLmVjs8BCripCzymbLRuy/wzlo2AjPJ7gSsBDZ1g1Upo1iUeBeqlUs2yCO8GI66EnU5BOHPiWgcELB5MpYxajYX4dkP7ZEdmqIqeEnlC2yKzkg8/hr/Tm57pvD02Om7Aszh09Q5VDTbkUV/yqvTi1y/c7R5fXr+agq27VQEGE6SvB7xE7CnNbUDFF8pEBCFrVzIHIP/cH3T/Al/L/6RDgeu8HObzktPs+nC8HWp+qYzKdm5ft4tdrR9tWu2hNV1BdqlvLFVT2QlKou6pOJAFOrYXZH0xEmCnKua83Q0g8n7zuYrT4tN5HJVbgXyA6Rz/zO/1DB44JzPjWGqJ7/d+zHrJywq350aoSAoJpyZL3SvAvT2k5Wq9US1EWb2vXUqWDFg8FGoNDWe7Cxu4l4HELufCRVVCQI7r+xSGP9eA4vj134/VYN7aJ/cE+AZojRx9W10pDNO52KAncz0nlRwOPzxsXfe702UJSRej5TUoAs3xEwjCogwPDiRgJIteDPKk50A==";
  String loadPath = "samples/experience/index.html";
  bool loadFailed = false;

  StartupConfiguration startupConfiguration = new StartupConfiguration(
      cameraPosition: CameraPosition.BACK,
      cameraResolution: CameraResolution.AUTO,
      cameraFocusMode: CameraFocusMode.CONTINUOUS);
  List<String> features = ["object_tracking"];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    architectWidget = new ArchitectWidget(
      onArchitectWidgetCreated: onArchitectWidgetCreated,
      licenseKey: wikitudeTrialLicenseKey,
      startupConfiguration: startupConfiguration,
      features: features,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('test 1')),
      body: Container(
          decoration: BoxDecoration(color: Colors.black),
          child: architectWidget),
    );
  }

  Future<void> onLoadSuccess() async {
    loadFailed = false;
  }

  Future<void> onLoadFailed(String error) async {
    loadFailed = true;
    this.architectWidget.showAlert("Failed to load Architect World", error);
  }

  Future<void> onArchitectWidgetCreated() async {
    this.architectWidget.load(loadPath, onLoadSuccess, onLoadFailed);
    this.architectWidget.resume();
  }
}

class ArViewWidget extends StatefulWidget {
  ArViewWidget({
    Key? key,
  });

  @override
  ArViewState createState() => new ArViewState();
}
