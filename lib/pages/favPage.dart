import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wikitude_flutter_app/model/activityModel.dart';
import 'package:wikitude_flutter_app/model/attractionModel.dart';
import 'package:wikitude_flutter_app/model/restaurantModel.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List favRestaurants = [];
  List favActivities = [];
  List favAttractions = [];
  late Future<List> favActivityList;
  late Future<List> favAttractionList;
  late Future<List> favRestaurantList;
  bool loading = true;

  var user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadFavList();
  }

  _loadFavList() async {
    var email = user!.email!;
    FirebaseFirestore.instance
        .collection("activties")
        .doc(email)
        .get()
        .then((value) {
      setState(() {
        favActivityList = fetchActivityModel(value.data()!["places"]);
      });
    });
    FirebaseFirestore.instance
        .collection("attractions")
        .doc(email)
        .get()
        .then((value) {
      setState(() {
        favAttractionList = fetchAttractionModel(value.data()!["places"]);
        loading = false;
      });
    });
    favRestaurantList = fetchRestaurantModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: Text("Favorites")),
      body: loading
          ? Center(child: const CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 80),
                    FutureBuilder<List>(
                      future: favAttractionList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = _getAttractionTile(snapshot.data!);
                          return MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        AttractionPopUp(data[index]),
                                itemCount: data.length,
                              ));
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}' +
                              snapshot.data!.length.toString());
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),
                    FutureBuilder<List>(
                      future: favActivityList,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = _getActivityTile(snapshot.data!);
                          return MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) =>
                                  ActivityPopUp(data[index]),
                              itemCount: data.length,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}' +
                              snapshot.data!.length.toString());
                        }
                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      },
                    ),

                    // FutureBuilder<List>(
                    //   future: favRestaurantList,
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return Text(
                    //           snapshot.data![19].reviews[0].url.toString());
                    //     } else if (snapshot.hasError) {
                    //       return Text('${snapshot.error}' +
                    //           snapshot.data!.length.toString());
                    //     }
                    //     // By default, show a loading spinner.
                    //     return const CircularProgressIndicator();
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<List> fetchActivityModel(List list) async {
    final response =
        await rootBundle.loadString('assets/data/activities_data.json');
    var activitiesJson = jsonDecode(response) as List;
    var places = activitiesJson.map((r) => ActivityModel.fromJson(r)).toList();
    print(list);
    return places.where((i) => list.contains(i.id.toString())).toList();
  }

  Future<List> fetchAttractionModel(List list) async {
    final response =
        await rootBundle.loadString('assets/data/attractions_data.json');
    var attractionJson = jsonDecode(response) as List;
    var places =
        attractionJson.map((r) => AttractionModel.fromJson(r)).toList();
    return places.where((i) => list.contains(i.id.toString())).toList();
  }

  Future<List> fetchRestaurantModel() async {
    final response =
        await rootBundle.loadString('assets/data/restaurant_mock.json');
    var restaurantJson = jsonDecode(response)["data"] as List;
    return restaurantJson.map((r) => RestaurantModel.fromJson(r)).toList();
  }

  List<ActivityTile> _getActivityTile(List data) {
    return [
      ActivityTile("My Favorite Activities",
          children: data
              .map((r) => ActivityTile(r.title,
                  image: r.imageUrl,
                  description: r.description,
                  latitude: r.latitude,
                  longitude: r.longitude))
              .toList())
    ];
  }

  List<AttractionTile> _getAttractionTile(List data) {
    return [
      AttractionTile("My Favorite Attractions",
          children: data
              .map((r) => AttractionTile(r.name,
                  image: r.photourl,
                  description: r.description,
                  latitude: r.latitude,
                  longitude: r.longitude))
              .toList())
    ];
  }
}

class ActivityTile {
  ActivityTile(this.title,
      {this.children = const <ActivityTile>[],
      this.image = "",
      this.latitude = "",
      this.longitude = "",
      this.description = ""});
  final String title;
  final String image;
  final String latitude;
  final String longitude;
  final String description;
  final List<ActivityTile> children;
}

class ActivityPopUp extends StatelessWidget {
  const ActivityPopUp(this.popup);

  final ActivityTile popup;

  Widget _buildTiles(ActivityTile root) {
    if (root.image != "" && root.children.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ListTile(
            key: PageStorageKey<ActivityTile>(root),
            leading: SizedBox(child: Image.network(root.image)),
            trailing: Icon(Icons.favorite, color: Colors.red[400]),
            title: Column(
              children: [
                Text(root.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ExpansionTile(
            key: PageStorageKey<ActivityTile>(root),
            title: Text(root.title,
                style: TextStyle(
                    color: Colors.cyan[600], fontWeight: FontWeight.bold)),
            children: root.children.map<Widget>(_buildTiles).toList(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}

class AttractionTile {
  AttractionTile(this.title,
      {this.children = const <AttractionTile>[],
      this.image = "",
      this.latitude = "",
      this.longitude = "",
      this.description = ""});
  final String title;
  final String image;
  final String latitude;
  final String longitude;
  final String description;
  final List<AttractionTile> children;
}

class AttractionPopUp extends StatelessWidget {
  const AttractionPopUp(this.popup);

  final AttractionTile popup;

  Widget _buildTiles(AttractionTile root) {
    if (root.image != "" && root.children.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ListTile(
            key: PageStorageKey<AttractionTile>(root),
            leading: SizedBox(child: Image.network(root.image)),
            trailing: Icon(Icons.favorite, color: Colors.red[400]),
            title: Column(
              children: [
                Text(root.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
              ],
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          child: ExpansionTile(
            key: PageStorageKey<AttractionTile>(root),
            title: Text(root.title,
                style: TextStyle(
                    color: Colors.cyan[600], fontWeight: FontWeight.bold)),
            children: root.children.map<Widget>(_buildTiles).toList(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(popup);
  }
}
