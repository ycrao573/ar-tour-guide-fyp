import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travelee/l10n/l10n.dart';
import 'package:travelee/model/userModel.dart';
import 'package:travelee/pages/loginPage.dart';
import 'package:travelee/pages/onboardingScreen.dart';
import 'package:travelee/service/googleSignIn.dart';
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
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          builder: (context, child) {
            final provider = Provider.of<LocaleProvider>(context);
            final user = FirebaseAuth.instance.currentUser;
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
              home: user == null
                  ? LoginPage()
                  : user.displayName != ''
                      ? HomePage(loginMethod: 'Google')
                      : HomePage(loginMethod: 'Email'),
              // home: OnboardingScreen(),
            );
          }));
}
