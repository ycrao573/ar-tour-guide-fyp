import 'dart:convert';

import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travelee/ar/arview.dart';
import 'package:travelee/ar/sample.dart';
import 'package:travelee/widgets/counter.dart';

class AchievementScreen extends StatefulWidget {
  final String icon;
  final String name;

  const AchievementScreen({Key? key, required this.icon, required this.name})
      : super(key: key);

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final PageController _pageController = PageController();
  var user = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Achievement")),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/achievement-bg.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.16), BlendMode.srcATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                SizedBox(
                  height: 76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38.0),
                    child: Image(
                      image: NetworkImage(widget.icon),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 15.0),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Counter(
                              color: Colors.pink,
                              number: 1,
                              title: "Countries",
                            ),
                            Counter(
                              color: Colors.teal,
                              number: 1,
                              title: "Cities",
                            ),
                            Counter(
                              color: Colors.amberAccent,
                              number: 3,
                              title: "Badges",
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 15.0),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            gotoSelectedPage(0);
                          },
                          child: Text('Achievements Badge'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            gotoSelectedPage(1);
                          },
                          child: Text('Cities Badge'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 220.0,
                      child: Container(child: new OrientationBuilder(
                          builder: (context, orientation) {
                        return PageView(
                          controller: _pageController,
                          children: <Widget>[
                            AchievedBadgeList(),
                            CitiesBadgeList(),
                          ],
                        );
                      })),
                    ),
                  ],
                ),
                Ink(
                  decoration: const ShapeDecoration(
                    color: Colors.lightBlue,
                    shape: CircleBorder(),
                  ),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 75,
                        icon: const Icon(Icons.view_in_ar_rounded),
                        color: Colors.red[200],
                        onPressed: () {
                          _pushArView(new Sample(
                            name: "Collect Rewards",
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
                      Text('Claim your rewards 🏆\n                  in AR!',
                          style: TextStyle(
                              color: Colors.red[100],
                              height: 1.4,
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ));
  }

  Future<void> _pushArView(Sample sample) async {
    WikitudeResponse supportingResponse =
        await _isDeviceSupporting(["object_tracking"]);
    WikitudeResponse permissionsResponse =
        await _requestARPermissions(["object_tracking"]);
    if (permissionsResponse.success && supportingResponse.success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ArViewWidget(sample: sample)),
      );
    } else {
      _showPermissionError(permissionsResponse.message);
    }
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

  gotoSelectedPage(int i) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AchievedBadgeList extends StatelessWidget {
  const AchievedBadgeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(6),
            sliver: SliverGrid.count(
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              crossAxisCount: 3,
              children: <Widget>[
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("rewards")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      var achievements = data["achievements"].toList();
                      var timestamp = achievements[0]["time"] as Timestamp;
                      final dateString = DateFormat('dd MMM, yyyy, hh:mm:ss')
                          .format(timestamp.toDate());
                      return GestureDetector(
                        onTap: () {
                          displayRewardDialog(context,
                              image: achievements[0]["image"],
                              name: achievements[0]["name"],
                              description: achievements[0]["description"],
                              time: dateString);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 60.0,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(achievements[0]["image"]),
                              radius: 38.0,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}' + snapshot.data!.toString());
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("rewards")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      var achievements = data["achievements"].toList();
                      var timestamp = achievements[1]["time"] as Timestamp;
                      final dateString = DateFormat('dd MMM, yyyy, hh:mm:ss')
                          .format(timestamp.toDate());
                      return GestureDetector(
                        onTap: () {
                          displayRewardDialog(context,
                              image: achievements[1]["image"],
                              name: achievements[1]["name"],
                              description: achievements[1]["description"],
                              time: dateString);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 60.0,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(achievements[1]["image"]),
                              radius: 38.0,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}' + snapshot.data!.toString());
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CitiesBadgeList extends StatelessWidget {
  const CitiesBadgeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(6),
            sliver: SliverGrid.count(
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              crossAxisCount: 3,
              children: <Widget>[
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("rewards")
                      .doc(FirebaseAuth.instance.currentUser!.email)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      var cities = data["cities"].toList();
                      var timestamp = cities[0]["time"] as Timestamp;
                      final dateString = DateFormat('dd MMM, yyyy, hh:mm:ss')
                          .format(timestamp.toDate());
                      return GestureDetector(
                        onTap: () {
                          displayRewardDialog(context,
                              image: cities[0]["image"],
                              name: cities[0]["name"],
                              description: cities[0]["description"],
                              time: dateString);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey[300],
                            radius: 60.0,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(cities[0]["image"]),
                              radius: 38.0,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                          '${snapshot.error}' + snapshot.data!.toString());
                    }
                    // By default, show a loading spinner.
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> displayRewardDialog(BuildContext context,
    {String image = "",
    String name = "",
    String description = "",
    String time = ""}) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.red[300],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(6, 12, 6, 3),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 60.0,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(image),
                          radius: 55.0,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        description + "!",
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 6.0),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ]),
              ),
            ));
      });
}
