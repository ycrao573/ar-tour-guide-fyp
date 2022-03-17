import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:uuid/uuid.dart';
import 'package:wikitude_flutter_app/widgets/sharingMap.dart';

class LocationSharingScreen extends StatefulWidget {
  const LocationSharingScreen({Key? key}) : super(key: key);

  @override
  _LocationSharingScreenState createState() => _LocationSharingScreenState();
}

class _LocationSharingScreenState extends State<LocationSharingScreen> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  Position? _currentPosition;
  bool isDistanceLoaded = false;

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Location sharing screen"),
          backgroundColor: Colors.orange[400],
        ),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  _getLocation();
                },
                child: Text("Add My Location",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ))),
            TextButton(
                onPressed: () {
                  _listenLocation();
                },
                child: Text("Enable Live Location",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ))),
            TextButton(
                onPressed: () {
                  _stopListening();
                },
                child: Text("Stop Live Sharing",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.orange[700],
                      fontWeight: FontWeight.w600,
                    ))),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user_location')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return !isDistanceLoaded
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                  snapshot.data!.docs[index]['name'].toString(),
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(40),
                                  child: Image.network(snapshot
                                      .data!.docs[index]['description'])),
                              subtitle: Row(
                                children: [
                                  Text(getDistanceToUser(
                                      snapshot.data!.docs[index]['longitude']
                                          .toString(),
                                      snapshot.data!.docs[index]['latitude']
                                          .toString()))
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.map_rounded),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MyMap(
                                            user_id:
                                                snapshot.data!.docs[index].id,
                                          )));
                                },
                              ),
                            );
                          });
                },
              ),
            ),
          ],
        ));
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      _getCurrentLocation();
      final user = FirebaseAuth.instance.currentUser;
      final id = Uuid().v5(Uuid.NAMESPACE_URL, user!.email);
      await FirebaseFirestore.instance.collection('user_location').doc(id).set({
        'latitude': _locationResult.latitude!,
        'longitude': _locationResult.longitude!,
        'name': user.displayName,
        'description': user.photoURL,
        'altitude': 100.0,
        'category': 'friend',
        'id': id,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    final user = FirebaseAuth.instance.currentUser;
    _getCurrentLocation();
    final id = Uuid().v5(Uuid.NAMESPACE_URL, user!.email);
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('user_location').doc(id).set({
        'latitude': currentlocation.latitude!,
        'longitude': currentlocation.longitude!,
        'name': user.displayName,
        'description': user.photoURL,
        'altitude': 100.0,
        'category': 'friend',
        'id': id,
      }, SetOptions(merge: true));
    });
  }

  String getDistanceToUser(String longitude, String latitude) {
    double long1 = double.parse(longitude) / 57.29577951;
    double lat1 = double.parse(latitude) / 57.29577951;
    double long2 = _currentPosition!.longitude / 57.29577951;
    double lat2 = _currentPosition!.latitude / 57.29577951;
    double res = 1.609344 *
        3963.0 *
        acos((sin(lat1) * sin(lat2)) +
            cos(lat1) * cos(lat2) * cos(long2 - long1));
    if (res < 1.1) {
      return res.toStringAsFixed(1) + ' km';
    } else {
      return (res * 1000).toStringAsFixed(0) + ' m';
    }
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        isDistanceLoaded = true;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _stopListening() async {
    await _locationSubscription?.cancel();
    final user = FirebaseAuth.instance.currentUser;
    final id = Uuid().v5(Uuid.NAMESPACE_URL, user!.email);
    var collection = FirebaseFirestore.instance.collection('user_location');
    await collection.doc(id).delete();
    setState(() {
      _locationSubscription = null;
    });
  }
}
