import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wikitude_flutter_app/model/userModel.dart';
import 'package:wikitude_flutter_app/pages/loginPage.dart';
import 'package:wikitude_flutter_app/pages/settingsPage.dart';

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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                    (widget.loginMethod != "Google")?"${widget.currentUser.firstName!} ${widget.currentUser.lastName!}":"${widget.currentUser.displayName!}",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                accountEmail: Text('${widget.currentUser.email!}',
                    style: TextStyle(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      (widget.loginMethod != "Google")?'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg':"${widget.currentUser.photoURL!}",
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                          'https://i.pinimg.com/736x/43/c4/47/43c4477d6760cb0ad791eee55b0b2278.jpg')),
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(AppLocalizations.of(context)!.drawer_fav),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text(AppLocalizations.of(context)!.drawer_share),
                onTap: () => null,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text(AppLocalizations.of(context)!.drawer_settings),
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage())),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text(AppLocalizations.of(context)!.drawer_policy),
                onTap: () => null,
              ),
              Divider(),
              ListTile(
                title: Text(AppLocalizations.of(context)!.drawer_exit),
                leading: Icon(Icons.exit_to_app),
                onTap: () => logout(context),
              ),
            ],
          ),
        ));
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
