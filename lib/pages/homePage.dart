import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:travelee/ar/arpage.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:travelee/model/activityModel.dart';
import 'package:travelee/model/attractionModel.dart';
import 'package:travelee/model/googleUserModel.dart';
import 'package:travelee/model/restaurantModel.dart';
import 'package:travelee/model/stationModel.dart';
import 'package:travelee/model/userModel.dart';
import 'package:travelee/pages/achievementScreen.dart';
import 'package:travelee/pages/activityScreen.dart';
import 'package:travelee/pages/attractionScreen.dart';
import 'package:travelee/pages/covidScreen.dart';
import 'package:travelee/pages/imagePickerPage.dart';
import 'package:travelee/pages/loginPage.dart';
import 'package:travelee/pages/profilePage.dart';
import 'package:travelee/widgets/restaurantScreen.dart';
import 'package:travelee/widgets/searchbar.dart';
import 'package:travelee/widgets/shrimmingWidget.dart';
import 'loginPage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../model/loadingTextModel.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rating_dialog/rating_dialog.dart';

class HomePage extends StatefulWidget {
  final String loginMethod;

  const HomePage({Key? key, required this.loginMethod}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  List favActivities = [];
  List favAttractions = [];
  List favRestaurants = [];
  GlobalKey bottomNavigationKey = GlobalKey();
  User? user = FirebaseAuth.instance.currentUser;
  dynamic loggedInUser = UserModel();
  GoogleUserModel googleLoggedInUser = GoogleUserModel();
  String loginMethod = "";
  Placemark placemark = Placemark();
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
  LoadingTextModel landmarkText = new LoadingTextModel(text: "");
  bool isAddressLoading = true;
  bool isActivityLoading = true;
  bool isAttractionLoading = true;
  bool isStationLoading = true;
  bool isLandmarkLoading = true;
  bool isLandmarkNearEnough = false;
  bool isRestaurantLoading = true;
  List<ActivityModel> _activityModels = [];
  List<AttractionModel> _attractionModels = [];
  List<RestaurantModel> _restaurantModels = [];
  List<StationModel> _stationModels = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String weather = "loading...";
  // ignore: non_constant_identifier_names
  String icon_link = "http://openweathermap.org/img/w/04n.png";
  String popupLandmarkCircle = "";

  Future<void> readStationJson() async {
    _getFavorite('activties');
    _getFavorite('attractions');
    _getFavorite('restaurants');
    final response = await http.get(
        Uri.parse(
            "https://api.jsonbin.io/v3/b/61828c684a82881d6c6a096d/latest"),
        headers: {
          'Content-type': 'application/json',
          "X-Master-Key":
              "\$2b\$10\$M6L3eXj646aBmRdVgsJzHewx5S2ZEf6FXP.4gFg1S3DlbQ9i8Yfr."
        });
    final data = await json.decode(response.body)["record"] as List<dynamic>;
    var compareDistance = (a, b) =>
        (double.parse(getDistanceToUser(a.longitude, a.latitude)) * 1000 -
                double.parse(getDistanceToUser(b.longitude, b.latitude)) * 1000)
            .round();
    setState(() {
      _stationModels = data.map((e) => StationModel.fromJson(e)).toList();
      _stationModels.sort(compareDistance);
      _stationModels = _stationModels.getRange(0, 3).toList();
    });
    // ignore: unnecessary_statements
    isLandmarkNearEnough ? displayRewardDialog() : {};
  }

  // Fetch content from the json file
  Future<void> readActivitiesJson() async {
    final response = await http.get(
        Uri.parse(
            "https://api.jsonbin.io/v3/b/61d734442675917a628b69fc/latest"),
        headers: {
          'Content-type': 'application/json',
          "X-Master-Key":
              "\$2b\$10\$M6L3eXj646aBmRdVgsJzHewx5S2ZEf6FXP.4gFg1S3DlbQ9i8Yfr."
        });
    final data = await json.decode(response.body)["record"] as List<dynamic>;
    var compareDistance = (a, b) =>
        (double.parse(getDistanceToUser(a.longitude, a.latitude)) * 1000 -
                double.parse(getDistanceToUser(b.longitude, b.latitude)) * 1000)
            .round();
    setState(() {
      _activityModels = data.map((e) => ActivityModel.fromJson(e)).toList();
      _activityModels.sort(compareDistance);
    });
  }

  Future<void> readPlacesJson() async {
    final response = await http.get(
        Uri.parse(
            "https://api.jsonbin.io/v3/b/61d7344e2362237a3a336843/latest"),
        headers: {
          'Content-type': 'application/json',
          "X-Master-Key":
              "\$2b\$10\$M6L3eXj646aBmRdVgsJzHewx5S2ZEf6FXP.4gFg1S3DlbQ9i8Yfr."
        });
    final data = await json.decode(response.body)["record"] as List<dynamic>;
    var compareDistance = (a, b) =>
        (double.parse(getDistanceToUser(a.longitude, a.latitude)) * 1000 -
                double.parse(getDistanceToUser(b.longitude, b.latitude)) * 1000)
            .round();
    setState(() {
      _attractionModels = data.map((e) => AttractionModel.fromJson(e)).toList();
      _attractionModels.sort(compareDistance);
      createNotification(
          "Don't miss out tourist attractions around you!",
          "Check out " +
              _attractionModels[0].name +
              ", only " +
              (double.parse(getDistanceToUser(_attractionModels[0].longitude,
                          _attractionModels[0].latitude)) *
                      1000)
                  .toStringAsFixed(0) +
              " m away");
      if (double.parse(getDistanceToUser(
              _attractionModels[0].longitude, _attractionModels[0].latitude)) <=
          0.36) {
        landmarkText = new LoadingTextModel(text: _attractionModels[0].name);
        createNotification(
            "YAY! ???? You\'ve made it to " + _attractionModels[0].name + "!",
            "Claim your rewards???? NOW!");
        popupLandmarkCircle = _attractionModels[0].photourl;
        isLandmarkLoading = false;
        isLandmarkNearEnough = true;
      }
    });
  }

  Future<void> readWeatherJson() async {
    Uri _uri = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=${_currentPosition.latitude}&lon=${_currentPosition.longitude}&appid=df33d4922d23eaad8d9077a561144719",
    );
    final response = await http.get(_uri);
    final data = json.decode(response.body);
    weather = data["weather"][0]["main"];
    icon_link = "http://openweathermap.org/img/w/" +
        data["weather"][0]["icon"] +
        ".png";
  }

