import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<CovidData> fetchCovidDatas(http.Client client, String? country) async {
  final response = await client.get(Uri.parse(
      'https://corona.lmao.ninja/v2/countries/$country?yesterday=true&strict=true&query'));
  return CovidData.fromJson(jsonDecode(response.body));
}

class CovidData {
  late int cases;
  late int todayCases;
  late int deaths;
  late int todayDeaths;
  late int recovered;
  late int todayRecovered;
  late int active;
  late DateTime updated;
  late String flag;

  CovidData({
    required this.cases,
    required this.todayCases,
    required this.deaths,
    required this.todayDeaths,
    required this.recovered,
    required this.todayRecovered,
    required this.active,
    required this.updated,
    required this.flag,
  });

  CovidData.fromJson(Map<String, dynamic> json) {
    cases = json['cases'] as int;
    todayCases = json['todayCases'] as int;
    deaths = json['deaths'] as int;
    todayDeaths = json['todayDeaths'] as int;
    recovered = json['recovered'] as int;
    todayRecovered = json['todayRecovered'] as int;
    active = json['active'] as int;
    updated = DateTime.fromMillisecondsSinceEpoch(json["updated"] * 1000);
    flag = json['countryInfo']['flag'] as String;
  }
}

class CovidScreen extends StatelessWidget {
  const CovidScreen({Key? key, required this.country}) : super(key: key);

  final String? country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country!),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: FutureBuilder<CovidData>(
        future: fetchCovidDatas(http.Client(), country),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Text(snapshot.data!.cases.toString());
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
