import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:wikitude_flutter_app/l10n/l10n.dart';
import 'dart:async';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wikitude_flutter_app/widgets/languageDropdown.dart';
import 'package:wikitude_flutter_app/widgets/locationDropdown.dart';
import 'settingsPage.dart';

class LocationDropdown extends StatefulWidget {
  final String currentAddress;

  const LocationDropdown({Key? key, required this.currentAddress})
      : super(key: key);

  @override
  _LocationDropdownState createState() => _LocationDropdownState();
}

class _LocationDropdownState extends State<LocationDropdown> {
  @override
  Widget build(BuildContext context) {
    String dropdownValue = widget.currentAddress;
    // AppLocalizations.of(context)!.singapore;
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
          items: <String>[
            /*AppLocalizations.of(context)!.singapore*/ widget.currentAddress
          ].map<DropdownMenuItem<String>>((String value) {
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
