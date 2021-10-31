import 'dart:ui';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/l10n/l10n.dart';
import 'dart:async';
import 'arview.dart';
import 'sample.dart';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'arpage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      builder: (context, child) {
        final provider = Provider.of<LocaleProvider>(context);
        return MaterialApp(
          title: '',
          localizationsDelegates: [
            AppLocalizations.delegate, // Add this line
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: provider.locale,
          supportedLocales: L10n.all,// Chinese
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          home: HomePage(),
        );
      });
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  GlobalKey bottomNavigationKey = GlobalKey();
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
                'https://avatarfiles.alphacoders.com/152/thumb-152841.jpg',
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
              onclick: () {
                final FancyBottomNavigationState fState = bottomNavigationKey
                    .currentState as FancyBottomNavigationState;
                fState.setPage(2);
              }),
          TabData(
              iconData: Icons.travel_explore_sharp,
              title: AppLocalizations.of(context)!.menu_explore,
              onclick: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => ArPage()))),
          TabData(iconData: Icons.view_list_outlined, title: AppLocalizations.of(context)!.menu_plan)
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
      drawer: NavigationDrawerWidget(),
    );
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //Text(AppLocalizations.of(context)!.helloWorld),
            Text(AppLocalizations.of(context)!.helloWorld),
          ],
        );
      case 1:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the search page"),
          ],
        );
      default:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("This is the Plan page"),
          ],
        );
    }
  }
}

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
                title: Text('Favorites'),
                onTap: () => null,
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
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
                title: Text('Policies'),
                onTap: () => null,
              ),
              Divider(),
              ListTile(
                title: Text('Exit'),
                leading: Icon(Icons.exit_to_app),
                onTap: () => null,
              ),
            ],
          ),
        ));
  }
}

class LocationDropdown extends StatefulWidget {
  const LocationDropdown({Key? key}) : super(key: key);

  @override
  _LocationDropdownState createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = AppLocalizations.of(context)!.singapore;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: const Icon(Icons.arrow_drop_down_outlined),
          iconSize: 14,
          elevation: 24,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14.0,
          ),
          underline: Container(
            height: 0,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: <String>[AppLocalizations.of(context)!.singapore]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: SizedBox(
                  width: 100.0, child: Text(value, textAlign: TextAlign.right)),
            );
          }).toList(),
        ),
      ),
    );
  }
}

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
    return SettingsList(
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
            // SettingsTile.switchTile(
            //   title: 'Use fingerprint',
            //   leading: Icon(Icons.fingerprint),
            //   switchValue: isSwitched,
            //     onToggle: (value) {
            //       setState(() {
            //         isSwitched = value;
            //       });
            //     },
            // ),
          ],
        ),
      ],
    );
  }
}

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({ Key? key }) : super(key: key);

  @override
  _LanguageDropdownState createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final locale = provider.locale;
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: locale,
        icon: Container(width: 12),
        items: L10n.all.map(
          (locale) {
            final languageCode = locale.languageCode;

            return DropdownMenuItem(
              child: Text(
                L10n.getLanguage(languageCode),
                style: TextStyle(fontSize: 15),
              ),
              value: locale,
              onTap: () {
                final provider =
                    Provider.of<LocaleProvider>(context, listen: false);
                provider.setLocale(locale);
              },
            );
          },
        ).toList(),
        onChanged: (_) {},
      ),
    );
  }
}