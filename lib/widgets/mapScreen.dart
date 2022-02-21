import 'dart:async';

import 'package:augmented_reality_plugin_wikitude/startupConfiguration.dart'
    as startupConfiguration;
import 'package:augmented_reality_plugin_wikitude/wikitude_response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wikitude_flutter_app/ar/arview.dart';
import 'package:wikitude_flutter_app/ar/sample.dart';
import 'package:wikitude_flutter_app/widgets/placeSearch.dart';
import 'package:wikitude_flutter_app/widgets/placeService.dart';
import 'package:uuid/uuid.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Completer<GoogleMapController> _mapController = Completer();
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3444711, 103.6872788),
    zoom: 11.5,
  );
  static const kGoogleApiKey = "AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0";
  Position? currentLocation;
  List<PlaceSearch> searchResults = [];
  GoogleMapController? _googleMapController;
  StreamController<Place> selectedLocation = StreamController<Place>();
  Marker? _origin;
  Marker? _destination;

  @override
  void dispose() {
    _googleMapController!.dispose();
    selectedLocation.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    selectedLocation.stream.listen((place) {
      if (place != null) {
        _goToPlace(place);
      }
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Explore Map'),
        backgroundColor: Colors.orange[300],
        actions: [
          if (_origin != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _origin!.position,
                    zoom: 15,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.green,
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('ORIGIN'),
            ),
          if (_destination != null)
            TextButton(
              onPressed: () => _googleMapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _destination!.position,
                    zoom: 15,
                    tilt: 50.0,
                  ),
                ),
              ),
              style: TextButton.styleFrom(
                primary: Colors.red[800],
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
              ),
              child: const Text('DEST'),
            )
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: (currentLocation == null)
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '  Search Location...',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) => _searchPlaces(value),
                  ),
                ),
                Stack(
                  children: [
                    SizedBox(
                      height: 638,
                      child: GoogleMap(
                        myLocationEnabled: true,
                        indoorViewEnabled: true,
                        initialCameraPosition: _initialCameraPosition,
                        onMapCreated: (controller) =>
                            _googleMapController = controller,
                        markers: {
                          if (_origin != null) _origin!,
                          if (_destination != null) _destination!,
                        },
                        onLongPress: _addMarker,
                      ),
                    ),
                    if (searchResults.length != 0)
                      Stack(
                        children: [
                          Container(
                              height: 633,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.55),
                                backgroundBlendMode: BlendMode.darken,
                              )),
                          Container(
                              height: 633,
                              child: ListView.builder(
                                itemCount: searchResults.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                      title: Text(
                                          searchResults[index].description,
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onTap: () {
                                        _setSelectedLocation(
                                            searchResults[index].placeId);
                                      });
                                },
                              )),
                        ],
                      ),
                  ],
                ),
              ],
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
                        name: "Customized",
                        path: 'customized/index.html',
                        requiredFeatures: ["geo"],
                        startupConfiguration:
                            new startupConfiguration.StartupConfiguration(
                                cameraPosition:
                                    startupConfiguration.CameraPosition.BACK,
                                cameraResolution:
                                    startupConfiguration.CameraResolution.AUTO,
                                cameraFocusMode: startupConfiguration
                                    .CameraFocusMode.CONTINUOUS),
                        requiredExtensions: ["native_detail"],
                      ))),
            );
          },
          child: const Icon(Icons.view_in_ar_rounded),
        ),
      ),
    );
  }

  Future<void> _addMarker(LatLng pos) async {
    setState(() {
      _destination = Marker(
        markerId: const MarkerId('destination'),
        infoWindow: const InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: pos,
      );
      FirebaseFirestore.instance.collection('diy_places').doc().set(
        {
          "id": Uuid().v1(),
          "longitude": pos.longitude.toString(),
          "latitude": pos.latitude.toString(),
          "name": "Destination",
          "description": " ",
          "altitude": "100.0",
          "category": "Customized"
        },
      );
    });
  }

  Future<void> _goToPlace(Place place) async {
    _googleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(place.geometry.location.lat, place.geometry.location.lng),
      zoom: 14.0,
    )));
    setState(() {
      _destination = Marker(
          markerId: MarkerId(place.name),
          infoWindow: InfoWindow(title: place.name),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position:
              LatLng(place.geometry.location.lat, place.geometry.location.lng));
      FirebaseFirestore.instance.collection('diy_places').doc().set(
        {
          "id": Uuid().v1(),
          "longitude": place.geometry.location.lat.toString(),
          "latitude": place.geometry.location.lng.toString(),
          "name": place.name,
          "description": place.vicinity,
          "altitude": "100.0",
          "category": "Customized"
        },
      );
    });
  }

  _getCurrentLocation() async {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        currentLocation = position;
        _origin = Marker(
            markerId: const MarkerId('origin'),
            infoWindow: const InfoWindow(title: 'You are here!'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: LatLng(position.latitude, position.longitude));
        _destination = _origin;
        // dynamic _destination = Marker(
        //     markerId: const MarkerId('destination'),
        //     infoWindow: const InfoWindow(title: 'Destination'),
        //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        //     position: LatLng(1.3444711, 103.6872788));
      });
    }).catchError((e) {
      print(e);
    });
  }

  _searchPlaces(String searchTerm) async {
    var results = await PlacesService().getAutocomplete(searchTerm);
    setState(() {
      searchResults = results;
    });
  }

  _setSelectedLocation(String placeId) async {
    var location = await PlacesService().getPlace(placeId);

    setState(() {
      selectedLocation.add(location);
      searchResults = [];
    });
  }
}
