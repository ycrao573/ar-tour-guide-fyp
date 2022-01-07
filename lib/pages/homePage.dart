import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wikitude_flutter_app/ar/arpage.dart';
import 'package:wikitude_flutter_app/l10n/l10n.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wikitude_flutter_app/model/activityModel.dart';
import 'package:wikitude_flutter_app/model/attractionModel.dart';
import 'package:wikitude_flutter_app/model/googleUserModel.dart';
import 'package:wikitude_flutter_app/model/userModel.dart';
import 'package:wikitude_flutter_app/pages/activityScreen.dart';
import 'package:wikitude_flutter_app/pages/attractionScreen.dart';
import 'package:wikitude_flutter_app/pages/imagePickerPage.dart';
import 'package:wikitude_flutter_app/pages/loginPage.dart';
import 'package:wikitude_flutter_app/pages/visionPage.dart';
import 'package:wikitude_flutter_app/service/googleSignIn.dart';
import 'package:wikitude_flutter_app/widgets/drawer.dart';
import 'package:wikitude_flutter_app/widgets/languageDropdown.dart';
import 'package:wikitude_flutter_app/widgets/locationDropdown.dart';
import 'package:wikitude_flutter_app/widgets/shrimmingWidget.dart';
import 'card.dart';
import 'settingsPage.dart';
import 'loginPage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shimmer/shimmer.dart';
import '../model/loadingTextModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  final String loginMethod;

  const HomePage({Key? key, required this.loginMethod}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
  User? user = FirebaseAuth.instance.currentUser;
  dynamic loggedInUser = UserModel();
  GoogleUserModel googleLoggedInUser = GoogleUserModel();
  String loginMethod = "";
  Widget loginPage = LoginPage();
  Position _currentPosition = new Position(
      accuracy: 0,
      altitude: 0,
      heading: 0,
      latitude: 0,
      longitude: 0,
      speed: 0,
      speedAccuracy: 0,
      timestamp: new DateTime.now());
  String _currentAddress = "";
  LoadingTextModel addressText = new LoadingTextModel(text: "");
  bool isAddressLoading = true;
  bool isActivityLoading = true;
  bool isAttractionLoading = true;
  List<ActivityModel> _activityModels = [];
  List<AttractionModel> _attractionModels = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Fetch content from the json file
  Future<void> readActivtiesJson() async {
    // final String response =
    //     await rootBundle.loadString('assets/data/activities_data.json');
    final response = await http.read(
        Uri.parse(
            "https://api.jsonbin.io/v3/b/61d734442675917a628b69fc/latest"),
        headers: {
          "Accept": "application/json",
          "X-Master-Key":
              "\$2b\$10\$M6L3eXj646aBmRdVgsJzHewx5S2ZEf6FXP.4gFg1S3DlbQ9i8Yfr."
        });
    List<dynamic> listJson = json.decode(response)["record"];
    var compareDistance = (a, b) =>
        (double.parse(getDistanceToUser(a.longitude, a.latitude)) -
                double.parse(getDistanceToUser(b.longitude, b.latitude)))
            .round();
    setState(() {
      _activityModels = List<ActivityModel>.from(
          listJson.map((i) => ActivityModel.fromJson(i)));
      _activityModels.sort(compareDistance);
      createNotification(
          "Check out fun activities nearby!", _activityModels[0].title + "!");
    });
  }

  Future<void> readPlacesJson() async {
    final response = await http.read(
        Uri.parse(
            "https://api.jsonbin.io/v3/b/61d7344e2362237a3a336843/latest"),
        headers: {
          "Accept": "application/json",
          "X-Master-Key":
              "\$2b\$10\$M6L3eXj646aBmRdVgsJzHewx5S2ZEf6FXP.4gFg1S3DlbQ9i8Yfr."
        });
    List<dynamic> listJson = json.decode(response)["record"];
    var compareDistance = (a, b) =>
        (double.parse(getDistanceToUser(a.longitude, a.latitude)) -
                double.parse(getDistanceToUser(b.longitude, b.latitude)))
            .round();
    setState(() {
      _attractionModels = List<AttractionModel>.from(
          listJson.map((i) => AttractionModel.fromJson(i)));
      _attractionModels.sort(compareDistance);
      createNotification(
          "Don't miss out tourist attractions around you!",
          "Check out " +
              _attractionModels[0].name +
              ", only " +
              getDistanceToUser(_attractionModels[0].longitude,
                  _attractionModels[0].latitude) +
              " km away");
    });
  }

  Future<void> initializeNotification() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> createNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            enableVibration: false,
            playSound: false,
            importance: Importance.low,
            priority: Priority.low,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'travel.ee');
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    initializeNotification();
    // loadAddress();
    if (widget.loginMethod == "Email") {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .get()
          .then((value) {
        loggedInUser = UserModel.fromMap(value.data());
        loginMethod = "Email";
        setState(() {});
      });
    } else {
      final user = FirebaseAuth.instance.currentUser;
      loggedInUser = user;
      loginMethod = "Google";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: ClipOval(
              child: Image.network(
                (loginMethod != "Google")
                    ? 'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg'
                    : loggedInUser.photoURL!,
                fit: BoxFit.cover,
                width: 90,
                height: 90,
              ),
            ),
          ),
        ),
        actions: <Widget>[
          // LocationDropdown(currentAddress: _currentAddress),
          // LanguageDropdown(),
          IconButton(
              icon: Icon(Icons.refresh, color: Colors.pink[200]),
              onPressed: () {
                _getAddressFromLatLng();
                createNotification(
                    "Welcome to " + _currentAddress + "!",
                    ((loginMethod != "Google")
                            ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
                            : "${loggedInUser.displayName.split(' ')[0]}") +
                        ", click here to explore your neighborhood!");
              })
        ],
      ),
      body: Container(
        color: Color(0xffd0e3e3),
        child: Container(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Color(0xffee8e8d),
        inactiveIconColor: Colors.grey[400],
        tabs: [
          TabData(
            iconData: Icons.home_outlined,
            title: AppLocalizations.of(context)!.menu_home,
          ),
          TabData(iconData: Icons.view_in_ar_outlined, title: "AR"),
          TabData(
              iconData: Icons.view_list_outlined,
              title: AppLocalizations.of(context)!.menu_plan),
          TabData(iconData: Icons.camera, title: "Vision"
              //,onclick: () => Navigator.of(context)
              //     .push(MaterialPageRoute(builder: (context) => VisionPage()))
              ),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: (loginMethod != "Google")
          ? NavigationDrawerWidget(
              currentUser: loggedInUser, loginMethod: loginMethod)
          : NavigationDrawerWidget(
              currentUser: loggedInUser, loginMethod: loginMethod),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 75.0),
                Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hi👋 " +
                            ((loginMethod != "Google")
                                ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
                                : "${loggedInUser.displayName.split(' ')[0]}") +
                            ",",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 5.0),
                      isAddressLoading
                          ? buildAddressShimmer()
                          : buildAddressText(addressText),
                      // buildAddressShimmer(),
                      SizedBox(height: 10.0),
                      Divider(),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Recommended Activties',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => print('See All'),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 260.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              if (_activityModels.length == 0) {
                                return buildActivityShimmer();
                              } else {
                                ActivityModel activity = _activityModels[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ActivityScreen(
                                                activity: activity,
                                              ))),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        //color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        // boxShadow: [
                                        //   BoxShadow(
                                        //     color: Colors.black26,
                                        //     offset: Offset(0.0, 2.0),
                                        //     blurRadius: 4.0,
                                        //   ),
                                        // ],
                                      ),
                                      margin: EdgeInsets.all(8.0),
                                      width: 170.0,
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Positioned(
                                            bottom: 10.0,
                                            child: Container(
                                              height: 120.0,
                                              width: 180.0,
                                              decoration: BoxDecoration(
                                                  color: Color(0x80ffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 55, 15, 5),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        activity.title,
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          fontSize: 15.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   activity.description,
                                                      //   overflow: TextOverflow.fade,
                                                      //   maxLines: 2,
                                                      //   style: TextStyle(
                                                      //     color: Colors.grey,
                                                      //   ),
                                                      // ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0.0, 2.0),
                                                    blurRadius: 6.0,
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Hero(
                                                    tag: activity.imageUrl,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Image(
                                                        height: 160.0,
                                                        width: 160.0,
                                                        image: NetworkImage(
                                                            activity.imageUrl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 10.0,
                                                    bottom: 10.0,
                                                    child: Row(
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.pin_drop,
                                                          size: 12.0,
                                                          color: Colors.white,
                                                        ),
                                                        Text(
                                                          " " +
                                                              getDistanceToUser(
                                                                  activity
                                                                      .longitude,
                                                                  activity
                                                                      .latitude) +
                                                              " km",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        // Row(
                                                        //   children: <Widget>[
                                                        //     // Icon(
                                                        //     //   FontAwesomeIcons.locationArrow,
                                                        //     //   size: 10.0,
                                                        //     //   color: Colors.white,
                                                        //     // ),
                                                        //     SizedBox(width: 5.0),
                                                        //     Text(
                                                        //       activity.longitude,
                                                        //       style: TextStyle(
                                                        //         color: Colors.white,
                                                        //       ),
                                                        //     ),
                                                        //   ],
                                                        // ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                );
                              }
                            },
                          )),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Nearby Places',
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => print('See All'),
                              child: Text(
                                'See All',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          height: 260.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 6,
                            itemBuilder: (BuildContext context, int index) {
                              if (_attractionModels.length == 0) {
                                return buildActivityShimmer();
                              } else {
                                AttractionModel place =
                                    _attractionModels[index];
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => AttractionScreen(
                                              attraction: place))),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      margin: EdgeInsets.all(8.0),
                                      width: 170.0,
                                      child: Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Positioned(
                                            bottom: 10.0,
                                            child: Container(
                                              height: 120.0,
                                              width: 180.0,
                                              decoration: BoxDecoration(
                                                  color: Color(0x80ffffff),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 55, 15, 5),
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      // Text(
                                                      //   place.name,
                                                      //   overflow:
                                                      //       TextOverflow.fade,
                                                      //   maxLines: 3,
                                                      //   style: TextStyle(
                                                      //     fontSize: 16.0,
                                                      //     fontWeight:
                                                      //         FontWeight.w600,
                                                      //   ),
                                                      // ),
                                                      Text(
                                                        place.description,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[850],
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                            ),
                                          ),
                                          Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(0.0, 2.0),
                                                    blurRadius: 6.0,
                                                  ),
                                                ],
                                              ),
                                              child: Stack(
                                                children: [
                                                  Hero(
                                                    tag: place.photourl,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      child: Image(
                                                        height: 160.0,
                                                        width: 160.0,
                                                        image: NetworkImage(
                                                            place.photourl),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 10.0,
                                                    bottom: 10.0,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Row(
                                                          children: [
                                                            Container(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      minWidth:
                                                                          10,
                                                                      maxWidth:
                                                                          150),
                                                              child: Text(
                                                                place.name,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                maxLines: 3,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.pin_drop,
                                                              size: 12.0,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            SizedBox(
                                                                width: 1.0),
                                                            Text(
                                                              " " +
                                                                  getDistanceToUser(
                                                                      place
                                                                          .longitude,
                                                                      place
                                                                          .latitude) +
                                                                  " km",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        ],
                                      )),
                                );
                              }
                            },
                          )),

                      // Text((_currentPosition.latitude == 0)
                      //     ? ""
                      //     : "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
                      // Text(
                      //     (loginMethod != "Google")
                      //         ? "${loggedInUser.email}"
                      //         : "${loggedInUser.email!}",
                      //     style: TextStyle(
                      //       color: Colors.black54,
                      //       fontWeight: FontWeight.w500,
                      //     )),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // ActionChip(
                      //     label: Text("Logout"),
                      //     onPressed: () {
                      //       if (loginMethod != "Google")
                      //         logout(context);
                      //       else {
                      //         final provider = Provider.of<GoogleSignInProvider>(
                      //             context,
                      //             listen: false);
                      //         provider.logout();
                      //         Navigator.of(context).pushReplacement(
                      //             MaterialPageRoute(
                      //                 builder: (context) => LoginPage()));
                      //       }
                      //     }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      case 1:
        return ArPage();
      case 2:
        // return Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: <Widget>[
        //     Text("This is the Plan page"),
        //   ],
        // );
        return CardPage();
      case 3:
        return ImagePickerPage(title: 'Image Picker Example');
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the Default page"),
          ],
        );
    }
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      setState(() {
        isAddressLoading = true;
        isActivityLoading = true;
        isAttractionLoading = true;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      readActivtiesJson();
      readPlacesJson();
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}";
        addressText = new LoadingTextModel(text: _currentAddress);
        isAddressLoading = false;
        isActivityLoading = false;
        isAttractionLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  String getDistanceToUser(String longitude, String latitude) {
    double long1 = double.parse(longitude) / 57.29577951;
    double lat1 = double.parse(latitude) / 57.29577951;
    double long2 = _currentPosition.longitude / 57.29577951;
    double lat2 = _currentPosition.latitude / 57.29577951;
    double res = 1.609344 *
        3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(long2 - long1));
    return res.toStringAsFixed(1);
  }

  Widget buildAddressText(LoadingTextModel model) =>
      Text("Discover More in ${model.text} !",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500));

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 17,
        width: MediaQuery.of(context).size.width / 1.1,
      );

  Widget buildActivityShimmer() => ShimmeringWidget.rectangular(
        height: 11,
        width: MediaQuery.of(context).size.width / 1.8,
      );
}
