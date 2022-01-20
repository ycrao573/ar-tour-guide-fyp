import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikitude_flutter_app/widgets/counter.dart';
import 'package:wikitude_flutter_app/widgets/myheader.dart';

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
    updated = DateTime.fromMillisecondsSinceEpoch(json["updated"]);
    flag = json['countryInfo']['flag'] as String;
  }
}

class CovidScreen extends StatelessWidget {
  const CovidScreen({Key? key, required this.country}) : super(key: key);

  final String? country;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0x00ffffff),
      //   leading: IconButton(
      //     icon: Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.of(context).pop();
      //     },
      //   ),
      // ),
      body: FutureBuilder<CovidData>(
        future: fetchCovidDatas(http.Client(), country),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            // return Text(snapshot.data!.cases.toString());
            return CovidHomeScreen(country: country, data: snapshot.data);
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

class CovidHomeScreen extends StatefulWidget {
  final CovidData? data;
  final String? country;

  const CovidHomeScreen({
    Key? key,
    required this.country,
    required this.data,
  }) : super(key: key);

  @override
  _CovidHomeScreenState createState() => _CovidHomeScreenState();
}

class _CovidHomeScreenState extends State<CovidHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "Together, We Can",
              textBottom: "Brave The New",
              offset: 0.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: Color(0xFFE5E5E5),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.location_pin, color: Colors.cyan),
                  SizedBox(width: 20),
                  Expanded(
                    child: DropdownButton(
                      isExpanded: true,
                      underline: SizedBox(),
                      icon: Icon(Icons.arrow_drop_down),
                      value: widget.country,
                      items: [
                        'Singapore',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,
                              style: TextStyle(fontFamily: 'Poppins')),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0,
                              ),
                            ),
                            TextSpan(
                              text: "Newest update on " +
                                  DateFormat('kk:mm, MMM dd, yyyy')
                                      .format(widget.data!.updated),
                              style: TextStyle(
                                color: Colors.red[300],
                                fontSize: 13.0,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Spacer(),
                      // Text(
                      //   "See details",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.w600,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: Colors.purple,
                          number: widget.data!.todayCases,
                          title: "Infected",
                        ),
                        Counter(
                          color: Colors.red,
                          number: widget.data!.todayDeaths,
                          title: "Deaths",
                        ),
                        Counter(
                          color: Colors.cyan,
                          number: widget.data!.todayRecovered,
                          title: "Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          color: Colors.black45,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SecondCounter(
                          color: Colors.purple,
                          number: widget.data!.cases,
                          title: "Total Infected",
                        ),
                        SecondCounter(
                          color: Colors.red,
                          number: widget.data!.deaths,
                          title: "Total Deaths",
                        ),
                        SecondCounter(
                          color: Colors.cyan,
                          number: widget.data!.recovered,
                          title: "Total Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              _launchURL("https://www.spaceout.gov.sg/"),
                          icon: Icon(Icons.local_mall, size: 18),
                          label: Text("Check Shopping Malls",
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.green[300]),
                          ),
                          onPressed: () {
                            _launchURL("https://safedistparks.nparks.gov.sg/");
                          },
                          icon: Icon(Icons.park_outlined, size: 18),
                          label: Text("Check Parks",
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.red[300]),
                          ),
                          onPressed: () {
                            _launchURL(
                                "https://d209m3w127yzkd.cloudfront.net/index.html");
                          },
                          icon: Icon(Icons.place_outlined, size: 18),
                          label: Text("Check Covid Hotspots",
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        child: ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue[400]),
                          ),
                          onPressed: () {
                            _launchURL("https://flu.gowhere.gov.sg/");
                          },
                          icon: Icon(Icons.local_hospital, size: 18),
                          label: Text("See Clinic List",
                              style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            "  If you need to travel abroad,\nkindly refer to MFA's information:",
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          height: 100,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue[900]),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.black),
                                alignment: Alignment(3, 0)),
                            onPressed: () {
                              _launchURL(
                                  "https://www.mfa.gov.sg/Services/Singapore-Citizens/COVID-19-Travel-Restrictions");
                            },
                            icon: ImageIcon(
                              NetworkImage(
                                  "https://www.mfa.gov.sg/Cwp/assets/MFA/img/mfa-logo.png"),
                              size: 160,
                              color: Colors.white,
                            ),
                            label: Text(""),
                          ),
                        ),
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                            "Alternatively, you can use border restriction \n    checking tool provided by Skyscanner",
                            style: TextStyle(
                              fontSize: 16.0,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 180,
                          height: 100,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shadowColor:
                                    MaterialStateProperty.all(Colors.black),
                                alignment: Alignment(0.25, 0)),
                            onPressed: () {
                              _launchURL(
                                  "https://www.skyscanner.com.sg/travel-restrictions");
                            },
                            icon: ImageIcon(
                              NetworkImage(
                                  "https://1000logos.net/wp-content/uploads/2020/08/Skyscanner-Logo.png"),
                              size: 120,
                              color: Colors.blue,
                            ),
                            label: Text(""),
                          ),
                        ),
                      ),
                    ],
                  )

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: <Widget>[
                  //     Text(
                  //       "Spread of Virus",
                  //     ),
                  //     Text(
                  //       "See details",
                  //       style: TextStyle(
                  //         fontWeight: FontWeight.w600,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 20),
                  //   padding: EdgeInsets.all(20),
                  //   height: 178,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     color: Colors.white,
                  //     boxShadow: [
                  //       BoxShadow(
                  //         offset: Offset(0, 4),
                  //         blurRadius: 6,
                  //         color: Colors.black45,
                  //       ),
                  //     ],
                  //   ),
                  //   child: Image.asset(
                  //     "assets/images/map.png",
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
