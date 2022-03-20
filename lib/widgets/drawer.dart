import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:travelee/model/userModel.dart';
import 'package:travelee/pages/loginPage.dart';
import 'package:travelee/pages/settingsPage.dart';
import 'package:travelee/service/googleSignIn.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final dynamic currentUser;
  final String loginMethod;

  const NavigationDrawerWidget(
      {Key? key, required this.currentUser, required this.loginMethod})
      : super(key: key);

  @override
  _NavigationDrawerWidgetState createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        child: Drawer(
          child: Container(
            color: Color(0xff85ccd8),
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                      (widget.loginMethod != "Google")
                          ? "${widget.currentUser.firstName!} ${widget.currentUser.lastName!}"
                          : "${widget.currentUser.displayName!}",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0)),
                  accountEmail: Text('${widget.currentUser.email!}',
                      style: TextStyle(color: Colors.black, fontSize: 15.0)),
                  currentAccountPicture: CircleAvatar(
                    child: ClipOval(
                      child: Image.network(
                        (widget.loginMethod != "Google")
                            ? 'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg'
                            : "${widget.currentUser.photoURL!}",
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Color(0xff85ccd8),
                  //   image: DecorationImage(
                  //       fit: BoxFit.fill,
                  //       image: NetworkImage(
                  //           'https://i.pinimg.com/736x/43/c4/47/43c4477d6760cb0ad791eee55b0b2278.jpg')),
                  // ),
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text(AppLocalizations.of(context)!.drawer_fav,
                      style: TextStyle(fontSize: 15.0)),
                  onTap: () => null,
                ),
                ListTile(
                  leading: Icon(Icons.share),
                  title: Text(AppLocalizations.of(context)!.drawer_share,
                      style: TextStyle(fontSize: 15.0)),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text(AppLocalizations.of(context)!.drawer_settings,
                      style: TextStyle(fontSize: 15.0)),
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingPage())),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text("Contact Us", style: TextStyle(fontSize: 15.0)),
                  onTap: () => null,
                ),
                Divider(),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.drawer_exit,
                      style: TextStyle(
                          fontSize: 15.0,
                          color: Colors.red[900],
                          fontWeight: FontWeight.w700)),
                  leading: Icon(
                    Icons.logout,
                    color: Colors.red[900],
                  ),
                  onTap: () => (widget.loginMethod != "Google")
                      ? logout(context)
                      : google_logout(context),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> google_logout(BuildContext context) async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
