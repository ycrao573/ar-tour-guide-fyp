import 'dart:ui';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wikitude_flutter_app/widgets/locationSharingScreen.dart';
import 'package:wikitude_flutter_app/widgets/mapScreen.dart';
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ar_bg.png"),
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.1), BlendMode.srcATop),
            fit: BoxFit.cover,
          ),
        ),
        child: new BackdropFilter(
          filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
          child: Container(
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
                  SizedBox(height: 242),
                  Center(
                    child: Text("Live View - AR Experience",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 24.0,
                          height: 1.4,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Center(
                    child: SizedBox(
                      width: 311.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            "\nWe use AR to help you discover interesting places around. Simply choose a category below and explore 'treasures' nearby in AR fashion. Click virtual signboard for more information!",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Poppins',
                              fontSize: 14.5,
                              height: 1.38,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: SizedBox(
                  //     width: 311.0,
                  //     child: Align(
                  //       alignment: Alignment.center,
                  //       child: Text(
                  //           "You can now customize your own places, which even includes your friend's location!",
                  //           style: TextStyle(
                  //             color: Colors.red[800],
                  //             fontFamily: 'Poppins',
                  //             fontSize: 14,
                  //             height: 1.4,
                  //             fontWeight: FontWeight.w500,
                  //           )),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      child: Container(
                        color: Colors.black54,
                        child: Column(
                          children: [
                            SizedBox(height: 5.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Ink(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: ShapeDecoration(
                                        color: Colors.redAccent[100],
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        iconSize: 36.0,
                                        icon: const Icon(Icons.subway_outlined),
                                        color: Colors.red[200],
                                        onPressed: () {
                                          _pushArView(new Sample(
                                            name: "MRT",
                                            path: 'mrt/index.html',
                                            requiredFeatures: ["geo"],
                                            startupConfiguration:
                                                new StartupConfiguration(
                                                    cameraPosition:
                                                        CameraPosition.BACK,
                                                    cameraResolution:
                                                        CameraResolution.AUTO,
                                                    cameraFocusMode:
                                                        CameraFocusMode
                                                            .CONTINUOUS),
                                            requiredExtensions: [
                                              "native_detail"
                                            ],
                                          ));
                                        },
                                      ),
                                    ),
                                    Text('MRT Station',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.5)),
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
                                        color: Colors.red[200],
                                        onPressed: () {
                                          _pushArView(new Sample(
                                            name: "Mall",
                                            path: 'mall/index.html',
                                            requiredFeatures: ["geo"],
                                            startupConfiguration:
                                                new StartupConfiguration(
                                                    cameraPosition:
                                                        CameraPosition.BACK,
                                                    cameraResolution:
                                                        CameraResolution.AUTO,
                                                    cameraFocusMode:
                                                        CameraFocusMode
                                                            .CONTINUOUS),
                                            requiredExtensions: [
                                              "native_detail"
                                            ],
                                          ));
                                        },
                                      ),
                                    ),
                                    Text('Mall',
                                        style: TextStyle(color: Colors.white)),
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
                                        color: Colors.red[200],
                                        onPressed: () {
                                          _pushArView(new Sample(
                                            name: "Landmark",
                                            path: 'landmark/index.html',
                                            requiredFeatures: ["geo"],
                                            startupConfiguration:
                                                new StartupConfiguration(
                                                    cameraPosition:
                                                        CameraPosition.BACK,
                                                    cameraResolution:
                                                        CameraResolution.AUTO,
                                                    cameraFocusMode:
                                                        CameraFocusMode
                                                            .CONTINUOUS),
                                            requiredExtensions: [
                                              "native_detail"
                                            ],
                                          ));
                                        },
                                      ),
                                    ),
                                    Text('Landmark',
                                        style: TextStyle(color: Colors.white)),
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
                                        color: Colors.orange[400],
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        iconSize: 28.0,
                                        icon: FaIcon(FontAwesomeIcons.trophy),
                                        color: Colors.orange[400],
                                        onPressed: () {
                                          _pushArView(new Sample(
                                            name: "Collect Rewards",
                                            path: 'experience/index.html',
                                            requiredFeatures: [
                                              "object_tracking"
                                            ],
                                            startupConfiguration:
                                                new StartupConfiguration(
                                                    cameraPosition:
                                                        CameraPosition.BACK,
                                                    cameraResolution:
                                                        CameraResolution.AUTO,
                                                    cameraFocusMode:
                                                        CameraFocusMode
                                                            .CONTINUOUS),
                                            requiredExtensions: [],
                                          ));
                                        },
                                      ),
                                    ),
                                    Text('Rewards',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Ink(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[400],
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        iconSize: 36.0,
                                        icon: const Icon(Icons.people_alt),
                                        color: Colors.orange[400],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LocationSharingScreen()));
                                        },
                                      ),
                                    ),
                                    Text('Friend',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Ink(
                                      padding: EdgeInsets.all(4.0),
                                      decoration: ShapeDecoration(
                                        color: Colors.grey[400],
                                        shape: CircleBorder(),
                                      ),
                                      child: IconButton(
                                        iconSize: 36.0,
                                        icon:
                                            const Icon(Icons.pin_drop_rounded),
                                        color: Colors.orange[400],
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MapScreen()));
                                        },
                                      ),
                                    ),
                                    Text(
                                      'Customised',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
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
