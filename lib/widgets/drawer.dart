import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wikitude_flutter_app/pages/settingsPage.dart';

class NavigationDrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName:
                    Text('Yuchen Rao', style: TextStyle(color: Colors.black)),
                accountEmail: Text('myexample@gmail.com',
                    style: TextStyle(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg',
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
                onTap: () => null,
              ),
            ],
          ),
        ));
  }
}
