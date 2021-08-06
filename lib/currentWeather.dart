import 'dart:convert';

import 'package:flutter/material.dart';

import 'models/weather.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot != null) {
            this._weather = snapshot.data;
            if (this._weather == null) {
              return Text("Error getting weather.");
            } else {
              return weatherBox(_weather);
            }
          } else {
            return CircularProgressIndicator();
          }
        },
        future: getCurrentWeather(),
      )),
    );
  }

  Widget weatherBox(Weather _weather) {
    return Column(
      children: <Widget>[
        Text("${_weather.temp}°C"),
        Text("${_weather.description}"),
        Text("Feels:${_weather.feelsLike}°C"),
        Text("H:${_weather.high}°C L:${_weather.low}°C"),
      ],
    );
  }

  Future getCurrentWeather() async {
    Weather? weather = null;
    String city = "berlin";
    String apiKey = "2e860b5c1309086f1543c5c566ae9d68";
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&app_id=$apiKey&units=metric";
    final response = await http.get(url);

    // if get data successfully
    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    } else {
      // TODO: throw error
    }

    return weather;
  }
}
