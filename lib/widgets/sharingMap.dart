import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:travelee/ar/arview.dart';
import 'package:travelee/ar/sample.dart';
import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart'
    as startupConfiguration;
import 'package:http/http.dart' as http;

class MyMap extends StatefulWidget {
  final String user_id;

  const MyMap({Key? key, required this.user_id}) : super(key: key);

  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool isCurrentLocationLoading = true;
  bool _added = false;
  Position? currentLocation;
  BitmapDescriptor? avatar;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  void dispose() {
    _controller.dispose();
    currentLocation = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user_location')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            _getCurrentLocation();
            _getUserAvatar(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['description'],
            );
            if (_added) {
              mymap(snapshot);
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return isCurrentLocationLoading
                ? Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                          position: LatLng(
                            currentLocation!.latitude + 0.01,
                            currentLocation!.longitude + 0.01,
                          ),
                          markerId: MarkerId('id'),
                          infoWindow: const InfoWindow(title: 'You are Here'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen)),
                      Marker(
                          position: LatLng(
                            snapshot.data!.docs.singleWhere((element) =>
                                element.id == widget.user_id)['latitude'],
                            snapshot.data!.docs.singleWhere((element) =>
                                element.id == widget.user_id)['longitude'],
                          ),
                          infoWindow: InfoWindow(
                              title: snapshot.data!.docs.singleWhere(
                                  (element) =>
                                      element.id == widget.user_id)['name']),
                          markerId: MarkerId('id'),
                          icon: avatar!),
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                          snapshot.data!.docs.singleWhere((element) =>
                              element.id == widget.user_id)['latitude'],
                          snapshot.data!.docs.singleWhere((element) =>
                              element.id == widget.user_id)['longitude'],
                        ),
                        zoom: 14.47),
                    onMapCreated: (GoogleMapController controller) async {
                      setState(() {
                        _controller = controller;
                        _added = true;
                      });
                    },
                  );
          },
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 100.0),
          child: FloatingActionButton(
            backgroundColor: Color(0xdcffffff),
            foregroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ArViewWidget(
                            sample: new Sample(
                          name: "Friend",
                          path: 'friend/index.html',
                          requiredFeatures: ["geo"],
                          startupConfiguration:
                              new startupConfiguration.StartupConfiguration(
                                  cameraPosition:
                                      startupConfiguration.CameraPosition.BACK,
                                  cameraResolution: startupConfiguration
                                      .CameraResolution.AUTO,
                                  cameraFocusMode: startupConfiguration
                                      .CameraFocusMode.CONTINUOUS),
                          requiredExtensions: ["native_detail"],
                        ))),
              );
            },
            child: const Icon(Icons.view_in_ar_rounded),
          ),
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.user_id)['longitude'],
            ),
            zoom: 14.5)));
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentLocation = position;
        isCurrentLocationLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getUserAvatar(String url) async {
    var iconurl = Uri.parse(url);
    var dataBytes;
    var request = await http.get(iconurl);
    var bytes = request.bodyBytes;
    setState(() {
      dataBytes = bytes;
      avatar = BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List());
    });
  }
}
