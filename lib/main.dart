import 'dart:ui';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'arview.dart';
import 'sample.dart';
import 'theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Travel App Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
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
        title: const Text('AR Tour Guide Demo'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                child: Text('Object Detection Demo',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  _pushArView(new Sample(
                    name: 'Object Detection',
                    path: 'experience/index.html',
                    requiredFeatures: ["object_tracking"],
                    startupConfiguration: new StartupConfiguration(
                        cameraPosition: CameraPosition.BACK,
                        cameraResolution: CameraResolution.AUTO,
                        cameraFocusMode: CameraFocusMode.CONTINUOUS),
                    requiredExtensions: [],
                  ));
                },
              ),
              SizedBox(height: 9.0),
              ElevatedButton(
                child: Text('Poi Experience',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  _pushArView(new Sample(
                    name: 'Provide Details and Range',
                    path: 'poi_experience/index.html',
                    requiredFeatures: ["geo"],
                    startupConfiguration: new StartupConfiguration(
                        cameraPosition: CameraPosition.BACK,
                        cameraResolution: CameraResolution.AUTO,
                        cameraFocusMode: CameraFocusMode.CONTINUOUS),
                    requiredExtensions: [],
                  ));
                },
              ),
            ],
          ),
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

  Future<void> _pushArView(Sample sample) async {
    WikitudeResponse supportingResponse = await _isDeviceSupporting(features);
    WikitudeResponse permissionsResponse =
        await _requestARPermissions(features);
    if (permissionsResponse.success && supportingResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArViewWidget(sample: sample)),
      );
    } else {
      _showPermissionError(permissionsResponse.message);
    }
  }
}
