import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Location sharing screen")),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  _getLocation();
                },
                child: Text("Add My Location")),
            TextButton(
                onPressed: () {
                  _listenLocation();
                },
                child: Text("Enable Live Location")),
            TextButton(
                onPressed: () {
                  _stopListening();
                },
                child: Text("Stop Live Sharing")),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('user_location')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                              snapshot.data!.docs[index]['name'].toString()),
                          subtitle: Row(
                            children: [
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                              SizedBox(
                                width: 20,
                              ),
                              Text(snapshot.data!.docs[index]['longitude']
                                  .toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.directions),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyMap(
                                        user_id: snapshot.data!.docs[index].id,
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
