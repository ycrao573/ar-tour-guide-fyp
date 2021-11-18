import 'dart:ui';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_plugin.dart';
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/l10n/l10n.dart';
import 'dart:async';
import 'theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'locale_provider.dart';
import 'package:provider/provider.dart';
import 'pages/settingsPage.dart';
import 'pages/homePage.dart';

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
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: provider.locale,
          supportedLocales: L10n.all,
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          home: HomePage(),
        );
      });
}
