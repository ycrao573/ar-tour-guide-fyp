import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:wikitude_flutter_app/model/restaurantModel.dart';

Future<List> fetchRestaurantModel() async {
  // final response = await http
  //     .get(Uri.parse('https://jsonplaceholder.typicode.com/RestaurantModels/1'));
  final response =
      await rootBundle.loadString('assets/data/restaurant_mock.json');
  var restaurantJson = jsonDecode(response)["data"] as List;
  return restaurantJson.map((r) => RestaurantModel.fromJson(r)).toList();
  // return RestaurantModel.fromJson(jsonDecode(response)["data"]);
  // if (response.statusCode == 200) {
  //   var topShowsJson = jsonDecode(response.body)['top'] as List;
  //   return topShowsJson.map((show) => Show.fromJson(show)).toList();
  // } else {
  //   throw Exception('Failed to load shows');
  // }
  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     return RestaurantModel.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load RestaurantModel');
  //   }
}

class EatPage extends StatefulWidget {
  const EatPage({Key? key}) : super(key: key);

  @override
  _EatPageState createState() => _EatPageState();
}

class _EatPageState extends State<EatPage> {
  late Future<List> futureRestaurantModel;

  @override
  void initState() {
    super.initState();
    futureRestaurantModel = fetchRestaurantModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fetch Data Example'),
      ),
      body: Center(
        child: FutureBuilder<List>(
          future: futureRestaurantModel,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data![19].reviews[0].url.toString());
            } else if (snapshot.hasError) {
              return Text(
                  '${snapshot.error}' + snapshot.data!.length.toString());
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