  // Fetch content from the json file
  Future<void> readRestaurantJson() async {
    // final response =
    //     await rootBundle.loadString('assets/data/restaurant_mock.json');
    // var restaurantJson = jsonDecode(response)["data"] as List;
    Uri _uri = Uri.parse(
        "https://travel-advisor.p.rapidapi.com/restaurants/list-by-latlng?latitude=${_currentPosition.latitude}&longitude=${_currentPosition.longitude}&limit=40&currency=SGD&distance=5&lunit=km&lang=en_US&min_rating=3.5");

    final response = await http.get(_uri, headers: {
      "x-rapidapi-host": "travel-advisor.p.rapidapi.com",
      "x-rapidapi-key": "9db9c9d246msh25db841ec6d88cbp1c2b50jsne2a3c0836744",
    });
    final restaurantJson =
        await json.decode(utf8.decode(response.bodyBytes))["data"] as List;
    var compareRating = (a, b) =>
        (25 * (double.parse(b.rating) - double.parse(a.rating))).round() +
        (int.parse(b.numReviews) - int.parse(a.numReviews));
    setState(() {
      _restaurantModels = restaurantJson
          .map((r) => RestaurantModel.fromJson(r))
          .toList()
          .where((i) =>
              (i.name != null) && (i.rating != null) && (i.numReviews != null))
          .toList();
      _restaurantModels.sort(compareRating);
      //   // createNotification(
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
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x00000000),
        elevation: 0,
        // leading: Builder(
        //   builder: (context) => IconButton(
        //     onPressed: () => Scaffold.of(context).openDrawer(),
        //     icon: ClipOval(
        //       child: Image.network(
        //         (loginMethod != "Google")
        //             ? 'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg'
        //             : loggedInUser.photoURL!,
        //         fit: BoxFit.cover,
        //         width: 90,
        //         height: 90,
        //       ),
        //     ),
        //   ),
        // ),
        actions: <Widget>[
          // LocationDropdown(currentAddress: _currentAddress),
          // LanguageDropdown(),
          IconButton(
              icon: ImageIcon(NetworkImage(icon_link),
                  size: 28.0, color: Colors.blue[900]),
              tooltip: weather,
              onPressed: () {}),
          IconButton(
              icon: Icon(Icons.masks, size: 30, color: Colors.teal[800]),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CovidScreen(country: placemark.country),
                ));
              }),
          IconButton(
              icon: Icon(Icons.update, size: 25.0, color: Colors.red[900]),
              onPressed: () {
                isAddressLoading = true;
                isActivityLoading = true;
                isAttractionLoading = true;
                isLandmarkLoading = true;
                isLandmarkNearEnough = false;
                _getCurrentLocation();
                createNotification(
                    "Welcome to " + _currentAddress + "!",
                    ((loginMethod != "Google")
                            ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
                            : "${loggedInUser.displayName.split(' ')[0]}") +
                        ", click here to explore your neighborhood!");
              }),
        ],
      ),
      body: Container(
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
          TabData(iconData: Icons.camera, title: "Vision"),
          TabData(iconData: Icons.person, title: "Profile"),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
            // show the dialog
            if (Random().nextInt(100) <= 3) {
              showDialog(
                context: context,
                barrierDismissible:
                    true, // set to false if you want to force a rating
                builder: (context) => _dialog,
              );
            }
          });
        },
      ),
      // drawer: (loginMethod != "Google")
      //     ? NavigationDrawerWidget(
      //         currentUser: loggedInUser, loginMethod: loginMethod)
      //     : NavigationDrawerWidget(
      //         currentUser: loggedInUser, loginMethod: loginMethod),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://i.pinimg.com/564x/ac/1c/3f/ac1c3fdcdd13bc52f5cb9fc3ec73c271.jpg"),
              colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.5), BlendMode.srcATop),
              fit: BoxFit.cover,
            ),
          ),
          child: new BackdropFilter(
            filter: new ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
            child: Container(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 68.0),
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Hi???? " +
                                  ((loginMethod != "Google")
                                      ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
                                      : "${loggedInUser.displayName.split(' ')[0]}") +
                                  ",",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Poppins'),
                            ),
                            SizedBox(height: 10.0),
                            isAddressLoading
                                ? buildAddressShimmer()
                                : buildAddressText(addressText),
                            SizedBox(height: 19.0),
                            GestureDetector(
                              child: buildSearchBar(),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchBarScreen()),
                              ),
                            ),
                            SizedBox(height: 19.0),
                            SizedBox(height: 10.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Nearby MRT Station',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                color: Colors.white,
                                child: ListView(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: <Widget>[
                                      isStationLoading
                                          ? buildStationShimmer()
                                          : DataTable(
                                              dataRowHeight: 30,
                                              headingRowHeight: 32.0,
                                              dividerThickness: 0,
                                              columnSpacing: 12,
                                              columns: [
                                                DataColumn(
                                                    label: Text('Name',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                DataColumn(
                                                    label: Text('Code',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                                DataColumn(
                                                    label: Text('Distance',
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ],
                                              rows: getRows(_stationModels),
                                            ),
                                    ]),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Landmarks Nearby',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (_attractionModels.length == 0) {
                                      return buildActivityShimmer();
                                    } else {
                                      AttractionModel place =
                                          _attractionModels[index];
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AttractionScreen(
                                                        attraction: place))),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            margin: EdgeInsets.all(6.0),
                                            width: 165.0,
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Positioned(
                                                  bottom: 10.0,
                                                  child: Container(
                                                    height: 120.0,
                                                    width: 180.0,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0x80ffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 55, 15, 5),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              place.description,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .grey[850],
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
                                                          BorderRadius.circular(
                                                              20.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset:
                                                              Offset(0.0, 2.0),
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
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            child: Image(
                                                              height: 160.0,
                                                              width: 160.0,
                                                              image: NetworkImage(
                                                                  place
                                                                      .photourl),
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
                                                                    constraints: BoxConstraints(
                                                                        minWidth:
                                                                            10,
                                                                        maxWidth:
                                                                            150),
                                                                    child: Text(
                                                                      place
                                                                          .name,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .fade,
                                                                      maxLines:
                                                                          3,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .pin_drop,
                                                                    size: 12.0,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          1.0),
                                                                  Text(
                                                                    " " +
                                                                        getDistanceToUser(
                                                                            place.longitude,
                                                                            place.latitude) +
                                                                        " km",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Positioned(
                                                          left: 125.0,
                                                          bottom: 125.0,
                                                          child: FavoriteButton(
                                                            iconSize: 36.0,
                                                            iconDisabledColor:
                                                                Colors.white,
                                                            isFavorite: favAttractions
                                                                .contains(place
                                                                    .id
                                                                    .toString()),
                                                            valueChanged:
                                                                (_isFavorite) {
                                                              print(
                                                                  'Is Favorite $_isFavorite, ${favAttractions.contains(place.id.toString())})');
                                                              _toggleFavorite(
                                                                  _isFavorite,
                                                                  place.id
                                                                      .toString(),
                                                                  "attractions");
                                                            },
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
                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Recommended Activities',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (_activityModels.length == 0) {
                                      return buildActivityShimmer();
                                    } else {
                                      ActivityModel activity =
                                          _activityModels[index];
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
                                            ),
                                            margin: EdgeInsets.all(6.0),
                                            width: 165.0,
                                            child: Stack(
                                              alignment: Alignment.topCenter,
                                              children: [
                                                Positioned(
                                                  bottom: 10.0,
                                                  child: Container(
                                                    height: 120.0,
                                                    width: 180.0,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0x80ffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          15, 55, 15, 5),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              activity.title,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
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
                                                          BorderRadius.circular(
                                                              20.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black26,
                                                          offset:
                                                              Offset(0.0, 2.0),
                                                          blurRadius: 6.0,
                                                        ),
                                                      ],
                                                    ),
                                                    child: Stack(
                                                      children: [
                                                        Hero(
                                                          tag:
                                                              activity.imageUrl,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            child: Image(
                                                              height: 160.0,
                                                              width: 160.0,
                                                              image: NetworkImage(
                                                                  activity
                                                                      .imageUrl),
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
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              Text(
                                                                " " +
                                                                    getDistanceToUser(
                                                                        activity
                                                                            .longitude,
                                                                        activity
                                                                            .latitude) +
                                                                    " km",
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
                                                        Positioned(
                                                          left: 125.0,
                                                          bottom: 125.0,
                                                          child: FavoriteButton(
                                                            iconSize: 36.0,
                                                            iconDisabledColor:
                                                                Colors.white,
                                                            isFavorite: favActivities
                                                                .contains(activity
                                                                    .id
                                                                    .toString()),
                                                            valueChanged:
                                                                (_isFavorite) {
                                                              print(
                                                                  'Is Favorite $_isFavorite, ${favActivities.contains(activity.id.toString())})');
                                                              _toggleFavorite(
                                                                  _isFavorite,
                                                                  activity.id
                                                                      .toString(),
                                                                  "activties");
                                                            },
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
                              padding: EdgeInsets.symmetric(horizontal: 1.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Restaurants Nearby',
                                    style: TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: 174.0,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 7,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (_restaurantModels.length == 0) {
                                      return buildRestaurantShimmer();
                                    } else {
                                      RestaurantModel restaurant =
                                          _restaurantModels[index];
                                      return GestureDetector(
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    RestaurantScreen(
                                                        restaurant:
                                                            restaurant))),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            margin: EdgeInsets.all(6.0),
                                            width: 299.0,
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Positioned(
                                                  bottom: 10.0,
                                                  child: Container(
                                                    height: 150.0,
                                                    width: 296.0,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0x80ffffff),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0)),
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          105, 20, 10, 0),
                                                      child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              restaurant.name!,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                            ),
                                                            SizedBox(height: 3),
                                                            Row(
                                                                children: <
                                                                    Widget>[
                                                                  Icon(
                                                                    Icons
                                                                        .pin_drop,
                                                                    size: 14.0,
                                                                  ),
                                                                  Text(
                                                                    " " +
                                                                        getDistanceToUser(
                                                                            restaurant.longitude!,
                                                                            restaurant.latitude!) +
                                                                        " km",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
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
                                                            Row(children: <
                                                                Widget>[
                                                              ImageIcon(
                                                                NetworkImage(
                                                                    "https://cdn-icons-png.flaticon.com/512/1216/1216908.png"),
                                                                size: 23,
                                                                color: Color(
                                                                    0xff00AF87),
                                                              ),
                                                              Text(
                                                                " Rating: " +
                                                                    restaurant
                                                                        .rating!,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color(
                                                                        0xff00AF87)),
                                                              ),
                                                            ]),
                                                            restaurant.cuisine!
                                                                        .length !=
                                                                    0
                                                                ? SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .min,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        children: restaurant
                                                                            .cuisine!
                                                                            .map((item) =>
                                                                                Padding(
                                                                                  padding: const EdgeInsets.symmetric(
                                                                                    horizontal: 2.0,
                                                                                  ),
                                                                                  child: Chip(
                                                                                    backgroundColor: Colors.cyan[200],
                                                                                    label: Text(item.name!, style: TextStyle(fontSize: 13)),
                                                                                  ),
                                                                                ))
                                                                            .toList()
                                                                        // .toList(),
                                                                        ),
                                                                  )
                                                                : Text("")
                                                          ]),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                      child: Stack(
                                                    children: [
                                                      Hero(
                                                        tag: restaurant.name!,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      42.0),
                                                          child: Image(
                                                            height: 84.0,
                                                            width: 84.0,
                                                            image: NetworkImage(
                                                                (restaurant.photo !=
                                                                        null)
                                                                    ? restaurant
                                                                        .photo!
                                                                        .images!
                                                                        .original!
                                                                        .url!
                                                                    : "https://www.freeiconspng.com/uploads/restaurant-icon-png-10.png"),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                                ),
                                                Positioned(
                                                  left: 255.0,
                                                  bottom: 120.0,
                                                  child: FavoriteButton(
                                                    iconSize: 36.0,
                                                    iconDisabledColor:
                                                        Colors.white,
                                                    isFavorite: favRestaurants
                                                        .contains(restaurant
                                                            .locationId
                                                            .toString()),
                                                    valueChanged:
                                                        (_isFavorite) {
                                                      print(
                                                          'Is Favorite $_isFavorite, ${favRestaurants.contains(restaurant.locationId.toString())})');
                                                      _toggleFavorite(
                                                          _isFavorite,
                                                          restaurant.locationId
                                                              .toString(),
                                                          "restaurants");
                                                    },
                                                  ),
                                                ),
                                              ],
                                            )),
                                      );
                                    }
                                  },
                                )),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     color: Colors.yellow[200],
                            //     boxShadow: [
                            //       BoxShadow(
                            //         color: Colors.grey.withOpacity(0.5),
                            //         spreadRadius: 2,
                            //         blurRadius: 4,
                            //         offset: Offset(
                            //             0, 2), // changes position of shadow
                            //       ),
                            //     ],
                            //   ),
                            // child: SizedBox(
                            //   width: 400.0,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(12.0),
                            //     child: Column(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceAround,
                            //         children: [
                            //           SizedBox(height: 8.0),
                            //           Text("????",
                            //               style: TextStyle(fontSize: 50)),
                            //           SizedBox(height: 8.0),
                            //           Text(
                            //               "    Still can't decide where to have fun? \n Let Travelee make the decision for you!",
                            //               style: TextStyle(
                            //                   fontSize: 15,
                            //                   fontWeight: FontWeight.w600)),
                            //           SizedBox(height: 8.0),
                            //           ElevatedButton(
                            //             style: ButtonStyle(
                            //               backgroundColor:
                            //                   MaterialStateProperty.all(
                            //                       Colors.red[200]),
                            //               shape: MaterialStateProperty.all<
                            //                   RoundedRectangleBorder>(
                            //                 RoundedRectangleBorder(
                            //                   borderRadius:
                            //                       BorderRadius.circular(18.0),
                            //                 ),
                            //               ),
                            //             ),
                            //             onPressed: () => print(
                            //                 "Travelee makes the decision for you!"),
                            //             child: new Text('It\'s Our Job Now!',
                            //                 style: TextStyle(
                            //                   fontSize: 15,
                            //                   fontWeight: FontWeight.w600,
                            //                   color: Colors.white,
                            //                 )),
                            //           )
                            //         ]),
                            // ),
                            // ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      case 1:
        return ArPage();
      case 2:
        return ImagePickerPage(title: 'Image Picker Example');
      case 3:
        return ProfilePage(
          iconlink: (loginMethod != "Google")
              ? 'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg'
              : loggedInUser.photoURL!,
          name: (loginMethod != "Google")
              ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
              : "${loggedInUser.displayName}",
          email: loggedInUser.email!,
          loginMethod: loginMethod,
        );
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
        readWeatherJson();
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      setState(() {
        isStationLoading = true;
        isAddressLoading = true;
        isActivityLoading = true;
        isAttractionLoading = true;
        isRestaurantLoading = true;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      readStationJson();
      readActivitiesJson();
      readPlacesJson();
      readRestaurantJson();
      Placemark place = placemark = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality}";
        addressText = new LoadingTextModel(text: _currentAddress);
        isStationLoading = false;
        isAddressLoading = false;
        isActivityLoading = false;
        isAttractionLoading = false;
        isRestaurantLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  List<DataRow> getRows(List<StationModel> stations) =>
      stations.map((StationModel station) {
        var code = station.name!.split('MRT STATION')[1].trim();
        code = code.substring(1, code.length - 1);
        final cells = [
          DataCell(Text(capitalizeFirstofEach(station.name!.split('MRT')[0]),
              style: TextStyle(fontWeight: FontWeight.w700))),
          DataCell(_buildStationCode(code)),
          DataCell(
            Text((double.parse(getDistanceToUser(
                            station.longitude!, station.latitude!)) *
                        1000)
                    .round()
                    .toString() +
                " m"),
          )
        ];
        return DataRow(cells: cells);
      }).toList();

  Widget _buildStationCode(String code) {
    List<String> name = code.split('/').map((s) => s.trim()).toList();
    List<Widget> result = [];
    var i = 0;
    if (name[i].contains("EW") || name[i].contains("CG")) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xff009539),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
      i++;
    }
    if (i < name.length && name[i].contains("NS")) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xffde261a),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
      i++;
    }
    if (i < name.length && name[i].contains("NE")) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xff9b27af),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
      i++;
    }
    if (i < name.length && (name[i].contains("CC") || name[i].contains("CE"))) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xfffe9c15),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
      i++;
    }
    if (i < name.length && name[i].contains("DT")) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xff005ca3),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
      i++;
    }
    if (i < name.length && name[i].contains("TE")) {
      result.add(Text(" " + name[i] + " ",
          style: TextStyle(
              backgroundColor: Color(0xff9c591a),
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold)));
    }
    return Row(children: result);
  }

  String toCapitalized(s) => s.length > 0
      ? '${s[0].toUpperCase()}${s.substring(1).toLowerCase()}'
      : '';
  String capitalizeFirstofEach(s) =>
      s.split(" ").map((str) => toCapitalized(str)).join(" ");
  String getDistanceToUser(String longitude, String latitude) {
    double long1 = double.parse(longitude) / 57.29577951;
    double lat1 = double.parse(latitude) / 57.29577951;
    double long2 = _currentPosition.longitude / 57.29577951;
    double lat2 = _currentPosition.latitude / 57.29577951;
    double res = 1.609344 *
        3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(long2 - long1));
    return res.toStringAsFixed(2);
  }

  List _getFavorite(String option) {
    var email = user!.email!;
    FirebaseFirestore.instance
        .collection(option)
        .doc(email)
        .get()
        .then((value) {
      setState(() {
        switch (option) {
          case "activties":
            favActivities = value.data()!["places"];
            break;
          case "attractions":
            favAttractions = value.data()!["places"];
            break;
          case "restaurants":
            favRestaurants = value.data()!["places"];
            break;
        }
      });
    });
    switch (option) {
      case "activties":
        return favActivities;
      case "attractions":
        return favAttractions;
      case "restaurants":
        return favRestaurants;
      default:
        return [];
    }
  }

  _toggleFavorite(bool favorite, String id, String option) {
    var _list = _getFavorite(option);
    print(_list);
    var email = user!.email!;
    if (favorite) {
      if (!(_list.contains(id))) _list.add(id);
      print(_list);
      FirebaseFirestore.instance
          .collection(option)
          .doc(email)
          .set({"places": _list});
    } else {
      if (_list.contains(id)) _list.remove(id);
      FirebaseFirestore.instance
          .collection(option)
          .doc(email)
          .set({"places": _list});
    }
  }

  Widget buildCircleImage(String path) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 60.0,
          child: CircleAvatar(
            backgroundImage: NetworkImage(path),
            radius: 55.0,
          ),
        ),
      );

  Widget buildAddressText(LoadingTextModel model) => Row(
        children: [
          Text("Discover More in ${model.text} ",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins")),
          SizedBox(
              height: 17,
              child: Image(
                  image: NetworkImage(
                      "https://disease.sh/assets/img/flags/sg.png"))),
          Text(" !",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Poppins")),
        ],
      );

  Widget buildLandmarkText(LoadingTextModel model) => Align(
        alignment: Alignment.center,
        child: Text(
          model.text,
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
        ),
      );

  Widget buildAddressShimmer() => ShimmeringWidget.rectangular(
        height: 17,
        width: MediaQuery.of(context).size.width / 1.1,
      );

  Widget buildActivityShimmer() => ShimmeringWidget.rectangular(
        height: 11,
        width: MediaQuery.of(context).size.width / 2.2,
      );

  Widget buildLandmarkShimmer() => ShimmeringWidget.rectangular(
        height: 11,
        width: MediaQuery.of(context).size.width / 2.2,
      );

  Widget buildRestaurantShimmer() => ShimmeringWidget.rectangular(
        height: 11,
        width: MediaQuery.of(context).size.width / 1.4,
      );

  Widget buildStationShimmer() => ShimmeringWidget.rectangular(
        height: 135,
        width: MediaQuery.of(context).size.width / 1.2,
      );

  Widget buildCircleShimmer() => ShimmeringWidget.circular(
        height: 35,
      );

  Future<void> displayRewardDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.red[200],
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
                        Text(
                          'YAY! ???? You\'ve made it to',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        isLandmarkLoading
                            ? buildLandmarkShimmer()
                            : buildLandmarkText(landmarkText),
                        isLandmarkLoading
                            ? buildCircleShimmer()
                            : buildCircleImage(popupLandmarkCircle),
                        SizedBox(height: 8.0),
                        Column(
                          children: [
                            ClipRRect(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => AchievementScreen(
                                            icon: user!.photoURL!,
                                            name: user!.displayName!,
                                          )));
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.yellow[700]),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ))),
                                child: Text(
                                  'Claim your rewards???? NOW!',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.0),
                      ]),
                ),
              ));
        });
  }

  Widget buildSearchBar() => Padding(
      padding: const EdgeInsets.all(1.0),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: SizedBox(
              height: 36,
              child: Container(
                color: Colors.grey[300],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('   Search...'),
                      Icon(Icons.search),
                    ],
                  ),
                ),
              ))));
}

final _dialog = RatingDialog(
  initialRating: 5.0,
  title: Text(
    'Enjoy Travelee so far?',
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
  ),
  starSize: 20.0,
  // encourage your user to leave a high rating?
  message: Text(
    'We love to hear your feedback!',
    textAlign: TextAlign.center,
    style: const TextStyle(fontSize: 15),
  ),
  // your app's logo?
  image: Image(image: AssetImage("assets/images/logo.png"), height: 130.0),
  submitButtonText: 'Submit',
  onCancelled: () => print('cancelled'),
  onSubmitted: (response) {
    print('rating: ${response.rating}, comment: ${response.comment}');
    if (response.rating < 3.0) {
      // send their comments to your email or anywhere you wish
      // ask the user to contact you instead of leaving a bad review
    } else {}
  },
);
