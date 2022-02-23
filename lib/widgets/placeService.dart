import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:wikitude_flutter_app/widgets/placeSearch.dart';

class PlacesService {
  static const kGoogleApiKey = "AIzaSyBhQ60FpF7ytOVR2DlMvrBI-FL3l_Sopu0";
  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=establishment&components=country:sg&key=$kGoogleApiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;
    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url =
        'https://maps.googleapis.com/maps/api/place/details/json?key=$kGoogleApiKey&place_id=$placeId';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }
}
