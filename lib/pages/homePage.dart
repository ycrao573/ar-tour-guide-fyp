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
import 'settingsPage.dart';
import 'loginPage.dart';

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

  @override
  void initState() {
    super.initState();
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
          LocationDropdown(),
          LanguageDropdown(),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: _getPage(currentPage),
        ),
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(
            iconData: Icons.home_outlined,
            title: AppLocalizations.of(context)!.menu_home,
          ),
          TabData(
              iconData: Icons.travel_explore_sharp,
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(AppLocalizations.of(context)!.helloWorld),
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Welcome Back",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        (loginMethod != "Google")
                            ? "${loggedInUser.firstName} ${loggedInUser.lastName}"
                            : "${loggedInUser.displayName!}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    Text(
                        (loginMethod != "Google")
                            ? "${loggedInUser.email}"
                            : "${loggedInUser.email!}",
                        style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      height: 15,
                    ),
                    ActionChip(
                        label: Text("Logout"),
                        onPressed: () {
                          if (loginMethod != "Google")
                            logout(context);
                          else {
                            final provider = Provider.of<GoogleSignInProvider>(
                                context,
                                listen: false);
                            provider.logout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        );
      case 1:
        return ArPage();
      case 2:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the Plan page"),
          ],
        );
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
}
