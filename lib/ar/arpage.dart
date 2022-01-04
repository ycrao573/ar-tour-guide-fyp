import 'dart:ui';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'arview.dart';
import 'sample.dart';
import '../theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

class ArPage extends StatefulWidget {
  const ArPage({Key? key}) : super(key: key);

  @override
  _ArPageState createState() => _ArPageState();
}

class _ArPageState extends State<ArPage> {
  List<String> features = ["object_tracking"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ElevatedButton(
              //   child: Text(AppLocalizations.of(context)!.ar_object),
              //   onPressed: () {
              //     _pushArView(new Sample(
              //       name: AppLocalizations.of(context)!.ar_object,
              //       path: 'experience/index.html',
              //       requiredFeatures: ["object_tracking"],
              //       startupConfiguration: new StartupConfiguration(
              //           cameraPosition: CameraPosition.BACK,
              //           cameraResolution: CameraResolution.AUTO,
              //           cameraFocusMode: CameraFocusMode.CONTINUOUS),
              //       requiredExtensions: [],
              //     ));
              //   },
              // ),
              // SizedBox(height: 9.0),
              // ElevatedButton(
              //   child: Text(AppLocalizations.of(context)!.ar_poi),
              //   onPressed: () {
              //     _pushArView(new Sample(
              //       name: AppLocalizations.of(context)!.ar_poi,
              //       path: 'poi_experience/index.html',
              //       requiredFeatures: ["geo"],
              //       startupConfiguration: new StartupConfiguration(
              //           cameraPosition: CameraPosition.BACK,
              //           cameraResolution: CameraResolution.AUTO,
              //           cameraFocusMode: CameraFocusMode.CONTINUOUS),
              //       requiredExtensions: ["native_detail"],
              //     ));
              //   },
              // ),
              SizedBox(height: 9.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    padding: EdgeInsets.all(4.0),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    elevation: 8.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/mrt.jpg'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(36, 50, 36, 50),
                          child: Text("MRT",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0,
                                  color: Colors.yellow)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _pushArView(new Sample(
                        name: "MRT",
                        path: 'mrt/index.html',
                        requiredFeatures: ["geo"],
                        startupConfiguration: new StartupConfiguration(
                            cameraPosition: CameraPosition.BACK,
                            cameraResolution: CameraResolution.AUTO,
                            cameraFocusMode: CameraFocusMode.CONTINUOUS),
                        requiredExtensions: ["native_detail"],
                      ));
                    },
                  ),
                  MaterialButton(
                    padding: EdgeInsets.all(8.0),
                    textColor: Colors.white,
                    splashColor: Colors.greenAccent,
                    elevation: 8.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/mall.jpg'),
                              fit: BoxFit.cover),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 50, 27, 50),
                          child: Text("MALL",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32.0,
                                  color: Colors.yellow)),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _pushArView(new Sample(
                        name: "Mall",
                        path: 'mall/index.html',
                        requiredFeatures: ["geo"],
                        startupConfiguration: new StartupConfiguration(
                            cameraPosition: CameraPosition.BACK,
                            cameraResolution: CameraResolution.AUTO,
                            cameraFocusMode: CameraFocusMode.CONTINUOUS),
                        requiredExtensions: ["native_detail"],
                      ));
                    },
                  ),
                ],
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
