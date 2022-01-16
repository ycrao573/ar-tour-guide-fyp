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
      backgroundColor: Color(0x44a2d7e2),
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
              Center(
                child: Text("Live View - AR Experience",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    )),
              ),
              Center(
                child: SizedBox(
                  width: 300.0,
                  child: Text(
                      "\nWe use Augmented Reality (AR) to help you discover interesting places in your neighborhood. You can simply choose a category below and explore potential places nearby in 'AR' fashion. \nClick the location pin inside for more information!",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      )),
                ),
              ),
              SizedBox(height: 40.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.subway_outlined),
                          color: Colors.white,
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
                      ),
                      SizedBox(height: 10.0),
                      Text('MRT Station'),
                    ],
                  ),
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.shopping_cart),
                          color: Colors.white,
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
                      ),
                      SizedBox(height: 10.0),
                      Text('Shopping Mall'),
                    ],
                  ),
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.landscape),
                          color: Colors.white,
                          onPressed: () {
                            _pushArView(new Sample(
                              name: "Landmark",
                              path: 'landmark/index.html',
                              requiredFeatures: ["geo"],
                              startupConfiguration: new StartupConfiguration(
                                  cameraPosition: CameraPosition.BACK,
                                  cameraResolution: CameraResolution.AUTO,
                                  cameraFocusMode: CameraFocusMode.CONTINUOUS),
                              requiredExtensions: ["native_detail"],
                            ));
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Landmark'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.restaurant),
                          color: Colors.white,
                          onPressed: () {
                            _pushArView(new Sample(
                              name: "Restaurant",
                              path: 'landmark/index.html',
                              requiredFeatures: ["geo"],
                              startupConfiguration: new StartupConfiguration(
                                  cameraPosition: CameraPosition.BACK,
                                  cameraResolution: CameraResolution.AUTO,
                                  cameraFocusMode: CameraFocusMode.CONTINUOUS),
                              requiredExtensions: ["native_detail"],
                            ));
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Restaurant'),
                    ],
                  ),
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.hotel_outlined),
                          color: Colors.white,
                          onPressed: () {
                            _pushArView(new Sample(
                              name: "Hotel",
                              path: 'landmark/index.html',
                              requiredFeatures: ["geo"],
                              startupConfiguration: new StartupConfiguration(
                                  cameraPosition: CameraPosition.BACK,
                                  cameraResolution: CameraResolution.AUTO,
                                  cameraFocusMode: CameraFocusMode.CONTINUOUS),
                              requiredExtensions: ["native_detail"],
                            ));
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Hotel'),
                    ],
                  ),
                  Column(
                    children: [
                      Ink(
                        padding: EdgeInsets.all(4.0),
                        decoration: ShapeDecoration(
                          color: Colors.redAccent[100],
                          shape: CircleBorder(),
                        ),
                        child: IconButton(
                          iconSize: 36.0,
                          icon: const Icon(Icons.park_outlined),
                          color: Colors.white,
                          onPressed: () {
                            _pushArView(new Sample(
                              name: "Park",
                              path: 'landmark/index.html',
                              requiredFeatures: ["geo"],
                              startupConfiguration: new StartupConfiguration(
                                  cameraPosition: CameraPosition.BACK,
                                  cameraResolution: CameraResolution.AUTO,
                                  cameraFocusMode: CameraFocusMode.CONTINUOUS),
                              requiredExtensions: ["native_detail"],
                            ));
                          },
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text('Park'),
                    ],
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
