import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/ar/arpage.dart';
import 'package:wikitude_flutter_app/l10n/l10n.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wikitude_flutter_app/model/googleUserModel.dart';
import 'package:wikitude_flutter_app/model/userModel.dart';
import 'package:wikitude_flutter_app/pages/imagePickerPage.dart';
import 'package:wikitude_flutter_app/pages/loginPage.dart';
import 'package:wikitude_flutter_app/pages/visionPage.dart';
import 'package:wikitude_flutter_app/service/googleSignIn.dart';
import 'package:wikitude_flutter_app/widgets/drawer.dart';
import 'package:wikitude_flutter_app/widgets/languageDropdown.dart';
import 'package:wikitude_flutter_app/widgets/locationDropdown.dart';
import 'card.dart';
import 'settingsPage.dart';
import 'loginPage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
          LocationDropdown(currentAddress: _currentAddress),
          LanguageDropdown(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Container(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        circleColor: Colors.pink,
        inactiveIconColor: Colors.grey[600],
        tabs: [
          TabData(
            iconData: Icons.home_outlined,
            title: AppLocalizations.of(context)!.menu_home,
          ),
          TabData(
              iconData: Icons.view_in_ar_outlined,
              title: AppLocalizations.of(context)!.menu_explore),
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
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 100.0),
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
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                    Text(
                        (_currentAddress == "")
                            ? ""
                            : "Discover More in $_currentAddress !",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500))
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
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = placemarks[0];
      /*
    this.name,
    this.street,
    this.isoCountryCode,
    this.country,
    this.postalCode,
    this.administrativeArea,
    this.subAdministrativeArea,
    this.locality,
    this.subLocality,
      */
      setState(() {
        _currentAddress = "${place.locality}";
      });
    } catch (e) {
      print(e);
    }
  }
}
