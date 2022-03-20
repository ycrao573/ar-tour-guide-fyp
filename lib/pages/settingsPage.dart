import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:travelee/l10n/l10n.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../locale_provider.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final List locale = [
    {'name': 'ENGLISH', 'locale': Locale('en', 'US')},
    {'name': '简体中文', 'locale': Locale('zh', 'Hans')}
  ];

  updatelanguage(Locale locale) {}

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
              title: Text('Choose a language'),
              content: Container(
                  width: double.maxFinite,
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                print(locale[index]['name']);
                                updatelanguage(locale[index]['locale']);
                              },
                              child: Text(locale[index]['name'])),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.grey);
                      },
                      itemCount: locale.length)));
        });
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Settings"),
      ),
      body: Container(
        child: SettingsList(
          sections: [
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'Account',
              tiles: [
                SettingsTile(
                  title: 'Change Username',
                  leading: Icon(Icons.person),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Change Password',
                  leading: Icon(Icons.lock),
                  onPressed: (BuildContext context) {},
                ),
                SettingsTile(
                  title: 'Language',
                  subtitle: AppLocalizations.of(context)!.language,
                  leading: Icon(Icons.language),
                  onPressed: (BuildContext context) => buildDialog(context),
                ),
                SettingsTile.switchTile(
                  title: 'Use System Theme',
                  leading: Icon(Icons.phone_android),
                  switchValue: isSwitched,
                  onToggle: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                ),
              ],
            ),
            SettingsSection(
              titlePadding: EdgeInsets.all(20),
              title: 'Notifications',
              tiles: [
                SettingsTile(
                  title: 'Security',
                  subtitle: 'Fingerprint',
                  leading: Icon(Icons.fingerprint),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
